part of '../pages/contact_us_page.dart';

class _SocialIconRaw extends StatelessWidget {
  final String? svgPath, iconUrl, link;
  final Color   primaryColor;
  const _SocialIconRaw(
      {this.svgPath,
        this.iconUrl,
        this.link,
        required this.primaryColor});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: (link?.isNotEmpty ?? false)
        ? () async {
      String raw = link!.trim();
      if (!raw.startsWith('http://') &&
          !raw.startsWith('https://')) {
        raw = 'https://$raw';
      }
      final uri = Uri.tryParse(raw);
      if (uri == null || !uri.hasAuthority) return;
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri,
            mode: LaunchMode.externalApplication,
            webOnlyWindowName: '_blank');
      }
    }
        : null,
    child: MouseRegion(
      cursor: (link?.isNotEmpty ?? false)
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      child: Container(
        width: 40.w, height: 40.w,
        decoration: BoxDecoration(
            border:       Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(7.r)),
        child: Center(
          child: iconUrl != null && iconUrl!.isNotEmpty
              ?SvgPicture.network(iconUrl!,
              width:  20.w,
              height: 20.w,
              fit:    BoxFit.contain,
              headers: const {'Cache-Control': 'no-cache'},
              colorFilter: ColorFilter.mode(
                  primaryColor, BlendMode.srcIn))
              : SvgPicture.asset(
              svgPath ?? 'assets/images/instegrm.svg',
              width:  20.w,
              height: 20.w,
              fit:    BoxFit.contain,
              colorFilter: ColorFilter.mode(
                  primaryColor, BlendMode.srcIn)),
        ),
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// SUCCESS DIALOG
// ═══════════════════════════════════════════════════════════════════════════════
