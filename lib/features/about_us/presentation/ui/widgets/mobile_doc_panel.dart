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

  ({String label, String value}) _lastUpdatedParts(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return (
      label: _lastUpdatedPrefix(isRtl),
      value: _formatAboutDate(lastUpdated, isRtl),
    );
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
                  // StyleText already resolves the admin-selected EN/AR font,
                  // so no hardcoded fontFamily here.
                  style: StyleText.fontSize14Weight400.copyWith(
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
              decoration: BoxDecoration(
                color: _kSurface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top row: app logo (start) + last updated (end) ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (logoUrl.isNotEmpty)
                        _netImg(
                          url: logoUrl,
                          width: 34.w,
                          height: 34.h,
                          fit: BoxFit.contain,
                        ),
                      const Spacer(),
                      Builder(builder: (context) {
                        final p = _lastUpdatedParts(context);
                        return RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: p.label,
                              style: StyleText.fontSize10Weight400.copyWith(
                                  color: AppColors.secondaryText),
                            ),
                            TextSpan(
                              text: p.value,
                              style: StyleText.fontSize10Weight400.copyWith(
                                  color: AppColors.text),
                            ),
                          ]),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    description,
                    style: StyleText.fontSize11Weight400.copyWith(
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
