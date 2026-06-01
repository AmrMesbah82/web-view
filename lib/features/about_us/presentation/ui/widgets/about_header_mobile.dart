part of '../pages/about_us_page.dart';

class _AboutHeaderMobile extends StatelessWidget {
  final AboutPageModel model;
  final bool isRtl;
  final Color primaryColor;
  const _AboutHeaderMobile({
    required this.model,
    required this.isRtl,
    required this.primaryColor,
  });
  @override
  Widget build(BuildContext context) {
    final String title = _ab(model.title, isRtl).isNotEmpty
        ? _ab(model.title, isRtl)
        : (isRtl ? 'من نحن' : 'About Us');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Text(
        title,
        style: StyleText.fontSize45Weight600.copyWith(
          fontSize: 28.sp,
          fontWeight: FontWeight.w900,
          color: primaryColor,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// DESKTOP BODY
// ══════════════════════════════════════════════════════════════════════════════
