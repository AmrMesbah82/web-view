part of '../pages/about_us_page.dart';

class _MobileDocPanel extends StatelessWidget {
  final String description, attachEnUrl, attachArUrl, labelEn, labelAr, logoUrl;
  final DateTime? lastUpdated;
  final Color primaryColor;
  const _MobileDocPanel({
    required this.description,
    required this.lastUpdated,
    required this.logoUrl,
    required this.attachEnUrl,
    required this.attachArUrl,
    required this.labelEn,
    required this.labelAr,
    required this.primaryColor,
  });

  String _lastUpdatedLabel(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    if (lastUpdated == null) return isRtl ? 'آخر تحديث: —' : 'Last Updated: —';
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final d = lastUpdated!;
    final ds = '${d.day} ${months[d.month]} ${d.year}';
    return isRtl ? 'آخر تحديث: $ds' : 'Last Updated: $ds';
  }

  Widget _downloadBtn(String label, String url) {
    if (url.isEmpty) return const SizedBox.shrink();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => html.window.open(url, '_blank'),
        child: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomSvg(
                assetPath: "assets/download 1.svg",
                width: 18.w,
                height: 18.h,
                fit: BoxFit.scaleDown,
                color: primaryColor,
              ),
              SizedBox(width: 5.w),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: _kSurface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top row: app logo (start) + last updated (end) ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (logoUrl.isNotEmpty)
                        _netImg(
                          url: logoUrl,
                          width: 34.w,
                          height: 34.h,
                          fit: BoxFit.contain,
                        ),
                      const Spacer(),
                      Text(
                        _lastUpdatedLabel(context),
                        style: StyleText.fontSize10Weight400.copyWith(
                          color: primaryColor
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryBlack,
                      height: 1.75,
                    ),
                  ),
                ],
              ),
            ),
            _downloadBtn(labelEn, attachEnUrl),
            _downloadBtn(labelAr, attachArUrl),
          ],
        ),
      ),
    );
  }
}
