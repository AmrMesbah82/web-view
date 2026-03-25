// ═══════════════════════════════════════════════════════════════════
// FILE: job_apply_page.dart (Public Website — Apply Form)
// Path: lib/pages/job_apply_page.dart
// FIXED: Centered 1000.w layout — title + card aligned like all Bayanatz pages
// ═══════════════════════════════════════════════════════════════════

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:website_app/controller/home_cubit.dart';
import 'package:website_app/controller/home_state.dart';
import 'package:website_app/controller/lang_state.dart';
import 'package:website_app/core/custom_svg.dart';
import 'package:website_app/core/widget/custom_dropdwon.dart';
import 'package:website_app/core/widget/textfield.dart';
import 'package:website_app/theme/appcolors.dart';
import 'package:website_app/theme/new_theme.dart';
import 'package:website_app/widgets/app_footer.dart';
import 'package:website_app/widgets/app_navbar.dart';

const Color _kGreen = Color(0xFF2D8C4E);
const Color _kDivider = Color(0xFFDDE8DD);
const Color _kHint = Color(0xFFBBBBBB);
const Color _kLabel = Color(0xFF333333);

Color _parsePrimary(HomeCmsState state) {
  final hex = switch (state) {
    HomeCmsLoaded(:final data) => data.branding.primaryColor,
    HomeCmsSaved(:final data) => data.branding.primaryColor,
    _ => '',
  };
  try {
    final c = hex.replaceAll('#', '');
    if (c.length == 6) return Color(int.parse('FF$c', radix: 16));
  } catch (_) {}
  return _kGreen;
}

Color _parseBg(HomeCmsState state) {
  final hex = switch (state) {
    HomeCmsLoaded(:final data) => data.branding.backgroundColor,
    HomeCmsSaved(:final data) => data.branding.backgroundColor,
    _ => '',
  };
  try {
    final c = hex.replaceAll('#', '');
    if (c.length == 6) return Color(int.parse('FF$c', radix: 16));
  } catch (_) {}
  return AppColors.background;
}

const List<Map<String, String>> _kCountryCodes = [
  {'key': '+234', 'value': '🇳🇬  +234'},
  {'key': '+20', 'value': '🇪🇬  +20'},
  {'key': '+966', 'value': '🇸🇦  +966'},
  {'key': '+1', 'value': '🇺🇸  +1'},
  {'key': '+44', 'value': '🇬🇧  +44'},
  {'key': '+971', 'value': '🇦🇪  +971'},
  {'key': '+965', 'value': '🇰🇼  +965'},
  {'key': '+974', 'value': '🇶🇦  +974'},
  {'key': '+973', 'value': '🇧🇭  +973'},
  {'key': '+968', 'value': '🇴🇲  +968'},
  {'key': '+962', 'value': '🇯🇴  +962'},
  {'key': '+961', 'value': '🇱🇧  +961'},
  {'key': '+964', 'value': '🇮🇶  +964'},
  {'key': '+212', 'value': '🇲🇦  +212'},
  {'key': '+216', 'value': '🇹🇳  +216'},
  {'key': '+213', 'value': '🇩🇿  +213'},
  {'key': '+218', 'value': '🇱🇾  +218'},
  {'key': '+249', 'value': '🇸🇩  +249'},
  {'key': '+91', 'value': '🇮🇳  +91'},
  {'key': '+92', 'value': '🇵🇰  +92'},
];

class JobApplyPage extends StatefulWidget {
  final String jobId;
  const JobApplyPage({super.key, required this.jobId});
  @override
  State<JobApplyPage> createState() => _JobApplyPageState();
}

class _JobApplyPageState extends State<JobApplyPage> {
  Map<String, dynamic>? _job;
  bool _loadingJob = true,
      _submitting = false,
      _submitted = false,
      _formSubmitted = false;

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _coverLinkCtrl = TextEditingController();

  String _countryCode = '+234';
  String? _resumeFileName;
  Uint8List? _resumeBytes;
  String? _resumeUrl;

  @override
  void initState() {
    super.initState();
    _loadJob();
  }

  Future<void> _loadJob() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('jobListings')
          .doc(widget.jobId)
          .get(const GetOptions(source: Source.server));
      if (doc.exists && doc.data() != null) {
        setState(() {
          _job = doc.data()!;
          _loadingJob = false;
        });
      } else {
        setState(() => _loadingJob = false);
      }
    } catch (_) {
      setState(() => _loadingJob = false);
    }
  }

  String _biText(Map<String, dynamic>? map, bool isRtl) {
    if (map == null) return '';
    return isRtl ? (map['ar'] ?? '') : (map['en'] ?? '');
  }

  String _str(String key) => _job?[key] as String? ?? '';
  String _fmtDate(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dt.day} ${m[dt.month - 1]} ${dt.year}';
  }

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _resumeFileName = result.files.first.name;
        _resumeBytes = result.files.first.bytes;
      });
    }
  }

  Future<String?> _uploadResume() async {
    if (_resumeBytes == null || _resumeFileName == null) return null;
    try {
      final ref = FirebaseStorage.instance.ref(
        'applications/${widget.jobId}/${DateTime.now().millisecondsSinceEpoch}_$_resumeFileName',
      );
      final task = await ref.putData(
        _resumeBytes!,
        SettableMetadata(contentType: 'application/pdf'),
      );
      return await task.ref.getDownloadURL();
    } catch (e) {
      print('🔴 Resume upload error: $e');
      return null;
    }
  }

  Future<void> _submit() async {
    setState(() => _formSubmitted = true);
    if (_firstNameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill required fields')),
      );
      return;
    }
    setState(() => _submitting = true);
    if (_resumeBytes != null) {
      _resumeUrl = await _uploadResume();
    }
    final isRtl = context.read<LanguageCubit>().state.isArabic;
    final jobTitle = _biText(_job?['title'] as Map<String, dynamic>?, isRtl);
    try {
      await FirebaseFirestore.instance
          .collection('jobListings')
          .doc(widget.jobId)
          .collection('applications')
          .add({
            'jobId': widget.jobId,
            'jobTitle': jobTitle,
            'department': _str('department'),
            'firstName': _firstNameCtrl.text.trim(),
            'lastName': _lastNameCtrl.text.trim(),
            'email': _emailCtrl.text.trim(),
            'countryCode': _countryCode,
            'phone': _phoneCtrl.text.trim(),
            'yearOfGraduation': _yearCtrl.text.trim(),
            'resumeUrl': _resumeUrl ?? '',
            'resumeName': _resumeFileName ?? '',
            'coverLetterUrl': _coverLinkCtrl.text.trim(),
            'coverLetterName': _coverLinkCtrl.text.trim().isNotEmpty
                ? 'Link'
                : '',
            'status': 'Applied',
            'tag': '',
            'technicalSkills': 0,
            'communicationSkills': 0,
            'experienceBackground': 0,
            'cultureFit': 0,
            'leadershipPotential': 0,
            'comments': '',
            'applicationDate': DateTime.now().toIso8601String(),
            'workType': _str('workType'),
            'employmentType': _str('employmentType'),
            'experienceLevel': _str('experienceLevel'),
            'salaryRange':
                '${(_job?['salaryMin'] as num?)?.toInt() ?? 0} - ${(_job?['salaryMax'] as num?)?.toInt() ?? 0}',
            'currency': _str('salaryCurrency'),
            'jobLocation': '',
            'employmentDuration':
                '${_str('employmentDurationText')} ${_str('employmentDurationType')}',
            'requiredQualification': _biText(
              _job?['requiredQualification'] as Map<String, dynamic>?,
              isRtl,
            ),
            'requiredSkills': (_job?['requiredSkills'] as List<dynamic>? ?? [])
                .map((s) => _biText(s['name'] as Map<String, dynamic>?, isRtl))
                .join(', '),
          });
      await FirebaseFirestore.instance
          .collection('jobListings')
          .doc(widget.jobId)
          .update({'totalApplications': FieldValue.increment(1)});
      setState(() {
        _submitting = false;
        _submitted = true;
      });
    } catch (e) {
      setState(() => _submitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit: $e')));
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _yearCtrl.dispose();
    _coverLinkCtrl.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  BUILD — everything inside Center > SizedBox(width: 1000.w)
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCmsCubit, HomeCmsState>(
      builder: (context, homeState) {
        final primary = _parsePrimary(homeState);
        final bgColor = _parseBg(homeState);
        final isRtl = context.watch<LanguageCubit>().state.isArabic;

        if (_loadingJob)
          return Scaffold(
            backgroundColor: const Color(0xFFF1F2ED),
            body: Center(child: CircularProgressIndicator(color: primary)),
          );
        if (_submitted) return _buildSuccessScreen(primary, isRtl);

        final title = _biText(_job?['title'] as Map<String, dynamic>?, isRtl);

        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: const Color(0xFFF1F2ED),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        AppNavbar(currentRoute: '/careers'),
                        SizedBox(height: 40.h),

                        // ═══ ALL CONTENT CENTERED IN 1000.w ═══
                        Center(
                          child: SizedBox(
                            width: 1000.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ── Title ──
                                Text(
                                  'Applying For Job',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 36.sp,
                                    fontWeight: FontWeight.w700,
                                    color: primary,
                                  ),
                                ),
                                SizedBox(height: 24.h),

                                // ── Main card (job summary + form + send) ──
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(28.sp),
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildJobSummary(title, primary, bgColor),
                                      SizedBox(height: 28.h),
                                      _buildPersonalInfo(primary),
                                      SizedBox(height: 28.h),
                                      _buildProfileInfo(primary),
                                      SizedBox(height: 24.h),
                                      _buildSendButton(primary),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 64.h),
                              ],
                            ),
                          ),
                        ),

                        const AppFooter(),
                      ],
                    ),
                  ),
                ),
                if (_submitting)
                  Container(
                    color: Colors.black26,
                    child: Center(
                      child: CircularProgressIndicator(color: primary),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  SUCCESS SCREEN
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSuccessScreen(Color primary, bool isRtl) {
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F2ED),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                AppNavbar(currentRoute: '/careers'),
                SizedBox(height: 80.h),
                Center(
                  child: SizedBox(
                    width: 1000.w,
                    child: Container(
                      padding: EdgeInsets.all(40.sp),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/images/success_send.svg',
                            height: 140.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            "YOU'VE OFFICIALLY APPLIED — AND WE'RE EXCITED TO LEARN MORE ABOUT YOU!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Your application has been successfully received. Our team will review your submission and contact you if your qualifications match our current opportunities. Thank you for considering Bayanatz as the next step in your career.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13.sp,
                              height: 1.6,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 64.h),
                const AppFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  JOB SUMMARY (inside the main card)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildJobSummary(String title, Color primary, Color bgColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.isEmpty ? 'Untitled' : title,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: _kLabel,
          ),
        ),
        SizedBox(height: 12.h),
        Divider(color: _kDivider, thickness: 1),
        SizedBox(height: 12.h),
        _summaryRow(
          'Hire Date:',
          _fmtDate(_str('hiringStartDate')),
          'Hire End Date:',
          _fmtDate(_str('hiringEndDate')),
          primary,
        ),
        SizedBox(height: 6.h),
        _summaryRow('Work Type:', _str('workType'), '', '', primary),
        SizedBox(height: 6.h),
        _summaryRow(
          'Employment Type:',
          _str('employmentType'),
          'Employment Type:',
          '${_str('employmentDurationText')} ${_str('employmentDurationType')}',
          primary,
        ),
        SizedBox(height: 6.h),
        _summaryRow(
          'Experience Level:',
          _str('experienceLevel'),
          'Compensation Range:',
          '${(_job?['salaryMin'] as num?)?.toInt() ?? 0} - ${(_job?['salaryMax'] as num?)?.toInt() ?? 0}',
          primary,
        ),
        SizedBox(height: 6.h),
        _summaryText(
          'Required Qualification:',
          _biText(
            _job?['requiredQualification'] as Map<String, dynamic>?,
            false,
          ),
          primary,
        ),
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Skills:',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: _kLabel,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Wrap(
                spacing: 8.w,
                runSpacing: 6.h,
                children: ((_job?['requiredSkills'] as List<dynamic>?) ?? [])
                    .map(
                      (s) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: _kDivider),
                        ),
                        child: Text(
                          _biText(s['name'] as Map<String, dynamic>?, false),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12.sp,
                            color: _kLabel,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  PERSONAL INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPersonalInfo(Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: 'First Name',
                hint: 'Text Here',
                controller: _firstNameCtrl,
                height: 36,
                submitted: _formSubmitted,
                primaryColor: primary,
              ),
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: 'Last Name',
                hint: 'Text Here',
                controller: _lastNameCtrl,
                height: 36,
                submitted: _formSubmitted,
                primaryColor: primary,
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: 'Email',
                hint: 'Text Here',
                controller: _emailCtrl,
                height: 36,
                submitted: _formSubmitted,
                primaryColor: primary,
              ),
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phone',
                    style: StyleText.fontSize14Weight400.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 110.w,
                        child: CustomDropdownFormFieldInvMaster(
                          selectedValue: _countryCode,
                          items: _kCountryCodes,
                          widthIcon: 16,
                          heightIcon: 16,
                          height: 36,
                          dropdownColor: AppColors.background,
                          hint: Text(
                            '🇳🇬  +234',
                            style: StyleText.fontSize12Weight400.copyWith(
                              color: _kHint,
                            ),
                          ),
                          onChanged: (v) {
                            if (v != null) setState(() => _countryCode = v);
                          },
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: CustomValidatedTextFieldMaster(
                          hint: 'Text Here',
                          controller: _phoneCtrl,
                          height: 36,
                          onlyDigits: true,
                          submitted: false,
                          primaryColor: primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: 'Year Of Graduation',
                hint: 'Text Here',
                controller: _yearCtrl,
                height: 36,
                submitted: false,
                primaryColor: primary,
              ),
            ),
            SizedBox(width: 24.w),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  PROFILE INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildProfileInfo(Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Information',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'Resume*',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: _kLabel,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: _pickResume,
          child: Container(
            width: double.infinity,
            height: 130.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: _resumeFileName != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: primary, size: 28.sp),
                        SizedBox(height: 6.h),
                        Text(
                          _resumeFileName!,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12.sp,
                            color: _kLabel,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        GestureDetector(
                          onTap: _pickResume,
                          child: Text(
                            'Change File',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11.sp,
                              color: primary,
                              decoration: TextDecoration.underline,
                              decorationColor: primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSvg(
                        assetPath: "assets/images/upload.svg",
                        width: 40.w,
                        height: 40.h,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Drag & Drop files here',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12.sp,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        'Or',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11.sp,
                          color: Colors.black38,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'Browse Files',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        SizedBox(height: 16.h),
        CustomValidatedTextFieldMaster(
          label: 'Cover Letter*',
          hint: 'Insert Link',
          controller: _coverLinkCtrl,
          height: 36,
          submitted: false,
          primaryColor: primary,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  SEND BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSendButton(Color primary) {
    return GestureDetector(
      onTap: _submitting ? null : _submit,
      child: Container(
        width: double.infinity,
        height: 48.h,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: _submitting
              ? SizedBox(
                  width: 20.sp,
                  height: 20.sp,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'SEND',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  SUMMARY HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _summaryRow(
    String l1,
    String v1,
    String l2,
    String v2,
    Color primary,
  ) {
    return Row(
      children: [
        if (l1.isNotEmpty) Expanded(child: _summaryText(l1, v1, primary)),
        if (l2.isNotEmpty) ...[
          SizedBox(width: 16.w),
          Expanded(child: _summaryText(l2, v2, primary)),
        ],
      ],
    );
  }

  Widget _summaryText(String label, String value, Color primary) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: _kLabel,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }
}
