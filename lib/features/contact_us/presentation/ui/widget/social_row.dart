part of '../pages/contact_us_page.dart';

class _SocialRow extends StatelessWidget {
  final ContactUsCmsModel? cmsData;
  final bool  scaled;
  final Color primaryColor;
  const _SocialRow(
      {this.cmsData,
        required this.scaled,
        required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final rawIcons = (cmsData?.socialIcons ?? [])
        .where((i) => i.iconUrl.isNotEmpty || i.link.isNotEmpty)
        .toList();

    final icons = rawIcons;

    if (icons.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: icons
            .map((i) => Padding(
          padding: EdgeInsetsDirectional.only(end: 8.w),
          child: scaled
              ? _SocialIconScaled(
              iconUrl:      i.iconUrl,
              link:         i.link,
              primaryColor: primaryColor)
              : _SocialIconRaw(
              iconUrl:      i.iconUrl,
              link:         i.link,
              primaryColor: primaryColor),
        ))
            .toList(),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialIconRaw(
            svgPath: 'assets/images/instegrm.svg',
            primaryColor: primaryColor),
        SizedBox(width: 8.w),
        _SocialIconRaw(
            svgPath: 'assets/images/twitter.svg',
            primaryColor: primaryColor),
        SizedBox(width: 8.w),
        _SocialIconRaw(
            svgPath: 'assets/images/linkedin.svg',
            primaryColor: primaryColor),
      ],
    );
  }
}
