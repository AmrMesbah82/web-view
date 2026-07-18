// ═══════════════════════════════════════════════════════════════════
// FILE: job_apply_page.dart (Public Website — Apply Form)
// Path: lib/pages/job_apply_page.dart
// UPDATED: Full AR/EN bilingual support with RTL layout
// UPDATED: Phone field now matches contact page implementation with country dropdown + number field
// UPDATED: Cover letter field now validates as proper URL/link format
// UPDATED: Resume upload now accepts PDF files only with validation
// UPDATED: Send button shows CircularProgressIndicator only (no full-screen overlay)
// UPDATED: Required documents are now DYNAMIC — read from admin's requiredDocuments array
//          PDF type → file upload box | Link type → URL text field
// ═══════════════════════════════════════════════════════════════════

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:website_app/core/custom_svg.dart';
import 'package:website_app/core/widgets/custom_dropdown.dart';
import 'package:website_app/core/widgets/textfield.dart';

import '../../../../../core/main_widgets/app_footer.dart';
import '../../../../../core/main_widgets/app_navbar.dart';
import '../../../../../core/theme/appcolors.dart';
import '../../../../../core/theme/new_theme.dart';
import '../../../../home/presentation/controller/home_cubit.dart';
import '../../../../home/presentation/controller/home_state.dart';
import '../../../../home/presentation/controller/lang_state.dart';

part '../widgets/doc_field_state.dart';
part '../widgets/phone_field.dart';
part '../widgets/url_validated_text_field.dart';

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
  final cl = hex.replaceAll('#', '');
  if (cl.length == 6) {
    final value = int.tryParse('FF\$cl', radix: 16);
    if (value != null) return Color(value);
  }
  return _kGreen;
}

Color _parseBg(HomeCmsState state) {
  final hex = switch (state) {
    HomeCmsLoaded(:final data) => data.branding.backgroundColor,
    HomeCmsSaved(:final data) => data.branding.backgroundColor,
    _ => '',
  };
  final cl = hex.replaceAll('#', '');
  if (cl.length == 6) {
    final value = int.tryParse('FF\$cl', radix: 16);
    if (value != null) return Color(value);
  }
  return AppColors.background;
}

// ── Bilingual helper (top-level, no context needed) ──────────────────────────
String _t(String en, String ar, bool isRtl) => isRtl ? ar : en;

const List<Map<String, String>> _kCountryCodes = [
  {'key': '+20', 'value': '🇪🇬 +20'},
  {'key': '+234', 'value': '🇳🇬 +234'},
  {'key': '+212', 'value': '🇲🇦 +212'},
  {'key': '+213', 'value': '🇩🇿 +213'},
  {'key': '+216', 'value': '🇹🇳 +216'},
  {'key': '+249', 'value': '🇸🇩 +249'},
  {'key': '+251', 'value': '🇪🇹 +251'},
  {'key': '+254', 'value': '🇰🇪 +254'},
  {'key': '+27', 'value': '🇿🇦 +27'},
  {'key': '+966', 'value': '🇸🇦 +966'},
  {'key': '+971', 'value': '🇦🇪 +971'},
  {'key': '+965', 'value': '🇰🇼 +965'},
  {'key': '+974', 'value': '🇶🇦 +974'},
  {'key': '+973', 'value': '🇧🇭 +973'},
  {'key': '+968', 'value': '🇴🇲 +968'},
  {'key': '+962', 'value': '🇯🇴 +962'},
  {'key': '+961', 'value': '🇱🇧 +961'},
  {'key': '+963', 'value': '🇸🇾 +963'},
  {'key': '+964', 'value': '🇮🇶 +964'},
  {'key': '+967', 'value': '🇾🇪 +967'},
  {'key': '+970', 'value': '🇵🇸 +970'},
  {'key': '+90', 'value': '🇹🇷 +90'},
  {'key': '+98', 'value': '🇮🇷 +98'},
  {'key': '+44', 'value': '🇬🇧 +44'},
  {'key': '+33', 'value': '🇫🇷 +33'},
  {'key': '+49', 'value': '🇩🇪 +49'},
  {'key': '+1', 'value': '🇺🇸 +1'},
  {'key': '+91', 'value': '🇮🇳 +91'},
  {'key': '+86', 'value': '🇨🇳 +86'},
  {'key': '+81', 'value': '🇯🇵 +81'},
  {'key': '+61', 'value': '🇦🇺 +61'},
  {'key': '+64', 'value': '🇳🇿 +64'},
];

// ═══════════════════════════════════════════════════════════════════════════════
//  DYNAMIC DOCUMENT STATE — tracks each required document's upload / link
// ═══════════════════════════════════════════════════════════════════════════════

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

  String _countryCode = '+20';

  // ── Dynamic document fields — built from admin requiredDocuments ──
  List<_DocFieldState> _docFields = [];

  @override
  void initState() {
    super.initState();
    _loadJob();
  }

  Future<void> _loadJob() async {
    final doc = await FirebaseFirestore.instance
        .collection('jobListings')
        .doc(widget.jobId)
        .get(const GetOptions(source: Source.server))
        .onError((_, __) { if (mounted) setState(() => _loadingJob = false); return Future.error(''); });
    if (!mounted) return;
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      setState(() {
        _job = data;
        _loadingJob = false;
        _buildDocFields(data);
      });
    } else {
      setState(() => _loadingJob = false);
    }
  }

  /// Reads the requiredDocuments array from the job doc and creates
  /// a _DocFieldState for each one.
  /// Fallback: if requiredDocuments is empty or missing, default to
  /// Resume (PDF) + Cover Letter (Link) for backward compatibility.
  void _buildDocFields(Map<String, dynamic> jobData) {
    final rawDocs = jobData['requiredDocuments'] as List<dynamic>? ?? [];

    if (rawDocs.isEmpty) {
      // ── Fallback — legacy jobs without requiredDocuments ──
      _docFields = [
        _DocFieldState(name: 'Resume', docType: 'PDF'),
        _DocFieldState(name: 'Cover Letter', docType: 'Link'),
      ];
      return;
    }

    _docFields = rawDocs.map((d) {
      final map = d as Map<String, dynamic>;
      final name = map['name'] as String? ?? 'Document';
      final type = map['docType'] as String? ?? 'PDF';
      return _DocFieldState(name: name, docType: type);
    }).toList();

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
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day} ${m[dt.month - 1]} ${dt.year}';
  }

  // ── PDF-only file picker for a specific doc field ──────────────────────────
  Future<void> _pickFile(int index) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final ext = file.name.split('.').last.toLowerCase();

      if (ext != 'pdf') {
        setState(() {
          _docFields[index].error = 'pdf_only';
          _docFields[index].fileName = null;
          _docFields[index].fileBytes = null;
        });
        return;
      }

      setState(() {
        _docFields[index].fileName = file.name;
        _docFields[index].fileBytes = file.bytes;
        _docFields[index].error = null;
      });
    }
  }

  /// Remove a picked file from a doc field
  void _removeFile(int index) {
    setState(() {
      _docFields[index].fileName = null;
      _docFields[index].fileBytes = null;
      _docFields[index].uploadedUrl = null;
      _docFields[index].error = null;
    });
  }

  /// Upload a single PDF doc field to Firebase Storage
  Future<String?> _uploadDocFile(_DocFieldState doc) async {
    if (doc.fileBytes == null || doc.fileName == null) return null;
    final safeName = doc.name.replaceAll(' ', '_').toLowerCase();
    final ref = FirebaseStorage.instance.ref(
      'applications/${widget.jobId}/${DateTime.now().millisecondsSinceEpoch}_${safeName}_${doc.fileName}',
    );
    final task = await ref.putData(
      doc.fileBytes!,
      SettableMetadata(contentType: 'application/pdf'),
    ).onError((_, __) => null as TaskSnapshot);
    if (task == null) return null;
    return await task.ref.getDownloadURL().onError((_, __) => '');
  }

  // ── URL Validation Helper ──────────────────────────────────────────────────
  bool _isValidUrl(String url) {
    if (url.isEmpty) return true;

    String testUrl = url.trim();
    if (!testUrl.startsWith('http://') && !testUrl.startsWith('https://')) {
      testUrl = 'https://$testUrl';
    }

    final uri = Uri.tryParse(testUrl);
    if (uri == null) return false;

    return uri.hasScheme && uri.hasAuthority && uri.host.contains('.');
  }

  Future<void> _submit(bool isRtl) async {
    setState(() => _formSubmitted = true);

    // ── Validate required personal fields ──
    if (_firstNameCtrl.text.trim().isEmpty ||
        _emailCtrl.text.trim().isEmpty ||
        _phoneCtrl.text.trim().isEmpty ||
        _yearCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _t('Please fill required fields', 'يرجى ملء الحقول المطلوبة', isRtl),
          ),
        ),
      );
      return;
    }

    // ── Validate all Link-type doc fields for valid URL ──
    for (final doc in _docFields) {
      if (doc.docType == 'Link') {
        final link = doc.linkController.text.trim();
        if (link.isNotEmpty && !_isValidUrl(link)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _t(
                  'Please enter a valid URL for ${doc.name} (e.g., https://example.com/document)',
                  'يرجى إدخال رابط صالح لـ ${doc.name} (مثال: https://example.com/document)',
                  isRtl,
                ),
              ),
              duration: const Duration(seconds: 4),
            ),
          );
          return;
        }
      }
    }

    // ── Check for PDF upload errors ──
    for (final doc in _docFields) {
      if (doc.docType == 'PDF' && doc.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _t(
                'Please upload a valid PDF file for ${doc.name}.',
                'يرجى رفع ملف PDF صالح لـ ${doc.name}.',
                isRtl,
              ),
            ),
          ),
        );
        return;
      }
    }

    setState(() => _submitting = true);

    // ── Upload all PDF doc fields ──
    for (final doc in _docFields) {
      if (doc.docType == 'PDF' && doc.fileBytes != null) {
        doc.uploadedUrl = await _uploadDocFile(doc);
      }
    }

    final jobTitle = _biText(_job?['title'] as Map<String, dynamic>?, isRtl);

    // ── Build resumeUrl + coverLetterUrl for backward-compatible fields ──
    // Also build a dynamic documents array for full flexibility
    String resumeUrl = '';
    String resumeName = '';
    String coverLetterUrl = '';
    String coverLetterName = '';

    final List<Map<String, String>> documentsArray = [];

    for (final doc in _docFields) {
      final docName = doc.name;
      String url = '';
      String fileName = '';

      if (doc.docType == 'PDF') {
        url = doc.uploadedUrl ?? '';
        fileName = doc.fileName ?? '';
      } else {
        url = doc.linkController.text.trim();
        fileName = url.isNotEmpty ? 'Link' : '';
      }

      documentsArray.add({
        'name': docName,
        'docType': doc.docType,
        'url': url,
        'fileName': fileName,
      });

      // ── Backward compat: map known names to legacy fields ──
      final lowerName = docName.toLowerCase();
      if (lowerName == 'resume' || lowerName == 'cv') {
        resumeUrl = url;
        resumeName = fileName;
      } else if (lowerName == 'cover letter' || lowerName == 'cover_letter') {
        coverLetterUrl = url;
        coverLetterName = fileName;
      }
    }

    final submitFailed = await FirebaseFirestore.instance
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
      // ── Legacy fields (backward compat) ──
      'resumeUrl': resumeUrl,
      'resumeName': resumeName,
      'coverLetterUrl': coverLetterUrl,
      'coverLetterName': coverLetterName,
      // ── NEW: full dynamic documents array ──
      'documents': documentsArray,
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
      'requiredSkills':
      (_job?['requiredSkills'] as List<dynamic>? ?? [])
          .map(
            (s) =>
            _biText(s['name'] as Map<String, dynamic>?, isRtl),
      )
          .join(', '),
    }).then<Object?>((_) => null).onError((e, __) => e);
    if (!mounted) return;
    if (submitFailed != null) {
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _t('Failed to submit', 'فشل في الإرسال', isRtl),
          ),
        ),
      );
      return;
    }
    await FirebaseFirestore.instance
        .collection('jobListings')
        .doc(widget.jobId)
        .update({'totalApplications': FieldValue.increment(1)});
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _submitted = true;
    });
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _yearCtrl.dispose();
    for (final doc in _docFields) {
      doc.dispose();
    }
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  BUILD
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
            body: Column(
              children: [
                AppNavbar(currentRoute: '/careers'),
                Expanded(child: Center(child: CircularProgressIndicator(color: primary))),
                const AppFooter(),
              ],
            ),
          );
        if (_submitted) return _buildSuccessScreen(primary, isRtl);

        final title = _biText(_job?['title'] as Map<String, dynamic>?, isRtl);

        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: const Color(0xFFF1F2ED),
            body: Column(
              children: [
                AppNavbar(currentRoute: '/careers'),
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(height: 40.h),
                          Center(
                            child: SizedBox(
                              width: 1000.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _t('Applying For Job', 'التقديم على وظيفة', isRtl),
                                    style: StyleText.fontSize14Weight400.copyWith(
                                      fontFamily: 'Cairo',
                                      fontSize: 36.sp,
                                      fontWeight: FontWeight.w700,
                                      color: primary,
                                    ),
                                  ),
                                  SizedBox(height: 24.h),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(28.sp),
                                    decoration: BoxDecoration(
                                      color: AppColors.card,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildJobSummary(title, primary, bgColor, isRtl),
                                        SizedBox(height: 28.h),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF1F2ED),
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15.w,
                                              vertical: 15.h,
                                            ),
                                            child: Column(
                                              children: [
                                                _buildPersonalInfo(primary, isRtl),
                                                SizedBox(height: 28.h),
                                                _buildProfileInfo(primary, isRtl),
                                                SizedBox(height: 24.h),
                                                _buildSendButton(primary, isRtl),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 64.h),
                                ],
                              ),
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
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  SUCCESS SCREEN
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSuccessScreen(Color primary, bool isRtl) {
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F2ED),
        body: Column(
          children: [
            AppNavbar(currentRoute: '/careers'),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
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
                                  _t(
                                    "YOU'VE OFFICIALLY APPLIED — AND WE'RE EXCITED TO LEARN MORE ABOUT YOU!",
                                    'لقد تقدّمت رسمياً — ونحن متحمسون للتعرف عليك أكثر!',
                                    isRtl,
                                  ),
                                  textAlign: TextAlign.center,
                                  style: StyleText.fontSize14Weight400.copyWith(
                                    fontFamily: 'Cairo',
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  _t(
                                    'Your application has been successfully received. Our team will review your submission and contact you if your qualifications match our current opportunities. Thank you for considering Bayanatz as the next step in your career.',
                                    'تم استلام طلبك بنجاح. سيقوم فريقنا بمراجعة طلبك والتواصل معك إذا كانت مؤهلاتك تتناسب مع الفرص المتاحة لدينا. شكراً لاختيارك بيانات محطةً لمسيرتك المهنية.',
                                    isRtl,
                                  ),
                                  textAlign: TextAlign.center,
                                  style: StyleText.fontSize14Weight400.copyWith(
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
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  JOB SUMMARY
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildJobSummary(
      String title, Color primary, Color bgColor, bool isRtl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.isEmpty ? _t('Untitled', 'بدون عنوان', isRtl) : title,
          style: StyleText.fontSize16Weight700.copyWith(
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
          _t('Hire Date:', 'تاريخ التعيين:', isRtl),
          _fmtDate(_str('hiringStartDate')),
          _t('Hire End Date:', 'تاريخ انتهاء التعيين:', isRtl),
          _fmtDate(_str('hiringEndDate')),
          primary,
        ),
        SizedBox(height: 6.h),
        _summaryRow(
          _t('Work Type:', 'نوع العمل:', isRtl),
          _str('workType'),
          '',
          '',
          primary,
        ),
        SizedBox(height: 6.h),
        _summaryRow(
          _t('Employment Type:', 'نوع التوظيف:', isRtl),
          _str('employmentType'),
          _t('Employment Duration:', 'مدة التوظيف:', isRtl),
          '${_str('employmentDurationText')} ${_str('employmentDurationType')}',
          primary,
        ),
        SizedBox(height: 6.h),
        _summaryRow(
          _t('Experience Level:', 'مستوى الخبرة:', isRtl),
          _str('experienceLevel'),
          _t('Compensation Range:', 'نطاق الراتب:', isRtl),
          '${(_job?['salaryMin'] as num?)?.toInt() ?? 0} - ${(_job?['salaryMax'] as num?)?.toInt() ?? 0}',
          primary,
        ),
        SizedBox(height: 6.h),
        _summaryText(
          _t('Required Qualification:', 'المؤهل المطلوب:', isRtl),
          _biText(
            _job?['requiredQualification'] as Map<String, dynamic>?,
            isRtl,
          ),
          primary,
        ),
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _t('Skills:', 'المهارات:', isRtl),
              style: StyleText.fontSize13Weight500.copyWith(
                fontFamily: 'Cairo',
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
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
                      _biText(s['name'] as Map<String, dynamic>?, isRtl),
                      style: StyleText.fontSize14Weight400.copyWith(
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

  Widget _buildPersonalInfo(Color primary, bool isRtl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t('Personal Information', 'المعلومات الشخصية', isRtl),
          style: StyleText.fontSize16Weight700.copyWith(
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
                label: _t('First Name', 'الاسم الأول', isRtl),
                hint: _t('Text Here', 'اكتب هنا', isRtl),
                controller: _firstNameCtrl,
                height: 36,
                fillColor: Colors.white,
                submitted: _formSubmitted,
                primaryColor: primary,
              ),
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: CustomValidatedTextFieldMaster(
                label: _t('Last Name', 'اسم العائلة', isRtl),
                hint: _t('Text Here', 'اكتب هنا', isRtl),
                controller: _lastNameCtrl,
                height: 36,
                fillColor: Colors.white,
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
                label: _t('Email', 'البريد الإلكتروني', isRtl),
                hint: _t('Text Here', 'اكتب هنا', isRtl),
                controller: _emailCtrl,
                height: 36,
                fillColor: Colors.white,
                submitted: _formSubmitted,
                primaryColor: primary,
              ),
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: _PhoneField(
                label: _t('Phone Number', 'رقم الهاتف', isRtl),
                controller: _phoneCtrl,
                submitted: _formSubmitted,
                selectedCode: _countryCode,
                onCodeChanged: (v) {
                  if (v != null) setState(() => _countryCode = v);
                },
                isRtl: isRtl,
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
                label: _t('Year Of Graduation', 'سنة التخرج', isRtl),
                hint: _t('Text Here', 'اكتب هنا', isRtl),
                controller: _yearCtrl,
                height: 36,
                fillColor: Colors.white,
                onlyDigits: true,
                submitted: _formSubmitted,
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
  //  PROFILE INFORMATION — DYNAMIC DOCUMENTS FROM ADMIN
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildProfileInfo(Color primary, bool isRtl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t('Profile Information', 'معلومات الملف الشخصي', isRtl),
          style: StyleText.fontSize16Weight700.copyWith(
            fontFamily: 'Cairo',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        SizedBox(height: 16.h),

        // ── Dynamically render each required document ──
        ...List.generate(_docFields.length, (i) {
          final doc = _docFields[i];
          if (doc.docType == 'PDF') {
            return _buildPdfUploadField(i, doc, primary, isRtl);
          } else {
            return _buildLinkField(i, doc, primary, isRtl);
          }
        }),
      ],
    );
  }

  /// Builds a PDF upload box for a given document requirement
  Widget _buildPdfUploadField(
      int index, _DocFieldState doc, Color primary, bool isRtl) {
    final bool hasError = doc.error != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label ──
        Text(
          doc.name,
          style: StyleText.fontSize13Weight500.copyWith(
            fontFamily: 'Cairo',
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: _kLabel,
          ),
        ),
        SizedBox(height: 8.h),
        // ── Upload box ──
        Stack(
          children: [
            GestureDetector(
              onTap: doc.fileName != null ? null : () => _pickFile(index),
              child: Container(
                width: double.infinity,
                height: 130.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: hasError ? Colors.red : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: doc.fileName != null
                    ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.picture_as_pdf,
                          color: primary, size: 28.sp),
                      SizedBox(height: 6.h),
                      Text(
                        doc.fileName!,
                        style: StyleText.fontSize14Weight400.copyWith(
                          fontFamily: 'Cairo',
                          fontSize: 12.sp,
                          color: _kLabel,
                        ),
                      ),
                    ],
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomSvg(
                      assetPath: "assets/images/upload-image.svg",
                      width: 40.w,
                      height: 40.h,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _t(
                        'Drag & Drop your PDF here',
                        'اسحب وأفلت ملف PDF هنا',
                        isRtl,
                      ),
                      style: StyleText.fontSize14Weight400.copyWith(
                        fontFamily: 'Cairo',
                        fontSize: 12.sp,
                        color: Colors.black54,
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
                        _t('Browse Files', 'استعراض الملفات', isRtl),
                        style: StyleText.fontSize12Weight600.copyWith(
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
            // ── Red remove button ──
            if (doc.fileName != null)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: () => _removeFile(index),
                  child: Container(
                    width: 20.sp,
                    height: 20.sp,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 14.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),
        // ── PDF error message ──
        if (hasError) ...[
          SizedBox(height: 4.h),
          Text(
            _t(
              'Invalid file type. Please upload a PDF file only.',
              'نوع الملف غير صالح. يرجى رفع ملف PDF فقط.',
              isRtl,
            ),
            style: StyleText.fontSize14Weight400.copyWith(
              fontFamily: 'Cairo',
              fontSize: 11.sp,
              color: Colors.red,
            ),
          ),
        ],
        SizedBox(height: 16.h),
      ],
    );
  }

  /// Builds a URL text field for a given document requirement (Link type)
  Widget _buildLinkField(
      int index, _DocFieldState doc, Color primary, bool isRtl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _UrlValidatedTextField(
          label: doc.name,
          hint: _t(
            'https://example.com/${doc.name.toLowerCase().replaceAll(' ', '-')}',
            'https://example.com/${doc.name.toLowerCase().replaceAll(' ', '-')}',
            isRtl,
          ),
          controller: doc.linkController,
          submitted: _formSubmitted,
          primaryColor: primary,
          isRtl: isRtl,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  SEND BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSendButton(Color primary, bool isRtl) {
    return GestureDetector(
      onTap: _submitting ? null : () => _submit(isRtl),
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
            _t('SEND', 'إرسال', isRtl),
            style: StyleText.fontSize16Weight700.copyWith(
              fontFamily: 'Cairo',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: isRtl ? 0 : 1,
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
            style: StyleText.fontSize13Weight500.copyWith(
              fontFamily: 'Cairo',
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: _kLabel,
            ),
          ),
          TextSpan(
            text: value,
            style: StyleText.fontSize13Weight600.copyWith(
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

// ═══════════════════════════════════════════════════════════════════════════════
//  PHONE FIELD WIDGET — MATCHES CONTACT PAGE IMPLEMENTATION
// ═══════════════════════════════════════════════════════════════════════════════
