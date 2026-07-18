part of '../pages/services_page.dart';

class _ServicesBodyMobile extends StatelessWidget {
  final ServicePageModel    model;
  final List<BlogPostModel> blogs;
  final bool                isRtl;
  final Color               primaryColor;
  final Color               secondaryColor;
  const _ServicesBodyMobile({
    required this.model,
    required this.blogs,
    required this.isRtl,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final String sectionTitle =
    _t(model.journeyTitle, isRtl).isNotEmpty
        ? _t(model.journeyTitle, isRtl)
        : (isRtl
        ? 'أسباب اختيار بيانتز لرحلتك الرقمية'
        : 'Reasons to Choose Bayanatz for Your Digital Journey');
    final String importantReads =
    isRtl ? 'قراءات مهمة' : 'Important Reads';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Reveal(
            delay:     const Duration(milliseconds: 80),
            direction: _SlideDirection.fromLeft,
            duration:  const Duration(milliseconds: 600),
            child: Text(FormatHelper.capitalize(sectionTitle),
                style: StyleText.fontSize14Weight700.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w800
                ))
          ),
          SizedBox(height: 14.h),

          ...model.journeyItems.asMap().entries.map((e) => _Reveal(
            delay:     Duration(milliseconds: 100 + e.key * 90),
            direction: _SlideDirection.fromBottom,
            duration:  const Duration(milliseconds: 650),
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _ServiceCardMobile(
                  item:           e.value,
                  isRtl:          isRtl,
                  primaryColor:   primaryColor,
                  secondaryColor: secondaryColor),
            ),
          )),
          SizedBox(height: 24.h),

          _Reveal(
            delay:     const Duration(milliseconds: 80),
            direction: _SlideDirection.fromLeft,
            duration:  const Duration(milliseconds: 600),
            child: Text(importantReads,
                style: StyleText.fontSize14Weight700.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w800
                ))
          ),
          SizedBox(height: 14.h),

          ...blogs.asMap().entries.map((e) => _Reveal(
            delay:     Duration(milliseconds: 100 + e.key * 120),
            direction: _SlideDirection.fromBottom,
            duration:  const Duration(milliseconds: 650),
            child: Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: _BlogCardMobile(
                  post:         e.value,
                  isRtl:        isRtl,
                  primaryColor: primaryColor),
            ),
          )),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

// ✅ FIX: colorFilter removed — SVG icons now render in their real colors
Widget _svgIconBox({
  required String url,
  required double size,
  required double radius,
  required Color  primaryColor,
  Color secondaryColor = _kGreenLight,
}) {
  return Container(
    width:  size,
    height: size,
    decoration: BoxDecoration(
        color:        secondaryColor,
        borderRadius: BorderRadius.circular(radius)),
    child: Center(
      child: url.isNotEmpty
          ? ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SvgPicture.network(
          url,
          width:  size * 0.6,
          height: size * 0.6,
          fit:    BoxFit.contain,
          // ✅ NO colorFilter — renders SVG in its original colors
          placeholderBuilder: (_) => SizedBox(
            width:  size * 0.5,
            height: size * 0.5,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color:       primaryColor,
            ),
          ),
        ),
      )
          : Icon(Icons.miscellaneous_services_outlined,
          size: size * 0.5, color: AppColors.textButton),
    ),
  );
}

Widget _svgBlogImage({
  required String url,
  required double width,
  required double height,
  required double radius,
  Color primaryColor = _kDefaultGreen,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: SizedBox(
      width:  width,
      height: height,
      child: url.isNotEmpty
          ? SvgPicture.network(
        url,
        width:  width,
        height: height,
        fit:    BoxFit.fill,
        placeholderBuilder: (_) => Container(
          color: _kGreenLight,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color:       primaryColor,
            ),
          ),
        ),
      )
          : Container(color: _kGreenLight),
    ),
  );
}

// ─── Service Card – Mobile / Tablet ──────────────────────────────────────────
