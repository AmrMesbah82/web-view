part of '../pages/about_us_page.dart';

class _MobileDocPanel extends StatelessWidget {
  final String description, svgUrl, attachEnUrl, attachArUrl, labelEn, labelAr;
  final Color primaryColor;
  const _MobileDocPanel({
    required this.description,
    required this.svgUrl,
    required this.attachEnUrl,
    required this.attachArUrl,
    required this.labelEn,
    required this.labelAr,
    required this.primaryColor,
  });

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
                assetPath: "assets/download.svg",
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
            if (svgUrl.isNotEmpty) ...[
              Center(
                child: _netImg(
                  url: svgUrl,
                  width: double.infinity,
                  height: 200.h,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 14.h),
            ],
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: _kSurface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                description,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.secondaryBlack,
                  height: 1.75,
                ),
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
