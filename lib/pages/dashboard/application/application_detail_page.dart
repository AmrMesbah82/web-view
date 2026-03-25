// ═══════════════════════════════════════════════════════════════════
// FILE: application_detail_page.dart (Detail / Edit Page) — FULL UPDATE
// Path: lib/pages/dashboard/application/application_detail_page.dart
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:website_app/controller/application/application_cubit.dart';
import 'package:website_app/controller/application/application_state.dart';
import 'package:website_app/model/application_model.dart';
import 'package:website_app/theme/appcolors.dart';
import 'package:website_app/theme/new_theme.dart';
import 'package:website_app/widgets/app_admin_navbar.dart';

import '../../careers_main_dashboard.dart';
import '../main_page/home_main_page.dart';
import '../job_list/job_listing_main_page.dart';

class _C {
  static const Color primary   = Color(0xFF008037);
  static const Color back      = Color(0xFFF1F2ED);
  static const Color cardBg    = Color(0xFFFFFFFF);
  static const Color border    = Color(0xFFE0E0E0);
  static const Color labelText = Color(0xFF333333);
  static const Color hintText  = Color(0xFFAAAAAA);
  static const Color red       = Color(0xFFE53935);
}

class ApplicationDetailPage extends StatefulWidget {
  final String jobId;
  final String appId;
  const ApplicationDetailPage({super.key, required this.jobId, required this.appId});

  @override
  State<ApplicationDetailPage> createState() => _ApplicationDetailPageState();
}

class _ApplicationDetailPageState extends State<ApplicationDetailPage> {
  final _technicalCtrl      = TextEditingController();
  final _communicationCtrl  = TextEditingController();
  final _experienceCtrl     = TextEditingController();
  final _cultureFitCtrl     = TextEditingController();
  final _leadershipCtrl     = TextEditingController();
  final _commentsCtrl       = TextEditingController();

  String? _selectedTag;
  bool _isSaving = false;
  bool _didLoad  = false;

  ApplicationModel? _currentApp;

  @override
  void initState() {
    super.initState();
    context.read<ApplicationCubit>().loadDetail(widget.jobId, widget.appId);
  }

  void _seedControllers(ApplicationModel app) {
    if (_didLoad) return;
    _didLoad = true;
    _currentApp = app;
    _technicalCtrl.text     = app.technicalSkills > 0 ? app.technicalSkills.toString() : '';
    _communicationCtrl.text = app.communicationSkills > 0 ? app.communicationSkills.toString() : '';
    _experienceCtrl.text    = app.experienceBackground > 0 ? app.experienceBackground.toString() : '';
    _cultureFitCtrl.text    = app.cultureFit > 0 ? app.cultureFit.toString() : '';
    _leadershipCtrl.text    = app.leadershipPotential > 0 ? app.leadershipPotential.toString() : '';
    _commentsCtrl.text      = app.comments;
    _selectedTag            = app.tag.isNotEmpty ? app.tag : null;
  }

  @override
  void dispose() {
    _technicalCtrl.dispose();
    _communicationCtrl.dispose();
    _experienceCtrl.dispose();
    _cultureFitCtrl.dispose();
    _leadershipCtrl.dispose();
    _commentsCtrl.dispose();
    super.dispose();
  }

  // ── Status change with confirm dialog ──────────────────────────────────────
  void _onStatusChange(ApplicationModel app, ApplicationStatus newStatus) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Container(
          width: 450.w,
          padding: EdgeInsets.all(30.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/images/dashboard_image.svg', height: 120.h, fit: BoxFit.contain),
              SizedBox(height: 20.h),
              Text('CHANGE STATUS', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: _C.labelText)),
              SizedBox(height: 12.h),
              Text(
                'Are you sure you want to change this Submissions status from ${app.status.label} to ${newStatus.label}?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp, color: _C.hintText, height: 1.5),
              ),
              SizedBox(height: 24.h),
              Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(ctx).pop(),
                    child: Container(
                      height: 44.h,
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(6.r)),
                      child: Center(child: Text('Back', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: _C.labelText))),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(ctx).pop();
                      context.read<ApplicationCubit>().updateStatus(app.jobId, app.id, newStatus);
                    },
                    child: Container(
                      height: 44.h,
                      decoration: BoxDecoration(color: _C.primary, borderRadius: BorderRadius.circular(6.r)),
                      child: Center(child: Text('Confirm', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.white))),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  // ── Save scoring ───────────────────────────────────────────────────────────
  Future<void> _saveScoring() async {
    if (_currentApp == null) return;
    setState(() => _isSaving = true);

    final updated = _currentApp!.copyWith(
      tag: _selectedTag ?? '',
      technicalSkills: int.tryParse(_technicalCtrl.text) ?? 0,
      communicationSkills: int.tryParse(_communicationCtrl.text) ?? 0,
      experienceBackground: int.tryParse(_experienceCtrl.text) ?? 0,
      cultureFit: int.tryParse(_cultureFitCtrl.text) ?? 0,
      leadershipPotential: int.tryParse(_leadershipCtrl.text) ?? 0,
      comments: _commentsCtrl.text,
    );

    await context.read<ApplicationCubit>().updateScoring(updated);

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Scoring saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationCubit, ApplicationState>(
      builder: (context, state) {
        ApplicationModel? app;
        if (state is ApplicationDetailLoaded) app = state.application;
        if (state is ApplicationUpdated) app = state.application;

        if (app == null) {
          return const Scaffold(
            backgroundColor: _C.back,
            body: Center(child: CircularProgressIndicator(color: _C.primary)),
          );
        }

        _seedControllers(app);
        _currentApp = app;

        return Scaffold(
          backgroundColor: _C.back,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      AppAdminNavbar(
                        activeLabel: 'Applications',
                        homePage: CareersMainPageDashboard(),
                        webPage: HomeMainPage(),
                        jobListingPage: JobListingMainPage(),
                      ),

                      SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                        child: SizedBox(
                          width: 1000.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Title ──
                              Text('Applications',
                                  style: StyleText.fontSize45Weight600.copyWith(
                                      color: _C.primary, fontWeight: FontWeight.w700)),
                              SizedBox(height: 12.h),

                              // ── Status Pipeline ──
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                      decoration: BoxDecoration(
                                        color: _C.primary,
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.update, size: 14.sp, color: Colors.white),
                                          SizedBox(width: 6.w),
                                          Text('Update Status',
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: _StatusPipeline(
                                      currentStatus: app.status,
                                      onStatusChange: (newStatus) =>
                                          _onStatusChange(app!, newStatus),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),

                              // ── Personal Information ──
                              _sectionTitle('Personal Information'),
                              SizedBox(height: 12.h),
                              _readOnlyCard([
                                _readRow('First Name', app.firstName),
                                _readRow('Last Name', app.lastName),
                                _readRow('Email', app.email),
                                _readRow('Phone', '${app.countryCode} ${app.phone}'),
                                _readRow('Year Of Graduation', app.yearOfGraduation),
                              ]),
                              SizedBox(height: 24.h),

                              // ── Profile Information ──
                              _sectionTitle('Profile Information'),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Expanded(child: _fileCard('Resume*', app.resumeName, app.resumeUrl)),
                                  SizedBox(width: 16.w),
                                  Expanded(child: _fileCard('Cover Letter*', app.coverLetterName, app.coverLetterUrl)),
                                ],
                              ),
                              SizedBox(height: 24.h),

                              // ── Tags ──
                              _sectionTitle('Personal Information'),
                              SizedBox(height: 12.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200.w,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Tags',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                color: _C.labelText)),
                                        SizedBox(height: 6.h),
                                        Container(
                                          height: 36.h,
                                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                                          decoration: BoxDecoration(
                                            color: AppColors.card,
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: _selectedTag,
                                              isExpanded: true,
                                              hint: Text('Select Tag',
                                                  style: TextStyle(
                                                      fontSize: 12.sp, color: _C.hintText)),
                                              items: ['Weak', 'Adequate', 'Strong']
                                                  .map((t) => DropdownMenuItem(
                                                  value: t,
                                                  child: Text(t,
                                                      style:
                                                      TextStyle(fontSize: 12.sp))))
                                                  .toList(),
                                              onChanged: (v) =>
                                                  setState(() => _selectedTag = v),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(12.sp),
                                      decoration: BoxDecoration(
                                        color: AppColors.card,
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: ['Weak', 'Adequate', 'Strong']
                                            .map((t) => Padding(
                                          padding: EdgeInsets.only(bottom: 6.h),
                                          child: Text(t,
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: _C.labelText)),
                                        ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),

                              // ── Scoring Interview ──
                              _sectionTitle('Scoring Interview'),
                              SizedBox(height: 12.h),
                              Row(children: [
                                Expanded(
                                    child: _scoreField(
                                        'Technical Skills', _technicalCtrl)),
                                SizedBox(width: 16.w),
                                Expanded(
                                    child: _scoreField(
                                        'Communication Skills', _communicationCtrl)),
                              ]),
                              SizedBox(height: 12.h),
                              Row(children: [
                                Expanded(
                                    child: _scoreField(
                                        'Experience & Background', _experienceCtrl)),
                                SizedBox(width: 16.w),
                                Expanded(
                                    child:
                                    _scoreField('Culture Fit', _cultureFitCtrl)),
                              ]),
                              SizedBox(height: 12.h),
                              Row(children: [
                                Expanded(
                                    child: _scoreField(
                                        'Leadership Potential', _leadershipCtrl)),
                                SizedBox(width: 16.w),
                                const Expanded(child: SizedBox()),
                              ]),
                              SizedBox(height: 12.h),

                              // Comments
                              Text('Comments',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: _C.labelText)),
                              SizedBox(height: 6.h),
                              SizedBox(
                                height: 100.h,
                                child: TextFormField(
                                  controller: _commentsCtrl,
                                  maxLines: 5,
                                  style: TextStyle(
                                      fontSize: 12.sp, color: _C.labelText),
                                  decoration: InputDecoration(
                                    hintText: 'Text Here',
                                    hintStyle: TextStyle(
                                        fontSize: 12.sp, color: _C.hintText),
                                    filled: true,
                                    fillColor: AppColors.card,
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.r),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.h),

                              // ── Save button ──
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: _isSaving ? null : _saveScoring,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30.w, vertical: 12.h),
                                    decoration: BoxDecoration(
                                      color: _C.primary,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: _isSaving
                                        ? SizedBox(
                                        width: 16.sp,
                                        height: 16.sp,
                                        child:
                                        const CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2))
                                        : Text('Save Scoring',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  ),
                                ),
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

              if (_isSaving)
                Container(
                  color: Colors.black26,
                  child: const Center(
                      child: CircularProgressIndicator(color: _C.primary)),
                ),
            ],
          ),
        );
      },
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _sectionTitle(String title) => Text(
    title,
    style: TextStyle(
        fontSize: 18.sp, fontWeight: FontWeight.w700, color: _C.primary),
  );

  Widget _readOnlyCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: _C.border),
      ),
      child: Wrap(
        spacing: 16.w,
        runSpacing: 12.h,
        children: children,
      ),
    );
  }

  Widget _readRow(String label, String value) {
    return SizedBox(
      width: 460.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: _C.labelText)),
          SizedBox(height: 4.h),
          Container(
            width: double.infinity,
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(4.r),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              value.isEmpty ? 'Text Here' : value,
              style: StyleText.fontSize12Weight400.copyWith(
                  color: value.isEmpty ? _C.hintText : _C.labelText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fileCard(String label, String fileName, String fileUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: _C.labelText)),
        SizedBox(height: 6.h),
        Container(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: _C.cardBg,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: _C.border),
          ),
          child: Row(
            children: [
              Container(
                width: 28.sp,
                height: 28.sp,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Center(
                  child: Text('PDF',
                      style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.red)),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName.isEmpty ? 'No file' : fileName,
                      style: TextStyle(fontSize: 11.sp, color: _C.labelText),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (fileName.isNotEmpty)
                      Text('62 KB',
                          style:
                          TextStyle(fontSize: 9.sp, color: _C.hintText)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _scoreField(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: _C.labelText)),
        SizedBox(height: 6.h),
        SizedBox(
          height: 36.h,
          child: TextFormField(
            controller: ctrl,
            style: TextStyle(fontSize: 12.sp, color: _C.labelText),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Text Here, 1-5 Scoring',
              hintStyle: TextStyle(fontSize: 12.sp, color: _C.hintText),
              filled: true,
              fillColor: AppColors.card,
              isDense: true,
              contentPadding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  STATUS PIPELINE — 4 stage dropdowns that progress left to right
// ═════════════════════════════════════════════════════════════════════════════

class _StatusPipeline extends StatelessWidget {
  final ApplicationStatus currentStatus;
  final ValueChanged<ApplicationStatus> onStatusChange;

  const _StatusPipeline({
    required this.currentStatus,
    required this.onStatusChange,
  });

  int get _currentStageIndex {
    switch (currentStatus) {
      case ApplicationStatus.applied:
      case ApplicationStatus.qualified:
      case ApplicationStatus.unqualified:
        return 0;
      case ApplicationStatus.interviewPassed:
      case ApplicationStatus.interviewFailed:
      case ApplicationStatus.interviewWithdrew:
        return 1;
      case ApplicationStatus.offerApproved:
      case ApplicationStatus.offerPending:
      case ApplicationStatus.offerRejected:
        return 2;
      case ApplicationStatus.hired:
        return 3;
    }
  }

  bool get _isStopped {
    return currentStatus == ApplicationStatus.unqualified ||
        currentStatus == ApplicationStatus.interviewFailed ||
        currentStatus == ApplicationStatus.interviewWithdrew ||
        currentStatus == ApplicationStatus.offerRejected;
  }

  bool get _isCompleted => currentStatus == ApplicationStatus.hired;

  /// What positive label was selected to pass this stage
  String _getCompletedLabel(int stage) {
    if (_currentStageIndex <= stage) return '';
    switch (stage) {
      case 0: return 'Qualified';
      case 1: return 'Passed';
      case 2: return 'Approved';
      default: return '';
    }
  }

  /// The short label shown on a stopped stage
  String _getStoppedLabel() {
    switch (currentStatus) {
      case ApplicationStatus.unqualified:       return 'Unqualified';
      case ApplicationStatus.interviewFailed:   return 'Failed';
      case ApplicationStatus.interviewWithdrew: return 'Withdrew';
      case ApplicationStatus.offerRejected:     return 'Rejected';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // ── Stage 0: Applied ──
          _StageDropdown(
            stageLabel: 'Applied',
            completedLabel: _getCompletedLabel(0),
            stoppedLabel: (_currentStageIndex == 0 && _isStopped) ? _getStoppedLabel() : null,
            items: const ['Qualified', 'Unqualified'],
            isActive: _currentStageIndex == 0 && !_isStopped && currentStatus == ApplicationStatus.applied,
            isCompleted: _currentStageIndex > 0,
            isLocked: false,
            onSelected: (val) {
              if (val == 'Qualified') onStatusChange(ApplicationStatus.qualified);
              if (val == 'Unqualified') onStatusChange(ApplicationStatus.unqualified);
            },
          ),
          _arrow(),

          // ── Stage 1: Interview ──
          _StageDropdown(
            stageLabel: 'Interview',
            completedLabel: _getCompletedLabel(1),
            stoppedLabel: (_currentStageIndex == 1 && _isStopped) ? _getStoppedLabel() : null,
            items: const ['Passed', 'Failed', 'Withdrew'],
            isActive: _currentStageIndex == 1 && !_isStopped,
            isCompleted: _currentStageIndex > 1,
            isLocked: _currentStageIndex < 1 || (_currentStageIndex == 0 && _isStopped),
            onSelected: (val) {
              if (val == 'Passed') onStatusChange(ApplicationStatus.interviewPassed);
              if (val == 'Failed') onStatusChange(ApplicationStatus.interviewFailed);
              if (val == 'Withdrew') onStatusChange(ApplicationStatus.interviewWithdrew);
            },
          ),
          _arrow(),

          // ── Stage 2: Offer ──
          _StageDropdown(
            stageLabel: 'Offer',
            completedLabel: _getCompletedLabel(2),
            stoppedLabel: (_currentStageIndex == 2 && _isStopped) ? _getStoppedLabel() : null,
            items: const ['Approved', 'Rejected'],
            isActive: _currentStageIndex == 2 && !_isStopped,
            isCompleted: _currentStageIndex > 2,
            isLocked: _currentStageIndex < 2 || (_currentStageIndex <= 1 && _isStopped),
            onSelected: (val) {
              if (val == 'Approved') onStatusChange(ApplicationStatus.offerApproved);
              if (val == 'Rejected') onStatusChange(ApplicationStatus.offerRejected);
            },
          ),
          _arrow(),

          // ── Stage 3: Hired ──
          _StageDropdown(
            stageLabel: 'Hired',
            completedLabel: _isCompleted ? 'Completed' : '',
            stoppedLabel: null,
            items: const ['Completed'],
            isActive: _currentStageIndex == 3 && !_isCompleted,
            isCompleted: _isCompleted,
            isLocked: _currentStageIndex < 3 || _isStopped,
            onSelected: (val) {
              if (val == 'Completed') onStatusChange(ApplicationStatus.hired);
            },
          ),
        ],
      ),
    );
  }

  Widget _arrow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Icon(Icons.chevron_right, size: 18.sp, color: _C.hintText),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  INDIVIDUAL STAGE DROPDOWN
// ═════════════════════════════════════════════════════════════════════════════

class _StageDropdown extends StatelessWidget {
  final String stageLabel;
  final String completedLabel;
  final String? stoppedLabel;
  final List<String> items;
  final bool isActive;
  final bool isCompleted;
  final bool isLocked;
  final ValueChanged<String> onSelected;

  const _StageDropdown({
    required this.stageLabel,
    required this.completedLabel,
    required this.stoppedLabel,
    required this.items,
    required this.isActive,
    required this.isCompleted,
    required this.isLocked,
    required this.onSelected,
  });

  bool get _isStopped => stoppedLabel != null && stoppedLabel!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    // ── LOCKED: future stage, grayed out ──
    if (isLocked && !isCompleted && !_isStopped) {
      return Container(
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(stageLabel,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade400)),
            SizedBox(width: 4.w),
            Icon(Icons.keyboard_arrow_down,
                size: 16.sp, color: Colors.grey.shade400),
          ],
        ),
      );
    }

    // ── COMPLETED: green check ──
    if (isCompleted) {
      return Container(
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: _C.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: _C.primary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 14.sp, color: _C.primary),
            SizedBox(width: 6.w),
            Text(
              completedLabel.isNotEmpty ? '$stageLabel: $completedLabel' : stageLabel,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: _C.primary),
            ),
          ],
        ),
      );
    }

    // ── STOPPED: red X ──
    if (_isStopped) {
      return Container(
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: _C.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: _C.red),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cancel, size: 14.sp, color: _C.red),
            SizedBox(width: 6.w),
            Text(
              '$stageLabel: $stoppedLabel',
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: _C.red),
            ),
          ],
        ),
      );
    }

    // ── ACTIVE: show dropdown ──
    if (isActive) {
      return Container(
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: _C.primary),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: null,
            hint: Text(stageLabel,
                style: TextStyle(fontSize: 12.sp, color: _C.labelText)),
            icon: Icon(Icons.keyboard_arrow_down,
                size: 16.sp, color: _C.labelText),
            items: items
                .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item, style: TextStyle(fontSize: 12.sp)),
            ))
                .toList(),
            onChanged: (val) {
              if (val != null) onSelected(val);
            },
          ),
        ),
      );
    }

    // ── WAITING: passed this stage but waiting (e.g. Qualified selected, now showing Interview) ──
    return Container(
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(stageLabel,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade400)),
          SizedBox(width: 4.w),
          Icon(Icons.keyboard_arrow_down,
              size: 16.sp, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}