// ******************* FILE INFO *******************
// File Name: job_listing_detail_page.dart
// Created by: Amr Mesbah
// Purpose: Job Post Details — 3 tabs: Job Details | Dashboard | Applicant Details
// Dashboard tab matches Figma: Applications Received, Candidate Classification,
// Hiring Stage, Interview Stage, Job Offer, Score Distribution, Candidate Gender
// Applicant Details tab: filterable table (Stage, Status)

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:website_app/controller/job_list/job_listing_cubit.dart';
import 'package:website_app/controller/job_list/job_listing_state.dart';
import 'package:website_app/core/widget/calnder.dart' show CustomDropdownFormFieldCalender;
import 'package:website_app/core/widget/custom_dropdwon.dart';
import 'package:website_app/core/widget/navigator.dart';
import 'package:website_app/model/job_listing_model.dart';
import 'package:website_app/theme/app_wight.dart';
import 'package:website_app/theme/appcolors.dart';
import 'package:website_app/theme/new_theme.dart';
import 'package:website_app/widgets/app_admin_navbar.dart';
import 'package:website_app/pages/careers_main_dashboard.dart';
import 'package:website_app/pages/dashboard/main_page/home_main_page.dart';
import 'package:website_app/pages/dashboard/job_list/job_listing_main_page.dart';

import '../../../core/widget/button.dart';
import 'job_listing_edit_page.dart';

// ── Colors ───────────────────────────────────────────────────────────────────
class _C {
  static const Color primary   = Color(0xFF008037);
  static const Color back      = Color(0xFFF1F2ED);
  static const Color cardBg    = Color(0xFFFFFFFF);
  static const Color labelText = Color(0xFF333333);
  static const Color hintText  = Color(0xFFAAAAAA);
  static const Color border    = Color(0xFFE0E0E0);
}

class _Ch {
  static const Color green      = Color(0xFF008037);
  static const Color darkGreen  = Color(0xFF1B5E20);
  static const Color lightGreen = Color(0xFF81C784);
  static const Color orange     = Color(0xFFFF9800);
  static const Color red        = Color(0xFFD32F2F);
  static const Color yellow     = Color(0xFFFFD452);
  static const Color grey       = Color(0xFFACACAC);
  static const Color teal       = Color(0xFF00897B);
  static const Color pink       = Color(0xFFE91E63);
  static const Color poor       = Color(0xFFD32F2F);
  static const Color weak       = Color(0xFFFF7043);
  static const Color good       = Color(0xFFFFCA28);
  static const Color veryGood   = Color(0xFF66BB6A);
  static const Color excellent  = Color(0xFF1B5E20);
}

// ═════════════════════════════════════════════════════════════════════════════
//  PAGE
// ═════════════════════════════════════════════════════════════════════════════

class JobListingDetailPage extends StatefulWidget {
  final String jobId;
  const JobListingDetailPage({super.key, required this.jobId});

  @override
  State<JobListingDetailPage> createState() => _JobListingDetailPageState();
}

class _JobListingDetailPageState extends State<JobListingDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  JobPostModel? _job;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadJob();
  }

  void _loadJob() {
    final cubit = context.read<JobListingCubit>();
    final matches = cubit.allJobs.where((j) => j.id == widget.jobId).toList();
    if (matches.isNotEmpty) setState(() => _job = matches.first);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${dt.day} ${m[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JobListingCubit, JobListingState>(
      listener: (context, state) {
        if (state is JobListingLoaded) {
          final matches = state.jobs.where((j) => j.id == widget.jobId).toList();
          if (matches.isNotEmpty) setState(() => _job = matches.first);
        }
        if (state is JobListingSaved && state.job.id == widget.jobId) {
          setState(() => _job = state.job);
        }
      },
      child: Scaffold(
        backgroundColor: _C.back,
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                AppAdminNavbar(
                  activeLabel:    'Job Listing',
                  homePage:       CareersMainPageDashboard(),
                  webPage:        HomeMainPage(),
                  jobListingPage: JobListingMainPage(),
                ),
                SizedBox(height: 20.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: SizedBox(
                    width: 1000.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Title ───────────────────────────────────
                        Text(
                          'Job Post Details',
                          style: StyleText.fontSize28Weight600.copyWith(
                            color: _C.primary, fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // ── Tab bar + Edit button ────────────────────
                        Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: _C.border)),
                          ),
                          child: Row(
                            children: [
                              _buildTabBar(),
                              const Spacer(),
                              if (_job != null)
                                Text(
                                  'Posted On ${_formatDate(_job!.postedDate)}',
                                  style: TextStyle(fontSize: 12.sp, color: _C.hintText),
                                ),
                              SizedBox(width: 16.w),
                              GestureDetector(
                                onTap: () => navigateTo(context,
                                    JobListingEditPage(jobId: widget.jobId)),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    color: _C.primary,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Edit Job Info',
                                          style: TextStyle(fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                      SizedBox(width: 6.w),
                                      Icon(Icons.edit_outlined,
                                          color: Colors.white, size: 14.sp),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // ── Tab content ──────────────────────────────
                        if (_job == null)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.sp),
                              child: const CircularProgressIndicator(color: _C.primary),
                            ),
                          )
                        else
                          AnimatedBuilder(
                            animation: _tabController,
                            builder: (_, __) {
                              switch (_tabController.index) {
                                case 0: return _JobDetailsTab(job: _job!);
                                case 1: return _DashboardTab(job: _job!);
                                case 2: return _ApplicantDetailsTab(job: _job!);
                                default: return const SizedBox();
                              }
                            },
                          ),

                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Job Details', 'Dashboard', 'Applicant Details'];
    return Row(
      children: List.generate(tabs.length, (i) {
        final isActive = _tabController.index == i;
        return GestureDetector(
          onTap: () => setState(() => _tabController.animateTo(i)),
          child: Container(
            padding: EdgeInsets.only(bottom: 12.h, right: 24.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isActive ? _C.primary : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              tabs[i],
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? _C.primary : _C.hintText,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  TAB 1 — JOB DETAILS (read-only)
// ═════════════════════════════════════════════════════════════════════════════

class _JobDetailsTab extends StatelessWidget {
  final JobPostModel job;
  const _JobDetailsTab({required this.job});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionCard(title: 'Job Information', child: _jobInfoContent()),
        SizedBox(height: 10.h),
        _SectionCard(title: 'Job Details', child: _jobDetailsContent()),
        SizedBox(height: 10.h),
        if (job.benefits.isNotEmpty) ...[
          _SectionCard(title: 'Benefits', child: _benefitsContent()),
          SizedBox(height: 10.h),
        ],
        _SectionCard(title: 'Application Details', child: _appDetailsContent()),
      ],
    );
  }

  Widget _jobInfoContent() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 16),
        _row(_infoField('Job Title', job.title.en),
            _infoFieldRtl('المسمى الوظيفي', job.title.ar)),
        const SizedBox(height: 12),
        _row(_infoField('Department', job.department.isEmpty ? '—' : job.department),
            _infoField('Work Type', job.workType.label)),
        const SizedBox(height: 12),
        _row(_infoField('Employment Type', job.employmentType.label),
            _infoField('Employment Duration',
                job.employmentDurationText.isNotEmpty
                    ? '${job.employmentDurationText} ${job.employmentDurationType.label}'
                    : job.employmentDurationType.label)),
        const SizedBox(height: 12),
        _row(_infoField('Experience Level', job.experienceLevel.label),
            _infoField('Salary Range', job.salaryMax > 0
                ? '${job.salaryMin.toInt()} – ${job.salaryMax.toInt()} ${job.salaryCurrency}'
                : '—')),
        const SizedBox(height: 12),
        _row(_infoField('Required Qualification', job.requiredQualification.en),
            _infoFieldRtl('المؤهلات المطلوبة', job.requiredQualification.ar)),
        if (job.requiredSkills.isNotEmpty) ...[
          const SizedBox(height: 12),
          _skillsRow(),
        ],
      ]),
    );
  }

  Widget _jobDetailsContent() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 16),
        _infoField('About This Position', job.aboutThisPosition.en, multi: true),
        const SizedBox(height: 12),
        _infoField('Requirements', job.requirements.en, multi: true),
        const SizedBox(height: 12),
        _infoField('Preferred Skills', job.preferredSkills.en, multi: true),
      ]),
    );
  }

  Widget _benefitsContent() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          ...List.generate(job.benefits.length, (i) {
            final b = job.benefits[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _infoField('Benefit ${i + 1} Title', b.title.en),
                const SizedBox(height: 6),
                _infoField('Description', b.shortDescription.en, multi: true),
                if (i < job.benefits.length - 1) ...[
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFFE8E8E8)),
                ],
              ]),
            );
          }),
        ],
      ),
    );
  }

  Widget _appDetailsContent() {
    String _fmtDate(DateTime? dt) {
      if (dt == null) return '—';
      const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${dt.day} ${m[dt.month - 1]} ${dt.year}';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 16),
        _row(_infoField('Hiring Start Date', _fmtDate(job.hiringStartDate)),
            _infoField('Hiring End Date', _fmtDate(job.hiringEndDate))),
        const SizedBox(height: 12),
        _row(_infoField('Max Applications',
            job.maxApplications > 0 ? job.maxApplications.toString() : '—'),
            const SizedBox()),
        if (job.requiredDocuments.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text('Required Documents',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                  color: Color(0xFF333333))),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: job.requiredDocuments
                .map((d) => _chip('${d.name} (${d.docType.label})'))
                .toList(),
          ),
        ],
      ]),
    );
  }

  Widget _row(Widget left, Widget right) {
    return Row(children: [
      Expanded(child: left),
      const SizedBox(width: 16),
      Expanded(child: right),
    ]);
  }

  Widget _skillsRow() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Required Skills',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
              color: Color(0xFF333333))),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 6,
        children: job.requiredSkills.map((s) => _chip(s.name.en)).toList(),
      ),
    ]);
  }

  Widget _infoField(String label, String value, {bool multi = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (label.isNotEmpty) ...[
        Text(label, style: const TextStyle(fontSize: 12,
            fontWeight: FontWeight.w500, color: Color(0xFF333333))),
        const SizedBox(height: 4),
      ],
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          value.isEmpty ? '—' : value,
          style: TextStyle(fontSize: 12,
              color: value.isEmpty ? const Color(0xFFAAAAAA) : const Color(0xFF333333)),
          maxLines: multi ? null : 1,
          overflow: multi ? null : TextOverflow.ellipsis,
        ),
      ),
    ]);
  }

  Widget _infoFieldRtl(String label, String value) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: _infoField(label, value),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF008037).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF008037).withOpacity(0.3)),
      ),
      child: Text(text,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
              color: Color(0xFF008037))),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  TAB 2 — DASHBOARD (matches Figma exactly)
// ═════════════════════════════════════════════════════════════════════════════

class _DashboardTab extends StatelessWidget {
  final JobPostModel job;
  const _DashboardTab({required this.job});

  // ── Demo data seeded from job.totalApplications ───────────────────────────
  int get _total => job.totalApplications > 0 ? job.totalApplications : 114765;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Applications Received | Candidate Classification
        _chartRow(
          left:  _buildApplicationsReceived(),
          right: _buildCandidateClassification(),
        ),
        SizedBox(height: 16.h),

        // Row 2: Hiring Stage | Interview Stage
        _chartRow(
          left:  _buildHiringStage(),
          right: _buildInterviewStage(),
        ),
        SizedBox(height: 16.h),

        // Row 3: Job Offer | Candidate Score Distribution
        _chartRow(
          left:  _buildJobOffer(),
          right: _buildScoreDistribution(),
        ),
        SizedBox(height: 16.h),

        // Row 4: Candidate Gender (half-width left)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildCandidateGender()),
            SizedBox(width: 16.w),
            const Expanded(child: SizedBox()),
          ],
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _chartRow({required Widget left, required Widget right}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        SizedBox(width: 16.w),
        Expanded(child: right),
      ],
    );
  }

  // ── 1. Applications Received ──────────────────────────────────────────────
  Widget _buildApplicationsReceived() {
    final labels = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final List<double> values = [80.0, 60, 90, 100, 110, 95, 120, 85, 100, 75, 90, 95];
    final maxY = 140.0;

    return _card(
      title: 'Applications Received',
      subtitle: 'Total: ${_fmtNum(_total)}',
      height: 280,
      child: Expanded(
        child: BarChart(
          BarChartData(
            maxY: maxY,
            barGroups: values.asMap().entries.map((e) => BarChartGroupData(
              x: e.key,
              barRods: [BarChartRodData(
                toY: e.value.toDouble(), width: 14.sp,
                color: _Ch.green,
                borderRadius: BorderRadius.circular(3.r),
              )],
              showingTooltipIndicators: [0],
            )).toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(
                showTitles: true, reservedSize: 35.sp, interval: 40,
                getTitlesWidget: (v, _) => Text(v.toInt().toString(),
                    style: TextStyle(fontSize: 9.sp, color: Colors.grey)),
              )),
              bottomTitles: AxisTitles(sideTitles: SideTitles(
                showTitles: true, reservedSize: 22.sp,
                getTitlesWidget: (v, _) {
                  final i = v.toInt();
                  return i >= 0 && i < labels.length
                      ? Text(labels[i], style: TextStyle(fontSize: 8.sp, color: Colors.grey))
                      : const SizedBox.shrink();
                },
              )),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:   AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true, drawVerticalLine: false, horizontalInterval: 40,
              getDrawingHorizontalLine: (_) =>
              const FlLine(color: Color(0xFFEFF3F9), strokeWidth: 1),
            ),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipPadding: EdgeInsets.zero,
                tooltipMargin: 4,
                getTooltipColor: (_) => Colors.transparent,
                tooltipBorder: BorderSide.none,
                getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                  rod.toY.toInt().toString(),
                  TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w600,
                      color: _Ch.darkGreen),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── 2. Candidate Classification ───────────────────────────────────────────
  Widget _buildCandidateClassification() {
    const qualified   = 72.0;
    const unqualified = 28.0;

    return _card(
      title: 'Candidate Classification',
      height: 280,
      child: Expanded(
        child: Row(children: [
          // Legend
          Expanded(flex: 2, child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _legendRow(_Ch.green, '${qualified.toInt()}%', 'Qualified'),
              SizedBox(height: 12.h),
              _legendRow(_Ch.grey,  '${unqualified.toInt()}%', 'Unqualified'),
            ],
          )),
          // Donut
          Expanded(flex: 3, child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 44.sp,
                sections: [
                  PieChartSectionData(value: qualified,   color: _Ch.green, radius: 30.sp, title: ''),
                  PieChartSectionData(value: unqualified, color: _Ch.grey,  radius: 30.sp, title: ''),
                ],
              )),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Total\nApplication', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 9.sp, color: Colors.black54)),
                Text(_fmtNum(_total),
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700,
                        color: Colors.black)),
              ]),
            ],
          )),
        ]),
      ),
    );
  }

  // ── 3. Hiring Stage (Funnel) ──────────────────────────────────────────────
  Widget _buildHiringStage() {
    final stages = [
      _FunnelItem('Applied',     253, _Ch.darkGreen),
      _FunnelItem('Interviewed', 151, const Color(0xFF2E7D32)),
      _FunnelItem('Rejected',    113, _Ch.green),
      _FunnelItem('Offer Sent',  87,  const Color(0xFF66BB6A)),
      _FunnelItem('Hired',       51,  _Ch.lightGreen),
    ];
    final maxVal = stages.first.value.toDouble();

    return _card(
      title: 'Hiring Stage',
      height: 280,
      child: Expanded(
        child: Row(children: [
          // Legend
          SizedBox(width: 90.w, child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: stages.map((s) => Padding(
              padding: EdgeInsets.only(bottom: 8.sp),
              child: Row(children: [
                Container(width: 10.sp, height: 10.sp,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: s.color)),
                SizedBox(width: 5.sp),
                Expanded(child: Text(s.label,
                    style: TextStyle(fontSize: 10.sp, color: Colors.black54),
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
            )).toList(),
          )),
          // Funnel bars (centered trapezoids)
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: stages.map((s) {
              final frac = s.value / maxVal;
              return Padding(
                padding: EdgeInsets.only(bottom: 3.sp),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final barWidth = constraints.maxWidth * frac;
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: barWidth,
                        height: 28.sp,
                        decoration: BoxDecoration(
                          color: s.color,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                        child: Center(
                          child: Text(
                            s.value.toString(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          )),
        ]),
      ),
    );
  }

  // ── 4. Interview Stage ────────────────────────────────────────────────────
  Widget _buildInterviewStage() {
    const passed    = 72.0;
    const failed    = 28.0;
    const withdrew  = 28.0;
    final total = passed + failed + withdrew;

    return _card(
      title: 'Interview Stage',
      height: 280,
      child: Expanded(
        child: Row(children: [
          Expanded(flex: 2, child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _legendRow(_Ch.green,    '${passed.toInt()}%',   'Passed'),
              SizedBox(height: 8.h),
              _legendRow(_Ch.lightGreen, '${failed.toInt()}%', 'Failed'),
              SizedBox(height: 8.h),
              _legendRow(_Ch.grey,     '${withdrew.toInt()}%', 'Candidate Withdrew'),
            ],
          )),
          Expanded(flex: 3, child: PieChart(PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 0,
            sections: [
              PieChartSectionData(value: passed,   color: _Ch.green,      radius: 60.sp, title: ''),
              PieChartSectionData(value: failed,   color: _Ch.lightGreen, radius: 60.sp, title: ''),
              PieChartSectionData(value: withdrew, color: _Ch.grey,       radius: 60.sp, title: ''),
            ],
          ))),
        ]),
      ),
    );
  }

  // ── 5. Job Offer ──────────────────────────────────────────────────────────
  Widget _buildJobOffer() {
    final approved = (_total * 0.61).round();
    final pending  = (_total * 0.32).round();
    final rejected = (_total * 0.20).round();
    final sum      = approved + pending + rejected;

    final items = [
      _PieItem('Approved', approved.toDouble(), _Ch.green),
      _PieItem('Pending',  pending.toDouble(),  _Ch.yellow),
      _PieItem('Rejected', rejected.toDouble(), _Ch.red),
    ];

    return _card(
      title: 'Job Offer',
      height: 280,
      child: Expanded(
        child: Row(children: [
          Expanded(flex: 2, child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) => Padding(
              padding: EdgeInsets.only(bottom: 8.sp),
              child: Row(children: [
                Container(width: 10.sp, height: 10.sp,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: item.color)),
                SizedBox(width: 6.sp),
                Expanded(child: Text(item.label,
                    style: TextStyle(fontSize: 11.sp, color: Colors.black87))),
                Text(_fmtNum(item.value.toInt()),
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600,
                        color: Colors.black87)),
              ]),
            )).toList(),
          )),
          SizedBox(width: 8.w),
          Expanded(flex: 3, child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40.sp,
                sections: items.map((item) => PieChartSectionData(
                  value: item.value, color: item.color,
                  radius: 28.sp, title: '',
                )).toList(),
              )),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Text(_fmtNum(sum),
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700,
                        color: Colors.black)),
                Text('Total', style: TextStyle(fontSize: 10.sp, color: Colors.black54)),
              ]),
            ],
          )),
        ]),
      ),
    );
  }

  // ── 6. Candidate Score Distribution ──────────────────────────────────────
  Widget _buildScoreDistribution() {
    final segments = [
      _ScoreSegment('Poor',      16,   _Ch.poor),
      _ScoreSegment('Weak',      45,   _Ch.weak),
      _ScoreSegment('Good',      2113, _Ch.good),
      _ScoreSegment('Very Good', 2113, _Ch.veryGood),
      _ScoreSegment('Excellent', 45,   _Ch.excellent),
    ];
    final total = segments.fold<int>(0, (s, e) => s + e.value);

    return _card(
      title: 'Candidate Score Distribution',
      height: 280,
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Labels row
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: segments.map((s) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 10.sp, height: 10.sp,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: s.color)),
                  SizedBox(height: 4.sp),
                  Text(s.label,
                      style: TextStyle(fontSize: 9.sp, color: Colors.black54)),
                  Text(_fmtNum(s.value),
                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                ],
              )).toList(),
            ),
            SizedBox(height: 12.h),
            // Segmented bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: Row(
                children: segments.map((s) {
                  final frac = total > 0 ? s.value / total : 0.0;
                  return Flexible(
                    flex: s.value,
                    child: Container(height: 20.sp, color: s.color),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 7. Candidate Gender ───────────────────────────────────────────────────
  Widget _buildCandidateGender() {
    const male   = 72.0;
    const female = 28.0;

    return _card(
      title: 'Candidate Gender',
      height: 280,
      child: Expanded(
        child: Row(children: [
          Expanded(flex: 2, child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _legendRow(_Ch.green, '${male.toInt()}%',   'Male'),
              SizedBox(height: 12.h),
              _legendRow(_Ch.grey,  '${female.toInt()}%', 'Female'),
            ],
          )),
          Expanded(flex: 3, child: PieChart(PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 0,
            sections: [
              PieChartSectionData(value: male,   color: _Ch.green, radius: 60.sp, title: ''),
              PieChartSectionData(value: female, color: _Ch.grey,  radius: 60.sp, title: ''),
            ],
          ))),
        ]),
      ),
    );
  }

  // ── Shared card wrapper ───────────────────────────────────────────────────
  Widget _card({
    required String title,
    required double height,
    required Widget child,
    String? subtitle,
  }) {
    // Unwrap any Expanded the caller may have wrapped the child in — we always
    // re-wrap with our own Expanded so it fills the remaining Column height.
    final innerChild = child is Expanded ? child.child : child;
    return Container(
      height: height.h,
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700,
            color: const Color(0xFF333333))),
        if (subtitle != null) ...[
          SizedBox(height: 2.h),
          Text(subtitle, style: TextStyle(fontSize: 11.sp, color: Colors.black45)),
        ],
        SizedBox(height: 10.h),
        Expanded(child: innerChild),
      ]),
    );
  }

  // ── Legend row helper ─────────────────────────────────────────────────────
  Widget _legendRow(Color color, String percent, String label) {
    return Row(children: [
      Container(width: 12.sp, height: 12.sp,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
      SizedBox(width: 6.sp),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(percent, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700,
            color: Colors.black)),
        Text(label, style: TextStyle(fontSize: 11.sp, color: Colors.black54)),
      ]),
    ]);
  }

  String _fmtNum(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

// Internal helpers for dashboard
class _FunnelItem {
  final String label; final int value; final Color color;
  const _FunnelItem(this.label, this.value, this.color);
}
class _PieItem {
  final String label; final double value; final Color color;
  const _PieItem(this.label, this.value, this.color);
}
class _ScoreSegment {
  final String label; final int value; final Color color;
  const _ScoreSegment(this.label, this.value, this.color);
}

// ═════════════════════════════════════════════════════════════════════════════
//  TAB 3 — APPLICANT DETAILS (table with Stage + Status filters)
// ═════════════════════════════════════════════════════════════════════════════

// ═════════════════════════════════════════════════════════════════════════════
//  TAB 3 — APPLICANT DETAILS (table with Stage + Status + Calendar filters)
//  Matches Figma: filters row → table with all columns
// ═════════════════════════════════════════════════════════════════════════════

// ── ADD THESE IMPORTS at the top of job_listing_detail_page.dart ─────────
// import 'package:website_app/widgets/custom_dropdown_form_field_inv_master.dart';
// import 'package:website_app/widgets/custom_drop_down.dart';

class _ApplicantDetailsTab extends StatefulWidget {
  final JobPostModel job;
  const _ApplicantDetailsTab({required this.job});

  @override
  State<_ApplicantDetailsTab> createState() => _ApplicantDetailsTabState();
}

class _ApplicantDetailsTabState extends State<_ApplicantDetailsTab> {
  String? _stageFilter;
  String? _statusFilter;
  String? _calendarFilter;

  // ── Stage items (key/value maps for CustomDropdownFormFieldInvMaster) ────
  static final List<Map<String, String>> _stageItems = [
    {'key': 'Applied', 'value': 'Applied'},
    {'key': 'Interview', 'value': 'Interview'},
    {'key': 'Offer Sent', 'value': 'Offer Sent'},
    {'key': 'Hired', 'value': 'Hired'},
  ];

  // ── Status items ────────────────────────────────────────────────────────
  static final List<Map<String, String>> _statusItems = [
    {'key': 'Qualified', 'value': 'Qualified'},
    {'key': 'Unqualified', 'value': 'Unqualified'},
    {'key': 'Passed', 'value': 'Passed'},
    {'key': 'Failed', 'value': 'Failed'},
    {'key': 'Candidate Withdrew', 'value': 'Candidate Withdrew'},
    {'key': 'Approved', 'value': 'Approved'},
    {'key': 'Pending', 'value': 'Pending'},
    {'key': 'Rejected', 'value': 'Rejected'},
    {'key': 'Completed', 'value': 'Completed'},
  ];

  // ── Stage color dots ────────────────────────────────────────────────────
  static final Map<String, Color> _stageColors = {
    'Applied': const Color(0xFF2196F3),
    'Interview': const Color(0xFFFF9800),
    'Offer Sent': const Color(0xFF9C27B0),
    'Hired': const Color(0xFF2E7D32),
  };

  // ── Status color dots ───────────────────────────────────────────────────
  static final Map<String, Color> _statusColors = {
    'Qualified': const Color(0xFF2E7D32),
    'Unqualified': const Color(0xFFD32F2F),
    'Passed': const Color(0xFF2E7D32),
    'Failed': const Color(0xFFD32F2F),
    'Candidate Withdrew': const Color(0xFF757575),
    'Approved': const Color(0xFF2E7D32),
    'Pending': const Color(0xFFFF9800),
    'Rejected': const Color(0xFFD32F2F),
    'Completed': const Color(0xFF2E7D32),
  };

  // ── Calendar items (months for filtering) ───────────────────────────────
  static final List<Map<String, String>> _calendarItems = [
    {'key': '2026-01', 'value': 'January 2026'},
    {'key': '2026-02', 'value': 'February 2026'},
    {'key': '2026-03', 'value': 'March 2026'},
    {'key': '2025-12', 'value': 'December 2025'},
    {'key': '2025-11', 'value': 'November 2025'},
  ];

  // ── Demo applicants matching Figma columns ─────────────────────────────
  late final List<_Applicant> _applicants = _buildDemoApplicants();

  List<_Applicant> _buildDemoApplicants() {
    return [
      _Applicant(
        firstName: 'Ahmed',
        lastName: 'Hassan',
        email: 'ahmed.h@gmail.com',
        code: '+20',
        phone: '+201012345678',
        yearOfGraduation: '2202',
        stage: 'Applied',
        status: 'Qualified',
        score: '78%',
        tags: 'Strong',
        location: 'Cairo,Egypt',
        resumeUrl: 'firebase.co',
        coverUrl: '',
      ),
      _Applicant(
        firstName: '',
        lastName: '',
        email: '',
        code: '',
        phone: '',
        yearOfGraduation: '',
        stage: 'Applied',
        status: 'Unqualified',
        score: '',
        tags: '',
        location: '',
        resumeUrl: '',
        coverUrl: '',
      ),
      _Applicant(
        firstName: '',
        lastName: '',
        email: '',
        code: '',
        phone: '',
        yearOfGraduation: '',
        stage: 'Interview',
        status: 'Passed',
        score: '',
        tags: '',
        location: '',
        resumeUrl: '',
        coverUrl: '',
      ),
      _Applicant(
        firstName: '',
        lastName: '',
        email: '',
        code: '',
        phone: '',
        yearOfGraduation: '',
        stage: 'Interview',
        status: 'Failed',
        score: '',
        tags: '',
        location: '',
        resumeUrl: '',
        coverUrl: '',
      ),
      _Applicant(
        firstName: '',
        lastName: '',
        email: '',
        code: '',
        phone: '',
        yearOfGraduation: '',
        stage: 'Interview',
        status: 'Candidate Withdrew',
        score: '',
        tags: '',
        location: '',
        resumeUrl: '',
        coverUrl: '',
      ),
      _Applicant(
        firstName: '',
        lastName: '',
        email: '',
        code: '',
        phone: '',
        yearOfGraduation: '',
        stage: 'Offer Sent',
        status: 'Approved',
        score: '',
        tags: '',
        location: '',
        resumeUrl: '',
        coverUrl: '',
      ),
      _Applicant(
        firstName: '',
        lastName: '',
        email: '',
        code: '',
        phone: '',
        yearOfGraduation: '',
        stage: 'Offer Sent',
        status: 'Pending',
        score: '',
        tags: '',
        location: '',
        resumeUrl: '',
        coverUrl: '',
      ),
      _Applicant(
        firstName: '',
        lastName: '',
        email: '',
        code: '',
        phone: '',
        yearOfGraduation: '',
        stage: 'Offer Sent',
        status: 'Rejected',
        score: '',
        tags: '',
        location: '',
        resumeUrl: '',
        coverUrl: '',
      ),
      _Applicant(
        firstName: '',
        lastName: '',
        email: '',
        code: '',
        phone: '',
        yearOfGraduation: '',
        stage: 'Hired',
        status: 'Completed',
        score: '',
        tags: '',
        location: '',
        resumeUrl: '',
        coverUrl: '',
      ),
    ];
  }

  List<_Applicant> get _filtered => _applicants.where((a) {
    if (_stageFilter != null && a.stage != _stageFilter) return false;
    if (_statusFilter != null && a.status != _statusFilter) return false;
    return true;
  }).toList();

  // ── Horizontal scroll controller for wide table ─────────────────────────
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rows = _filtered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ══════════════════════════════════════════════════════════════════
        //  FILTER ROW — Stage | Status | Calendar | Table Setting | Export
        // ══════════════════════════════════════════════════════════════════
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ── Stage dropdown ─────────────────────────────────────────
            SizedBox(
              width: 160.w,
              child: CustomDropdownFormFieldInvMaster(
                selectedValue: _stageFilter,
                items: _stageItems,
                widthIcon: 18,
                heightIcon: 18,
                height: 36,
                hint: Text(
                  'Stage',
                  style: TextStyle(fontSize: 12.sp, color: _C.hintText),
                ),

                itemColors: _stageColors,
                showColorDots: true,
                onChanged: (v) => setState(() => _stageFilter = v),
              ),
            ),
            SizedBox(width: 12.w),

            // ── Status dropdown ────────────────────────────────────────
            SizedBox(
              width: 160.w,
              child: CustomDropdownFormFieldInvMaster(
                selectedValue: _statusFilter,
                items: _statusItems,
                widthIcon: 18,
                heightIcon: 18,
                height: 36,
                hint: Text(
                  'Status',
                  style: TextStyle(fontSize: 12.sp, color: _C.hintText),
                ),
                itemColors: _statusColors,
                showColorDots: true,
                onChanged: (v) => setState(() => _statusFilter = v),
              ),
            ),

            const Spacer(),

            // ── Calendar dropdown ──────────────────────────────────────
            SizedBox(
              width: 160.w,
              child: CustomDropdownFormFieldCalender(
                selectedValue: _calendarFilter,
                items: _calendarItems,
                widthIcon: 14,
                heightIcon: 14,
                dropdownColor: Colors.white,
                height: 36,
                hint: Text(
                  'Calendar',
                  style: TextStyle(fontSize: 12.sp, color: _C.hintText),
                ),
                onChanged: (v) => setState(() => _calendarFilter = v),
              ),
            ),
            SizedBox(width: 12.w),

            // ── Table Setting button ──────────────────────────────────
            GestureDetector(
              onTap: () {
                // TODO: implement table settings dialog
              },
              child: Container(
                height: 36.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: _C.primary,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Center(
                  child: Text(
                    'Table Setting',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        // ── Export button (right-aligned) ──────────────────────────────
        Align(
          alignment: Alignment.centerRight,
          child: customButtonWithImage(
            title: 'Export',
            function: () {
              // TODO: implement export
            },
            textStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            height: 36.h,
            width: 135.w,
            space: 6.w,
            radius: 6.r,
            color: _C.primary,
            image: 'assets/images/export.svg', // adjust path to your actual SVG asset
            widthImage: 16.sp,
            heightImage: 16.sp,
            colorBorder: Colors.transparent,
            svgColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
        ),
        SizedBox(height: 16.h),

        // ══════════════════════════════════════════════════════════════════
        //  TABLE — horizontally scrollable, all Figma columns
        // ══════════════════════════════════════════════════════════════════
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Scrollbar(
            controller: _horizontalScrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 1600.w, // wide enough for all columns
                child: Column(
                  children: [
                    // ── Header row ─────────────────────────────────────
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: _C.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.r),
                          topRight: Radius.circular(8.r),
                        ),
                      ),
                      child: Row(children: const [
                        _HCell('First Name', flex: 2),
                        _HCell('Last Name', flex: 2),
                        _HCell('Email', flex: 3),
                        _HCell('Code', flex: 1),
                        _HCell('Phone', flex: 2),
                        _HCell('Year Of Graduation', flex: 2),
                        _HCell('Stage', flex: 2),
                        _HCell('Status', flex: 2),
                        _HCell('Score', flex: 1),
                        _HCell('Tags', flex: 1),
                        _HCell('Location', flex: 2),
                        _HCell('Resume', flex: 2),
                        _HCell('Cover', flex: 2),
                      ]),
                    ),

                    // ── Data rows ──────────────────────────────────────
                    if (rows.isEmpty)
                      Padding(
                        padding: EdgeInsets.all(40.sp),
                        child: Center(
                          child: Text(
                            'No applicants match the selected filters.',
                            style: TextStyle(
                                fontSize: 13.sp, color: _C.hintText),
                          ),
                        ),
                      )
                    else
                      ...rows.asMap().entries.map((e) {
                        final i = e.key;
                        final a = e.value;
                        final isEven = i % 2 == 0;
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 12.h),
                          color: isEven
                              ? Colors.white
                              : const Color(0xFFF9F9F9),
                          child: Row(children: [
                            _DCell(a.firstName, flex: 2),
                            _DCell(a.lastName, flex: 2),
                            _DCell(a.email, flex: 3),
                            _DCell(a.code, flex: 1),
                            _DCell(a.phone, flex: 2),
                            _DCell(a.yearOfGraduation, flex: 2),
                            _DCell(a.stage, flex: 2,
                                color: _stageTextColor(a.stage)),
                            _StatusBadgeCell(a.status, flex: 2),
                            _DCell(a.score, flex: 1),
                            _TagCell(a.tags, flex: 1),
                            _DCell(a.location, flex: 2),
                            _LinkCell(a.resumeUrl, flex: 2),
                            _LinkCell(a.coverUrl, flex: 2),
                          ]),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _stageTextColor(String stage) {
    switch (stage) {
      case 'Hired':
        return const Color(0xFF2E7D32);
      case 'Interview':
        return const Color(0xFFFF9800);
      case 'Offer Sent':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF333333);
    }
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  TABLE CELL WIDGETS
// ═════════════════════════════════════════════════════════════════════════════

class _HCell extends StatelessWidget {
  final String text;
  final int flex;
  const _HCell(this.text, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _DCell extends StatelessWidget {
  final String text;
  final int flex;
  final Color? color;
  const _DCell(this.text, {required this.flex, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text.isEmpty ? '—' : text,
        style: TextStyle(
          fontSize: 12.sp,
          color: text.isEmpty
              ? const Color(0xFFAAAAAA)
              : (color ?? const Color(0xFF333333)),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _StatusBadgeCell extends StatelessWidget {
  final String status;
  final int flex;
  const _StatusBadgeCell(this.status, {required this.flex});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (status) {
      case 'Qualified':
      case 'Passed':
      case 'Approved':
      case 'Completed':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        break;
      case 'Unqualified':
      case 'Failed':
      case 'Rejected':
        bg = const Color(0xFFFFEBEE);
        fg = const Color(0xFFD32F2F);
        break;
      case 'Pending':
        bg = const Color(0xFFFFF8E1);
        fg = const Color(0xFFF57F17);
        break;
      case 'Candidate Withdrew':
        bg = const Color(0xFFF5F5F5);
        fg = const Color(0xFF757575);
        break;
      default:
        bg = const Color(0xFFF5F5F5);
        fg = const Color(0xFF757575);
    }
    return Expanded(
      flex: flex,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _TagCell extends StatelessWidget {
  final String tag;
  final int flex;
  const _TagCell(this.tag, {required this.flex});

  @override
  Widget build(BuildContext context) {
    if (tag.isEmpty) {
      return Expanded(
        flex: flex,
        child: Text('—',
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFFAAAAAA))),
      );
    }

    Color bg;
    Color fg;
    switch (tag.toLowerCase()) {
      case 'strong':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        break;
      case 'average':
        bg = const Color(0xFFFFF8E1);
        fg = const Color(0xFFF57F17);
        break;
      case 'weak':
        bg = const Color(0xFFFFEBEE);
        fg = const Color(0xFFD32F2F);
        break;
      default:
        bg = const Color(0xFFF5F5F5);
        fg = const Color(0xFF757575);
    }
    return Expanded(
      flex: flex,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _LinkCell extends StatelessWidget {
  final String url;
  final int flex;
  const _LinkCell(this.url, {required this.flex});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Expanded(
        flex: flex,
        child: Text('—',
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFFAAAAAA))),
      );
    }
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () {
          // TODO: open URL or download file
        },
        child: Text(
          url,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF1976D2),
            decoration: TextDecoration.underline,
            decorationColor: const Color(0xFF1976D2),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  APPLICANT MODEL — updated with all Figma columns
// ═════════════════════════════════════════════════════════════════════════════

class _Applicant {
  final String firstName;
  final String lastName;
  final String email;
  final String code;
  final String phone;
  final String yearOfGraduation;
  final String stage;
  final String status;
  final String score;
  final String tags;
  final String location;
  final String resumeUrl;
  final String coverUrl;

  const _Applicant({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.code,
    required this.phone,
    required this.yearOfGraduation,
    required this.stage,
    required this.status,
    required this.score,
    required this.tags,
    required this.location,
    required this.resumeUrl,
    required this.coverUrl,
  });
}



// ═════════════════════════════════════════════════════════════════════════════
//  SHARED — Section card
// ═════════════════════════════════════════════════════════════════════════════

class _SectionCard extends StatefulWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  bool _open = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
          onTap: () => setState(() => _open = !_open),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: _C.primary,
              borderRadius: _open
                  ? BorderRadius.only(
                  topLeft: Radius.circular(6.r),
                  topRight: Radius.circular(6.r))
                  : BorderRadius.circular(6.r),
            ),
            child: Row(children: [
              Expanded(child: Text(widget.title,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600,
                      color: Colors.white))),
              Icon(_open ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
                  color: Colors.white, size: 20.sp),
            ]),
          ),
        ),
        if (_open)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6.r),
                bottomRight: Radius.circular(6.r),
              ),
            ),
            child: widget.child,
          ),
      ]),
    );
  }
}