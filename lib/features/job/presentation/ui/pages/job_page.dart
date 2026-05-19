import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/custom_svg.dart';
import '../../../../../core/main_widgets/app_footer.dart';
import '../../../../../core/main_widgets/app_navbar.dart';
import '../../../../../core/theme/appcolors.dart';
import '../../../../home/presentation/controller/home_cubit.dart';
import '../../../../home/presentation/controller/home_state.dart';
import '../../../../home/presentation/controller/lang_state.dart';
import '../../../data/model/job__model.dart';
import '../../controller/job_cubit.dart';
import '../../controller/job_state.dart';


const Color _kGreen      = Color(0xFF2D8C4E);
const Color _kGreenLight = Color(0xFFE8F5EE);
const Color _kDivider    = Color(0xFFDDE8DD);

// ─── Helper: parse hex color from Firebase branding ──────────────────────────

Color _parseColor(String hex, {required Color fallback}) {
  try {
    final h = hex.replaceAll('#', '');
    if (h.length == 6) return Color(int.parse('FF$h', radix: 16));
  } catch (_) {}
  return fallback;
}

// ─── Hardcoded department EN → AR map ────────────────────────────────────────

const Map<String, String> _kDeptAr = {
  'Design':      'تصميم',
  'Engineering': 'هندسة',
  'Marketing':   'تسويق',
  'HR':          'موارد بشرية',
  'Finance':     'مالية',
};

// ─── Localization strings ─────────────────────────────────────────────────────

class _L {
  final bool isAr;
  const _L(this.isAr);

  String get heroTitle        => isAr ? 'أطلق إمكاناتك في العالم الرقمي'               : 'Unlock Your Potential in the Digital World';
  String get sectionTitle     => isAr ? 'الوظائف المتاحة في بياناتز'                   : 'Job Listings at Bayanatz';
  String get allLabel         => isAr ? 'الكل'                                         : 'All';
  String get noJobsAll        => isAr ? 'لا توجد وظائف متاحة حالياً.'                  : 'No job openings available at the moment.';
  String noJobsDept(String d) => isAr ? 'لا توجد وظائف في "$d"'                       : 'No jobs found for "$d"';
  String get errorMsg         => isAr ? 'فشل تحميل الوظائف. يتم عرض البيانات المحفوظة.' : 'Failed to load jobs. Showing cached data.';
  String get retry            => isAr ? 'إعادة المحاولة'                               : 'Retry';
  String get linkCopied       => isAr ? 'تم نسخ الرابط!'                              : 'Link Copied!';
  String get hireDate         => isAr ? 'تاريخ التعيين المتوقع'                        : 'Expected Hire Date';
  String get experience       => isAr ? 'سنوات الخبرة'                                : 'Year Of Experience';
  String get employmentType   => isAr ? 'نوع التوظيف'                                 : 'Employment Type';
  String get compensation     => isAr ? 'نطاق الراتب'                                 : 'Compensation Range';
  String get qualification    => isAr ? 'المؤهل المطلوب'                              : 'Required Qualification';
  String get skillsLabel      => isAr ? 'المهارات:'                                   : 'Skills:';
  String get locationLabel    => isAr ? 'القاهرة، مصر'                                : 'Cairo, Egypt';
  String get viewJob          => isAr ? 'عرض الوظيفة'                                : 'VIEW JOB';
  String get untitled         => isAr ? 'بدون عنوان'                                 : 'Untitled';
  TextDirection get dir       => isAr ? TextDirection.rtl : TextDirection.ltr;
}

// ─── Department display record ────────────────────────────────────────────────

typedef _DeptItem = ({String display, String key});

// ─── Job Listings Page ────────────────────────────────────────────────────────

class JobListingsPage extends StatefulWidget {
  const JobListingsPage({super.key});

  @override
  State<JobListingsPage> createState() => _JobListingsPageState();
}

class _JobListingsPageState extends State<JobListingsPage> {
  /// Selected department raw EN key. null = "All".
  String? _selectedDept;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<JobListingCubit>();
    if (cubit.state is JobListingInitial || cubit.allJobs.isEmpty) {
      cubit.loadJobs();
    }
    // ✅ Ensure HomeCmsCubit is loaded (branding colors)
    context.read<HomeCmsCubit>().load();
  }

  List<JobPostModel> _getActiveJobs(List<JobPostModel> all) => all
      .where((j) =>
  j.status == JobStatus.active && j.publishStatus == 'published')
      .toList();

  /// Returns localized display label + raw EN key for each unique department.
  /// Uses hardcoded [_kDeptAr] map for Arabic translation.
  List<_DeptItem> _departments(List<JobPostModel> active, bool isAr) {
    final keys = <String>{};
    for (final j in active) {
      if (j.department.isNotEmpty) keys.add(j.department);
    }

    final items = keys.map((key) {
      String display = key;
      if (isAr) {
        // Try exact match first, then case-insensitive fallback
        display = _kDeptAr[key] ??
            _kDeptAr.entries
                .firstWhere(
                  (e) => e.key.toLowerCase() == key.toLowerCase(),
              orElse: () => MapEntry(key, key),
            )
                .value;
      }
      return (display: display, key: key);
    }).toList()
      ..sort((a, b) => a.display.compareTo(b.display));

    return items;
  }

  List<JobPostModel> _applyFilter(List<JobPostModel> active) {
    if (_selectedDept == null) return active;
    return active
        .where((j) =>
    j.department.toLowerCase() == _selectedDept!.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final double contentW = (339.w * 4) + (12.w * 3);

    // ✅ Wrap with HomeCmsCubit BlocBuilder for dynamic background color
    return BlocBuilder<HomeCmsCubit, HomeCmsState>(
      builder: (context, homeState) {

        final Color backgroundColor = switch (homeState) {
          HomeCmsLoaded(:final data) => _parseColor(
              data.branding.backgroundColor,
              fallback: AppColors.background),
          HomeCmsSaved(:final data) => _parseColor(
              data.branding.backgroundColor,
              fallback: AppColors.background),
          _ => AppColors.background,
        };

        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, langState) {
            final l = _L(langState.isArabic);

            return BlocBuilder<JobListingCubit, JobListingState>(
              builder: (context, state) {

                // ── Loading ──────────────────────────────────────────────────
                if (state is JobListingInitial || state is JobListingLoading) {
                  return Scaffold(
                    backgroundColor: backgroundColor,
                    body: Column(
                      children: [
                        Material(
                          color: backgroundColor,
                          elevation: 0,
                          child: AppNavbar(currentRoute: '/careers'),
                        ),
                        const Expanded(
                          child: Center(
                            child: CircularProgressIndicator(color: _kGreen),
                          ),
                        ),
                        const AppFooter(),
                      ],
                    ),
                  );
                }

                // ── Extract jobs ─────────────────────────────────────────────
                List<JobPostModel> allJobs = [];
                if (state is JobListingLoaded) {
                  allJobs = state.jobs;
                } else if (state is JobListingError && state.lastJobs != null) {
                  allJobs = state.lastJobs!;
                } else {
                  allJobs = context.read<JobListingCubit>().allJobs;
                }

                final activeJobs  = _getActiveJobs(allJobs);
                final departments = _departments(activeJobs, l.isAr);

                // Reset stale selection
                if (_selectedDept != null &&
                    !departments.any((d) => d.key == _selectedDept)) {
                  _selectedDept = null;
                }

                final filteredJobs = _applyFilter(activeJobs);

                return Directionality(
                  textDirection: l.dir,
                  child: Scaffold(
                    backgroundColor: backgroundColor,
                    body: Column(
                      children: [
                        Material(
                          color: backgroundColor,
                          elevation: 0,
                          child: AppNavbar(currentRoute: '/careers'),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 48.h),
                                  SizedBox(
                                    width: 1000.w,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: SizedBox(
                                            width: contentW,
                                            child: Text(
                                              l.heroTitle,
                                              textAlign: l.isAr ? TextAlign.right : TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 40.sp,
                                                fontWeight: FontWeight.w700,
                                                color: _kGreen,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 32.h),
                                        Center(
                                          child: SizedBox(
                                            width: contentW,
                                            child: Container(
                                              padding: EdgeInsets.all(6.r),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10.r),
                                              ),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    _FilterTab(
                                                      label: l.allLabel,
                                                      isSelected: _selectedDept == null,
                                                      onTap: () => setState(() => _selectedDept = null),
                                                    ),
                                                    ...departments.map(
                                                          (dept) => _FilterTab(
                                                        label: dept.display,
                                                        isSelected: _selectedDept == dept.key,
                                                        onTap: () => setState(() => _selectedDept = dept.key),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 28.h),
                                        Center(
                                          child: SizedBox(
                                            width: contentW,
                                            child: Text(
                                              l.sectionTitle,
                                              textAlign: l.isAr ? TextAlign.right : TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 22.sp,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        if (state is JobListingError)
                                          Center(
                                            child: SizedBox(
                                              width: contentW,
                                              child: Container(
                                                margin: EdgeInsets.only(bottom: 16.h),
                                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFFEBEE),
                                                  borderRadius: BorderRadius.circular(8.r),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.error_outline, color: const Color(0xFFE53935), size: 18.sp),
                                                    SizedBox(width: 10.w),
                                                    Expanded(
                                                      child: Text(
                                                        l.errorMsg,
                                                        style: TextStyle(fontSize: 12.sp, color: const Color(0xFFE53935)),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () => context.read<JobListingCubit>().loadJobs(),
                                                      child: Text(
                                                        l.retry,
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontWeight: FontWeight.w600,
                                                          color: _kGreen,
                                                          decoration: TextDecoration.underline,
                                                          decorationColor: _kGreen,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        Center(
                                          child: SizedBox(
                                            width: contentW,
                                            child: Column(
                                              children: filteredJobs.isEmpty
                                                  ? [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 48.h),
                                                  child: Text(
                                                    _selectedDept == null
                                                        ? l.noJobsAll
                                                        : l.noJobsDept(
                                                      departments
                                                          .firstWhere(
                                                            (d) => d.key == _selectedDept,
                                                        orElse: () => (display: _selectedDept!, key: _selectedDept!),
                                                      )
                                                          .display,
                                                    ),
                                                    style: TextStyle(fontSize: 14.sp, color: Colors.black45),
                                                  ),
                                                ),
                                              ]
                                                  : filteredJobs
                                                  .map((job) => Padding(
                                                padding: EdgeInsets.only(bottom: 16.h),
                                                child: _JobCard(job: job, l: l),
                                              ))
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 64.h),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const AppFooter(),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

// ─── Filter Tab ───────────────────────────────────────────────────────────────

class _FilterTab extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterTab(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  State<_FilterTab> createState() => _FilterTabState();
}

class _FilterTabState extends State<_FilterTab> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Color hoverBg = Color.lerp(Colors.white, _kGreen, 0.10)!;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: EdgeInsets.only(right: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? _kGreen
                : (_hovered ? hoverBg : Colors.transparent),
            borderRadius: BorderRadius.circular(7.r),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: widget.isSelected
                  ? Colors.white
                  : (_hovered ? _kGreen : Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Job Card ─────────────────────────────────────────────────────────────────

class _JobCard extends StatefulWidget {
  final JobPostModel job;
  final _L l;
  const _JobCard({required this.job, required this.l});

  @override
  State<_JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<_JobCard> {
  bool _hovered = false;

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  String _pick(String en, String ar) {
    if (widget.l.isAr) return ar.isNotEmpty ? ar : en;
    return en.isNotEmpty ? en : ar;
  }

  String get _salaryDisplay {
    final j = widget.job;
    if (j.salaryMax > 0) {
      return '${j.salaryMin.toInt()} - ${j.salaryMax.toInt()} ${j.salaryCurrency}';
    }
    if (j.salaryMin > 0) return '${j.salaryMin.toInt()} ${j.salaryCurrency}';
    return '—';
  }

  String get _experienceDisplay {
    if (widget.job.employmentDurationText.isNotEmpty) {
      return widget.job.employmentDurationText;
    }
    return widget.job.experienceLevel.label;
  }

  @override
  Widget build(BuildContext context) {
    final job   = widget.job;
    final l     = widget.l;
    final title = _pick(job.title.en, job.title.ar);
    final qual  = _pick(
        job.requiredQualification.en, job.requiredQualification.ar);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.all(25.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Title + share ────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title.isEmpty ? l.untitled : title,
                    textAlign: l.isAr ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: () {
                    final ts   = DateTime.now().millisecondsSinceEpoch;
                    final base = Uri.base.origin;
                    final slug = title.toLowerCase().replaceAll(' ', '-');
                    final url  = '$base/jobs/${job.id}?title=$slug&t=$ts';
                    Clipboard.setData(ClipboardData(text: url));
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => Directionality(
                        textDirection: l.dir,
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r)),
                          title: Text(
                            l.linkCopied,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: _kGreen,
                            ),
                          ),
                          content: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: _kGreenLight,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: _kDivider),
                            ),
                            child: Text(
                              url,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF008037),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.share_outlined,
                        size: 18.sp, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Divider(color: _kDivider, height: 1),
            SizedBox(height: 14.h),

            // ── Info rows ────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                    child: _InfoItem(
                        label: l.hireDate,
                        value: _formatDate(job.hiringStartDate))),
                Expanded(
                    child: _InfoItem(
                        label: l.experience,
                        value: _experienceDisplay)),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                    child: _InfoItem(
                        label: l.employmentType,
                        value: job.workType.label)),
                Expanded(
                    child: _InfoItem(
                        label: l.compensation,
                        value: _salaryDisplay)),
              ],
            ),
            SizedBox(height: 10.h),

            _InfoItem(
              label: l.qualification,
              value: qual.isEmpty ? '—' : qual,
            ),
            SizedBox(height: 14.h),

            // ── Skills ───────────────────────────────────────────────────
            if (job.requiredSkills.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    l.skillsLabel,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: job.requiredSkills
                          .map((s) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          _pick(s.name.en, s.name.ar),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],

            // ── Location + View button ───────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomSvg(
                      assetPath: "assets/images/careers/location.svg",
                      width: 21.w,
                      height: 26.h,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      l.locationLabel,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
                _ViewJobBtn(jobId: job.id, label: l.viewJob),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Info Item ────────────────────────────────────────────────────────────────

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: _kGreen,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── View Job Button ──────────────────────────────────────────────────────────

class _ViewJobBtn extends StatefulWidget {
  final String jobId;
  final String label;
  const _ViewJobBtn({required this.jobId, required this.label});

  @override
  State<_ViewJobBtn> createState() => _ViewJobBtnState();
}

class _ViewJobBtnState extends State<_ViewJobBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/jobs/${widget.jobId}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFF1B6B38) : _kGreen,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}