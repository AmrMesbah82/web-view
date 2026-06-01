// ═══════════════════════════════════════════════════════════════════
// FILE: job_detail_page.dart (Public Website — Job Detail)
// Path: lib/pages/job_detail_page.dart
// FIXED: Full bilingual support (Arabic + English)
// UPDATED: Added About Company section from AboutCompanyCubit
// FIXED: Removed duplicate bullets in Requirements/Preferred Skills sections
// ═══════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/main_widgets/app_footer.dart';
import '../../../../../core/main_widgets/app_navbar.dart';
import '../../../../../core/theme/appcolors.dart';
import '../../../../about_us/presentation/controller/about_us_company_cubit.dart';
import '../../../../about_us/presentation/controller/about_us_company_state.dart';
import '../../../../home/presentation/controller/home_cubit.dart';
import '../../../../home/presentation/controller/home_state.dart';
import '../../../../home/presentation/controller/lang_state.dart';

part '../widgets/labels.dart';

const Color _kGreen = Color(0xFF2D8C4E);
const Color _kDivider = Color(0xFFDDE8DD);

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

// ═══════════════════════════════════════════════════════════════════════════
//  BILINGUAL LABELS
// ═══════════════════════════════════════════════════════════════════════════

class JobDetailPage extends StatefulWidget {
  final String jobId;
  const JobDetailPage({super.key, required this.jobId});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  Map<String, dynamic>? _job;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadJob();
    context.read<AboutCompanyCubit>().loadAboutCompany();
  }

  Future<void> _loadJob() async {
    final doc = await FirebaseFirestore.instance
        .collection('jobListings')
        .doc(widget.jobId)
        .get(const GetOptions(source: Source.server))
        .onError((_, __) { if (mounted) setState(() => _loading = false); return Future.error(''); });
    if (!mounted) return;
    if (doc.exists && doc.data() != null) {
      setState(() {
        _job = doc.data()!;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCmsCubit, HomeCmsState>(
      builder: (context, homeState) {
        final primary = _parsePrimary(homeState);
        final bgColor = _parseBg(homeState);
        final isRtl = context.watch<LanguageCubit>().state.isArabic;
        final labels = _Labels(isRtl);

        if (_loading) {
          return Scaffold(
            backgroundColor: bgColor,
            body: Center(child: CircularProgressIndicator(color: primary)),
          );
        }

        if (_job == null) {
          return Scaffold(
            backgroundColor: bgColor,
            body: Center(child: Text(labels.jobNotFound)),
          );
        }

        final title = _biText(_job!['title'] as Map<String, dynamic>?, isRtl);
        final about = _biText(
          _job!['aboutThisPosition'] as Map<String, dynamic>?,
          isRtl,
        );
        final requirements = _biText(
          _job!['requirements'] as Map<String, dynamic>?,
          isRtl,
        );
        final preferred = _biText(
          _job!['preferredSkills'] as Map<String, dynamic>?,
          isRtl,
        );
        final qualification = _biText(
          _job!['requiredQualification'] as Map<String, dynamic>?,
          isRtl,
        );
        final skills = (_job!['requiredSkills'] as List<dynamic>? ?? [])
            .map((s) => _biText(s['name'] as Map<String, dynamic>?, isRtl))
            .where((s) => s.isNotEmpty)
            .toList();
        final benefits = (_job!['benefits'] as List<dynamic>? ?? []);

        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: bgColor,
            body: Column(
              children: [
                // ✅ Navbar — fixed at top
                AppNavbar(currentRoute: '/careers'),

                // ✅ Content — scrolls
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(height: 40.h),

                          // ── Centered 1000.w column ──
                          Center(
                            child: SizedBox(
                              width: 1000.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ── Title ──
                                  Text(
                                    title,
                                    style: TextStyle(

                                      fontSize: 36.sp,
                                      fontWeight: FontWeight.w700,
                                      color: primary,
                                    ),
                                  ),
                                  SizedBox(height: 24.h),

                                  // ── Job Info Card ──
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(24.sp),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: TextStyle(

                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        Divider(color: _kDivider),
                                        SizedBox(height: 12.h),
                                        _infoRow(
                                          labels.hireDate,
                                          _fmtDate(_str('hiringStartDate')),
                                          labels.hireEndDate,
                                          _fmtDate(_str('hiringEndDate')),
                                          primary,
                                        ),
                                        SizedBox(height: 8.h),
                                        _infoRow(
                                          labels.workType,
                                          _str('workType'),
                                          '',
                                          '',
                                          primary,
                                        ),
                                        SizedBox(height: 8.h),
                                        _infoRow(
                                          labels.employmentType,
                                          _str('employmentType'),
                                          labels.employmentDuration,
                                          '${_str('employmentDurationText')} ${_str('employmentDurationType')}',
                                          primary,
                                        ),
                                        SizedBox(height: 8.h),
                                        _infoRow(
                                          labels.experienceLevel,
                                          _str('experienceLevel'),
                                          labels.compensationRange,
                                          '${(_job!['salaryMin'] as num?)?.toInt() ?? 0} - ${(_job!['salaryMax'] as num?)?.toInt() ?? 0}',
                                          primary,
                                        ),
                                        SizedBox(height: 8.h),
                                        _singleInfo(
                                          labels.requiredQualification,
                                          qualification,
                                          primary,
                                        ),
                                        if (skills.isNotEmpty) ...[
                                          SizedBox(height: 12.h),
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                labels.skills,
                                                style: TextStyle(

                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Expanded(
                                                child: Wrap(
                                                  spacing: 8.w,
                                                  runSpacing: 6.h,
                                                  children: skills
                                                      .map(
                                                        (s) => Container(
                                                      padding:
                                                      EdgeInsets.symmetric(
                                                        horizontal:
                                                        12.w,
                                                        vertical: 4.h,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: bgColor,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                          6.r,
                                                        ),
                                                        border: Border.all(
                                                          color: _kDivider,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        s,
                                                        style: TextStyle(

                                                          fontSize: 13.sp,
                                                          color: Colors
                                                              .black87,
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
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.h),

                                  // ── About This Position ──
                                  if (about.isNotEmpty)
                                    _textSection(
                                      labels.aboutThisPosition,
                                      about,
                                      primary,
                                    ),

                                  // ── About Company (from AboutCompanyCubit) ──
                                  BlocBuilder<
                                      AboutCompanyCubit,
                                      AboutCompanyState
                                  >(
                                    builder: (context, aboutState) {
                                      String aboutCompanyText = '';

                                      if (aboutState is AboutCompanyLoaded) {
                                        aboutCompanyText = isRtl
                                            ? aboutState.data.aboutAr
                                            : aboutState.data.aboutEn;
                                      } else if (aboutState
                                      is AboutCompanySaved) {
                                        aboutCompanyText = isRtl
                                            ? aboutState.data.aboutAr
                                            : aboutState.data.aboutEn;
                                      } else if (aboutState
                                      is AboutCompanyError &&
                                          aboutState.lastData != null) {
                                        aboutCompanyText = isRtl
                                            ? aboutState.lastData!.aboutAr
                                            : aboutState.lastData!.aboutEn;
                                      }

                                      if (aboutCompanyText.trim().isEmpty) {
                                        return const SizedBox.shrink();
                                      }

                                      return _textSection(
                                        labels.aboutCompany,
                                        aboutCompanyText,
                                        primary,
                                      );
                                    },
                                  ),

                                  // ── Requirements ──
                                  if (requirements.isNotEmpty)
                                    _textSection(
                                      labels.requirements,
                                      requirements,
                                      primary,
                                    ),

                                  // ── Preferred Skills ──
                                  if (preferred.isNotEmpty)
                                    _textSection(
                                      labels.preferredSkills,
                                      preferred,
                                      primary,
                                    ),

                                  // ── Benefits ──
                                  if (benefits.isNotEmpty)
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(bottom: 20.h),
                                      padding: EdgeInsets.all(24.sp),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            labels.benefits,
                                            style: TextStyle(

                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w700,
                                              color: primary,
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          ...benefits.map((b) {
                                            final bMap =
                                            b as Map<String, dynamic>;
                                            final bTitle = _biText(
                                              bMap['title']
                                              as Map<String, dynamic>?,
                                              isRtl,
                                            );
                                            final bDesc = _biText(
                                              bMap['shortDescription']
                                              as Map<String, dynamic>?,
                                              isRtl,
                                            );
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                bottom: 16.h,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 180.w,
                                                    child: Text(
                                                      bTitle,
                                                      style: TextStyle(

                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 16.w),
                                                  Expanded(
                                                    child: Text(
                                                      bDesc,
                                                      style: TextStyle(

                                                        fontSize: 13.sp,
                                                        height: 1.6,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),

                                  // ── Bottom buttons ──
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          final timestamp = DateTime.now()
                                              .millisecondsSinceEpoch;
                                          final base = Uri.base.origin;
                                          final jobTitle = _biText(
                                            _job!['title']
                                            as Map<String, dynamic>?,
                                            false,
                                          );
                                          final slug = jobTitle
                                              .toLowerCase()
                                              .replaceAll(' ', '-');
                                          final url =
                                              '$base/jobs/${widget.jobId}?title=$slug&t=$timestamp';
                                          Clipboard.setData(
                                            ClipboardData(text: url),
                                          );
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(12.r),
                                              ),
                                              title: Text(
                                                labels.linkCopied,
                                                style: TextStyle(

                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: primary,
                                                ),
                                              ),
                                              content: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 10.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: bgColor,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    8.r,
                                                  ),
                                                  border: Border.all(
                                                    color: _kDivider,
                                                  ),
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
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20.w,
                                            vertical: 10.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: primary,
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.share,
                                                size: 16.sp,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 6.w),
                                              Text(
                                                labels.share,
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => context.go(
                                          '/jobs/${widget.jobId}/apply',
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 24.w,
                                            vertical: 10.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: primary,
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                labels.apply,
                                                style: TextStyle(

                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 6.w),
                                              Icon(
                                                Icons.arrow_forward,
                                                size: 16.sp,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
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

                // ✅ Footer — fixed at bottom
                const AppFooter(),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _infoRow(String l1, String v1, String l2, String v2, Color primary) {
    return Row(
      children: [
        if (l1.isNotEmpty) Expanded(child: _singleInfo(l1, v1, primary)),
        if (l2.isNotEmpty) ...[
          SizedBox(width: 16.w),
          Expanded(child: _singleInfo(l2, v2, primary)),
        ],
      ],
    );
  }

  Widget _singleInfo(String label, String value, Color primary) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label ',
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
              color: primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textSection(String title, String content, Color primary) {
    final lines = content
        .split('\n')
        .where((l) => l.trim().isNotEmpty)
        .toList();
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(24.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(

              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: primary,
            ),
          ),
          SizedBox(height: 12.h),
          ...lines.map(
                (line) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Text(
                line.trim(),
                style: TextStyle(

                  fontSize: 13.sp,
                  height: 1.6,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
