part of '../pages/about_us_page.dart';

class _AboutHeaderDesktop extends StatelessWidget {
  final AboutPageModel model;
  final bool isRtl;
  final Color primaryColor;
  const _AboutHeaderDesktop({
    required this.model,
    required this.isRtl,
    required this.primaryColor,
  });
  @override
  Widget build(BuildContext context) {
    final double screenW = MediaQuery.of(context).size.width,
        contentW = _desktopContentWidth(context);
    final double hPad = ((screenW - contentW) / 2).clamp(36.0, double.infinity);
    final String title = _ab(model.title, isRtl).isNotEmpty
        ? _ab(model.title, isRtl)
        : (isRtl ? 'من نحن' : 'About Us');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 36.h),
      child: Text(
        title,
        style: StyleText.fontSize45Weight600.copyWith(
          fontSize: 48.sp,
          fontWeight: FontWeight.w700,
          color: primaryColor,
        ),
      ),
    );
  }
}
