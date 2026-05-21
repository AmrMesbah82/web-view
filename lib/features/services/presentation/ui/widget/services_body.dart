part of '../pages/services_page.dart';

class _ServicesBody extends StatelessWidget {
  final ServicePageModel    model;
  final List<BlogPostModel> blogs;
  final bool                isRtl;
  final Color               primaryColor;
  final Color               secondaryColor;
  const _ServicesBody({
    required this.model,
    required this.blogs,
    required this.isRtl,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    if (w >= _BP.tablet)
      return _ServicesBodyDesktop(
          model:          model,
          blogs:          blogs,
          isRtl:          isRtl,
          primaryColor:   primaryColor,
          secondaryColor: secondaryColor);
    if (w >= _BP.mobile)
      return _ServicesBodyTablet(
          model:          model,
          blogs:          blogs,
          isRtl:          isRtl,
          primaryColor:   primaryColor,
          secondaryColor: secondaryColor);
    return _ServicesBodyMobile(
        model:          model,
        blogs:          blogs,
        isRtl:          isRtl,
        primaryColor:   primaryColor,
        secondaryColor: secondaryColor);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DESKTOP BODY
// ═══════════════════════════════════════════════════════════════════════════════
