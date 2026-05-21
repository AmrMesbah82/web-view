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
import '../../../data/models/job__model.dart';
import '../../controller/job_cubit.dart';
import '../../controller/job_state.dart';

part '../widget/l.dart';
part '../widget/filter_tab.dart';
part '../widget/job_card.dart';
part '../widget/info_item.dart';
part '../widget/view_job_btn.dart';

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
