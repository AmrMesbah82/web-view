part of '../pages/job_page.dart';

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
