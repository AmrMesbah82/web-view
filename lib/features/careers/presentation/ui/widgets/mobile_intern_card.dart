part of '../pages/careers_page.dart';

class _MobileInternCard extends StatelessWidget {
  final InternModel data;
  final Color primary;
  final bool isRtl;
  const _MobileInternCard({
    required this.data,
    required this.primary,
    required this.isRtl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Photo: network if available, asset fallback ────────────
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: primary, width: 1.5),
                  ),
                  child: ClipOval(
                    child: data.photoUrl.isNotEmpty
                        ? Image.network(
                      data.photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/careers/person.png',
                        fit: BoxFit.cover,
                      ),
                    )
                        : Image.asset(
                      'assets/images/careers/person.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  data.fullName,
                  textAlign: TextAlign.center,
                  style: StyleText.fontSize12Weight500.copyWith(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  data.degrees,
                  textAlign: TextAlign.center,
                  style: StyleText.fontSize10Weight400.copyWith(
                    fontSize: 9.sp,
                    color: Colors.black45,
                    height: 1.3,
                  ),
                ),
                // ── Position ───────────────────────────────────────────
                if (data.position.isNotEmpty) ...[
                  SizedBox(height: 5.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      data.position,
                      textAlign: TextAlign.center,
                      style: StyleText.fontSize10Weight400.copyWith(
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 6.h),
                Wrap(
                  spacing: 3.w,
                  runSpacing: 3.h,
                  alignment: WrapAlignment.center,
                  children: data.tags
                      .map(
                        (tag) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        tag,
                        style: StyleText.fontSize10Weight700
                            .copyWith(fontSize: 9.sp),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                Row(
                  children: [
                    Text(
                      "Joined as intern: ",
                      style: StyleText.fontSize11Weight400.copyWith(
                        fontSize: 10.sp,
                        color: AppColors.secondaryText,
                      ),
                    ),

                    Text(
                      data.joinDateLabel,
                      style: StyleText.fontSize11Weight400.copyWith(
                        fontSize: 10.sp,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  _t('What Have I Learned', 'ماذا تعلمت', isRtl),
                  style: StyleText.fontSize13Weight600.copyWith(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  data.whatHaveILearned,
                  style: StyleText.fontSize12Weight600.copyWith(
                    fontSize: 10.sp,
                    height: 1.6,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MOBILE TAB: OUR TEAM  (Firebase data via OurTeamItem)
// ═══════════════════════════════════════════════════════════════════════════════
