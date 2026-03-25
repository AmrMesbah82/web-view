import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:website_app/controller/job_list/job_listing_cubit.dart';
import 'package:website_app/controller/job_list/job_listing_state.dart';
import 'package:website_app/model/job_listing_model.dart';
import '../core/custom_svg.dart';
import '../theme/appcolors.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_navbar.dart';

const Color _kGreen      = Color(0xFF2D8C4E);
const Color _kGreenLight = Color(0xFFE8F5EE);
const Color _kDivider    = Color(0xFFDDE8DD);

// ─── Job Listings Page ────────────────────────────────────────────────────────

class JobListingsPage extends StatefulWidget {
  const JobListingsPage({super.key});

  @override
  State<JobListingsPage> createState() => _JobListingsPageState();
}

class _JobListingsPageState extends State<JobListingsPage> {
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    // Load jobs from Firebase
    final cubit = context.read<JobListingCubit>();
    if (cubit.state is JobListingInitial || cubit.allJobs.isEmpty) {
      cubit.loadJobs();
    }
  }

  /// Only active + published jobs are visible on the public website
  List<JobPostModel> _getActiveJobs(List<JobPostModel> allJobs) {
    return allJobs
        .where((j) =>
    j.status == JobStatus.active &&
        j.publishStatus == 'published')
        .toList();
  }

  /// Build dynamic department filter tabs from actual job data
  List<String> _buildFilterTabs(List<JobPostModel> activeJobs) {
    final departments = <String>{};
    for (final job in activeJobs) {
      if (job.department.isNotEmpty) {
        departments.add(job.department);
      }
    }
    return ['All', ...departments.toList()..sort()];
  }

  /// Apply department filter
  List<JobPostModel> _applyFilter(List<JobPostModel> activeJobs) {
    if (_selectedFilter == 'All') return activeJobs;
    return activeJobs
        .where((j) => j.department.toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final double contentW = (339.w * 4) + (12.w * 3);

    return BlocBuilder<JobListingCubit, JobListingState>(
      builder: (context, state) {
        // ── Loading state ──────────────────────────────────────────
        if (state is JobListingInitial || state is JobListingLoading) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    AppNavbar(currentRoute: '/careers'),
                    SizedBox(height: 200.h),
                    const CircularProgressIndicator(color: _kGreen),
                    SizedBox(height: 200.h),
                    const AppFooter(),
                  ],
                ),
              ),
            ),
          );
        }

        // ── Extract jobs from state ────────────────────────────────
        List<JobPostModel> allJobs = [];
        if (state is JobListingLoaded) {
          allJobs = state.jobs;
        } else if (state is JobListingError && state.lastJobs != null) {
          allJobs = state.lastJobs!;
        } else {
          allJobs = context.read<JobListingCubit>().allJobs;
        }

        final activeJobs  = _getActiveJobs(allJobs);
        final filterTabs  = _buildFilterTabs(activeJobs);
        final filteredJobs = _applyFilter(activeJobs);

        // ── If selected filter no longer exists in data, reset to All ──
        if (!filterTabs.contains(_selectedFilter)) {
          _selectedFilter = 'All';
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppNavbar(currentRoute: '/careers'),
                  SizedBox(height: 48.h),

                  // ── Constrained content column ──────────────────────
                  SizedBox(
                    width: 1000.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        // ── Hero heading ──────────────────────────────
                        Center(
                          child: SizedBox(
                            width: contentW,
                            child: Text(
                              'Unlock Your Potential in the Digital World',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 40.sp,
                                fontWeight: FontWeight.w700,
                                color: _kGreen,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),

                        // ── Filter tabs (dynamic from departments) ────
                        Center(
                          child: SizedBox(
                            width: contentW,
                            child: Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: _kDivider),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: filterTabs.map((f) {
                                    final bool selected = _selectedFilter == f;
                                    return GestureDetector(
                                      onTap: () => setState(() => _selectedFilter = f),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          margin: EdgeInsets.only(right: 4.w),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20.w,
                                            vertical: 8.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: selected ? _kGreen : Colors.transparent,
                                            borderRadius: BorderRadius.circular(7.r),
                                          ),
                                          child: Text(
                                            f,
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                              color: selected ? Colors.white : Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 28.h),

                        // ── Section title ─────────────────────────────
                        Center(
                          child: SizedBox(
                            width: contentW,
                            child: Text(
                              'Job Listings at Bayanatz',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // ── Error banner ──────────────────────────────
                        if (state is JobListingError)
                          Center(
                            child: SizedBox(
                              width: contentW,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 16.h),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFEBEE),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline,
                                        color: const Color(0xFFE53935),
                                        size: 18.sp),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Text(
                                        'Failed to load jobs. Showing cached data.',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: const Color(0xFFE53935)),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => context
                                          .read<JobListingCubit>()
                                          .loadJobs(),
                                      child: Text(
                                        'Retry',
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

                        // ── Job cards ─────────────────────────────────
                        Center(
                          child: SizedBox(
                            width: contentW,
                            child: Column(
                              children: filteredJobs.isEmpty
                                  ? [
                                Padding(
                                  padding:
                                  EdgeInsets.symmetric(vertical: 48.h),
                                  child: Text(
                                    _selectedFilter == 'All'
                                        ? 'No job openings available at the moment.'
                                        : 'No jobs found for "$_selectedFilter"',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 14.sp,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                              ]
                                  : filteredJobs
                                  .map((job) => Padding(
                                padding:
                                EdgeInsets.only(bottom: 16.h),
                                child: _JobCard(job: job),
                              ))
                                  .toList(),
                            ),
                          ),
                        ),

                        SizedBox(height: 64.h),
                      ],
                    ),
                  ),

                  // ── Footer ──────────────────────────────────────────
                  const AppFooter(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Job Card ─────────────────────────────────────────────────────────────────

class _JobCard extends StatefulWidget {
  final JobPostModel job;
  const _JobCard({required this.job});
  @override
  State<_JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<_JobCard> {
  bool _hovered = false;

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  String get _salaryDisplay {
    if (widget.job.salaryMax > 0) {
      return '${widget.job.salaryMin.toInt()} - ${widget.job.salaryMax.toInt()} ${widget.job.salaryCurrency}';
    }
    if (widget.job.salaryMin > 0) {
      return '${widget.job.salaryMin.toInt()} ${widget.job.salaryCurrency}';
    }
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
    final job = widget.job;

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
            // ── Title row ──────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    job.title.en.isEmpty ? 'Untitled' : job.title.en,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF008037),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.share_outlined,
                      size: 18.sp, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            Divider(color: _kDivider, height: 1),
            SizedBox(height: 14.h),

            // ── Info rows ──────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                    child: _InfoItem(
                        label: 'Expected Hire Date',
                        value: _formatDate(job.hiringStartDate))),
                Expanded(
                    child: _InfoItem(
                        label: 'Year Of Experience',
                        value: _experienceDisplay)),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                    child: _InfoItem(
                        label: 'Employment Type',
                        value: job.workType.label)),
                Expanded(
                    child: _InfoItem(
                        label: 'Compensation Range',
                        value: _salaryDisplay)),
              ],
            ),
            SizedBox(height: 10.h),

            _InfoItem(
                label: 'Required Qualification',
                value: job.requiredQualification.en.isEmpty
                    ? '—'
                    : job.requiredQualification.en),
            SizedBox(height: 14.h),

            // ── Skills ─────────────────────────────────────────────────
            if (job.requiredSkills.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Skills:',
                    style: TextStyle(
                      fontFamily: 'Cairo',
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
                          s.name.en.isEmpty ? s.name.ar : s.name.en,
                          style: TextStyle(
                            fontFamily: 'Cairo',
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

            // ── Location + View button ─────────────────────────────────
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
                      'Cairo, Egypt', // TODO: add location field to JobPostModel if needed
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15.sp,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
                _ViewJobBtn(jobId: job.id),
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
              fontFamily: 'Cairo',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontFamily: 'Cairo',
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
  const _ViewJobBtn({required this.jobId});
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
            'VIEW JOB',
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