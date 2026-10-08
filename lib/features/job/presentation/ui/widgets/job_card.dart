part of '../pages/job_page.dart';

class _JobCard extends StatefulWidget {
  final JobPostModel job;
  final _L l;
  final Color primary;
  const _JobCard({required this.job, required this.l, required this.primary});

  @override
  State<_JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<_JobCard> {
  bool _hovered = false;

  /// Bilingual date — localized month name AND numerals (EN/AR).
  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    return FormDateTimeHelper.formatDayMonthYear(dt, arabic: widget.l.isAr);
  }

  /// Localizes digits inside any value when the page is in Arabic.
  String _num(String text) =>
      widget.l.isAr ? FormDateTimeHelper.toArabicDigits(text) : text;

  String _pick(String en, String ar) {
    if (widget.l.isAr) return ar.isNotEmpty ? ar : en;
    return en.isNotEmpty ? en : ar;
  }

  String get _salaryDisplay {
    final j = widget.job;
    if (j.salaryMax > 0) {
      return _num('${j.salaryMin.toInt()} - ${j.salaryMax.toInt()} ${j.salaryCurrency}');
    }
    if (j.salaryMin > 0) return _num('${j.salaryMin.toInt()} ${j.salaryCurrency}');
    return '—';
  }

  /// Employment duration — same as the detail page: "text + type" (EN/AR digits).
  String get _durationDisplay {
    final j = widget.job;
    final unit = j.employmentDurationType.localized(widget.l.isAr);
    if (j.employmentDurationText.isNotEmpty) {
      return _num('${j.employmentDurationText} $unit');
    }
    return unit;
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
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
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
                    FormatHelper.capitalize(title.isEmpty ? l.untitled : title),
                    textAlign: l.isAr ? TextAlign.right : TextAlign.left,
                    style: StyleText.fontSize14Weight400.copyWith(
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
                            style: StyleText.fontSize16Weight700.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: widget.primary,
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
                              style: StyleText.fontSize14Weight400.copyWith(
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
                      color: widget.primary,
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

            // ── Info columns — left / right split ────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoItem(
                          label: l.hireDate,
                          value: _formatDate(job.hiringStartDate),
                          primary: widget.primary),
                      SizedBox(height: 10.h),
                      _InfoItem(
                          label: l.workType,
                          value: job.workType.localized(l.isAr),
                          primary: widget.primary),
                      SizedBox(height: 10.h),
                      _InfoItem(
                          label: l.employmentType,
                          value: job.employmentType.localized(l.isAr),
                          primary: widget.primary),
                      SizedBox(height: 10.h),
                      _InfoItem(
                          label: l.experienceLevel,
                          value: job.experienceLevel.localized(l.isAr),
                          primary: widget.primary),
                      SizedBox(height: 10.h),
                      _InfoItem(
                          label: l.qualification,
                          value: qual.isEmpty ? '—' : qual,
                          primary: widget.primary),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                // Right side
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoItem(
                          label: l.hireEndDate,
                          value: _formatDate(job.hiringEndDate),
                          primary: widget.primary),
                      // Location — pin icon + text (Figma style), On Site only
                      if (job.workType == WorkType.onSite) ...[
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            CustomSvg(
                              assetPath: "assets/images/careers/location.svg",
                              width: 16.w,
                              height: 20.h,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              job.location.isNotEmpty
                                  ? FormatHelper.capitalize(job.location)
                                  : l.locationLabel,
                              style: StyleText.fontSize14Weight400.copyWith(
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 10.h),
                      _InfoItem(
                          label: l.employmentDuration,
                          value: _durationDisplay,
                          primary: widget.primary),
                      SizedBox(height: 10.h),
                      _InfoItem(
                          label: l.compensation,
                          value: _salaryDisplay,
                          primary: widget.primary),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),

            // // ── Skills ───────────────────────────────────────────────────
            // if (job.requiredSkills.isNotEmpty) ...[
            //   Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Text(
            //         l.skillsLabel,
            //         style: StyleText.fontSize15Weight600.copyWith(
            //           fontSize: 15.sp,
            //           fontWeight: FontWeight.w600,
            //           color: Colors.black87,
            //         ),
            //       ),
            //       SizedBox(width: 10.w),
            //       Expanded(
            //         child: Wrap(
            //           spacing: 8.w,
            //           runSpacing: 6.h,
            //           children: job.requiredSkills
            //               .map((s) => Container(
            //             padding: EdgeInsets.symmetric(
            //                 horizontal: 12.w, vertical: 4.h),
            //             decoration: BoxDecoration(
            //               color: AppColors.background,
            //               borderRadius: BorderRadius.circular(6.r),
            //             ),
            //             child: Text(
            //               FormatHelper.capitalize(_pick(s.name.en, s.name.ar)),
            //               style: StyleText.fontSize14Weight400.copyWith(
            //                 fontSize: 13.sp,
            //                 color: Colors.black87,
            //               ),
            //             ),
            //           ))
            //               .toList(),
            //         ),
            //       ),
            //     ],
            //   ),
            //   SizedBox(height: 16.h),
            // ],

            // ── View button (location moved to right info column) ────────
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: _ViewJobBtn(
                  jobId: job.id, label: l.viewJob, primary: widget.primary),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Info Item ────────────────────────────────────────────────────────────────
