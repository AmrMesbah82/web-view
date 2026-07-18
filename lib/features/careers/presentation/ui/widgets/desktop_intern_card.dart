part of '../pages/careers_page.dart';

class _DesktopInternCard extends StatelessWidget {
  final InternModel data;
  final double width;
  final Color primary;
  final bool isTablet;
  final bool isRtl;
  const _DesktopInternCard({
    required this.data,
    required this.width,
    required this.primary,
    this.isTablet = false,
    required this.isRtl,
  });

  @override
  Widget build(BuildContext context) {
    final double avatarSz = isTablet ? 70.w : 84.w;
    final double leftColW = isTablet ? 110.w : 130.w;
    final double nameFz = isTablet ? 11.sp : 13.sp;
    final double degFz = isTablet ? 9.sp : 10.sp;
    final double joinFz = isTablet ? 9.sp : 10.sp;
    final double titleFz = isTablet ? 12.sp : 14.sp;
    final double bodyFz = isTablet ? 10.sp : 12.sp;
    final double cardPad = isTablet ? 14.w : 18.w;

    return SizedBox(
      width: width,
      child: Container(
        padding: EdgeInsets.all(cardPad),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: leftColW,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: avatarSz,
                    height: avatarSz,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                      Border.all(color: primary, width: 1.5),
                    ),
                    child: ClipOval(
                      child: data.photoUrl.isNotEmpty
                          ? Image.network(
                        data.photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Image.asset(
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
                  SizedBox(height: 8.h),
                  Text(
                    data.fullName,
                    textAlign: TextAlign.center,
                    style: StyleText.fontSize14Weight700.copyWith(
                      fontSize: nameFz,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    data.degrees,
                    textAlign: TextAlign.center,
                    style: StyleText.fontSize11Weight600.copyWith(
                      fontSize: degFz,
                      color: Colors.black45,
                      height: 1.4,
                    ),
                  ),
                  // ── Position ─────────────────────────────────────────
                  if (data.position.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        data.position,
                        textAlign: TextAlign.center,
                        style: StyleText.fontSize13Weight600.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 5.w,
                    runSpacing: 3.h,
                    alignment: WrapAlignment.center,
                    children: data.tags
                        .map(
                          (tag) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius:
                          BorderRadius.circular(5.r),
                        ),
                        child: Text(
                          tag,
                          style:
                          StyleText.fontSize11Weight600.copyWith(
                            fontSize: degFz,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ],
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [

                      Text(
                        _t('Joined as Intern: ', 'انضم كمتدرب: ', isRtl),
                        style: StyleText.fontSize12Weight600.copyWith(
                          fontSize: joinFz,
                          color: AppColors.secondaryText,
                        ),
                      ),

                      Text(
                        data.joinDateLabelFor(isRtl),
                        style: StyleText.fontSize11Weight600.copyWith(
                          fontSize: joinFz,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    _t('What Have I Learned', 'ماذا تعلمت', isRtl),
                    style: StyleText.fontSize16Weight700.copyWith(
                      fontSize: titleFz,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    data.whatHaveILearned,
                    style: StyleText.fontSize14Weight600.copyWith(
                      fontSize: bodyFz,
                      height: 1.6,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DESKTOP TAB: OUR TEAM  (Firebase data via OurTeamItem)
// ═══════════════════════════════════════════════════════════════════════════════
