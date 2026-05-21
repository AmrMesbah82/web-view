part of '../pages/home_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SHARED PRIMITIVE WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _CircleIcon extends StatelessWidget {
  final String iconUrl;
  final Color? iconColor;

  const _CircleIcon({
    required this.iconUrl,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w, height: 36.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ClipOval(
        child: _smartImage(
          url:         iconUrl,
          width:       18.w,
          height:      18.w,
          fit:         BoxFit.contain,
          colorFilter: iconColor,
          fallback:
          Icon(Icons.image_outlined, size: 16.sp, color: Colors.grey),
        ),
      ),
    );
  }
}

class _SocialIconBox extends StatelessWidget {
  final String iconUrl;
  final String url;
  final Color  primary;
  final double size;

  const _SocialIconBox({
    required this.iconUrl,
    required this.url,
    required this.primary,
    this.size = 32.0,
  });

  Future<void> _openUrl() async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: url.isNotEmpty ? _openUrl : null,
      child: Container(
        width: size.w, height: size.h,
        decoration: BoxDecoration(
            border:       Border.all(color: primary, width: 1.w),
            borderRadius: BorderRadius.circular(8.r)),
        child: Center(
          child: _smartImage(
            url:      iconUrl,
            width:    (size * 0.5).w,
            height:   (size * 0.5).h,
            fit:      BoxFit.contain,
            fallback: Icon(Icons.link,
                size: (size * 0.5).sp, color: primary),
          ),
        ),
      ),
    );
  }
}

class _SectionImage extends StatelessWidget {
  final String  imageUrl;
  final double? width;
  final double  height;
  final double? radius;

  const _SectionImage({
    required this.imageUrl,
    this.width,
    required this.height,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final r = radius ?? 12.r;

    if (imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          width: width, height: height,
          color: AppColors.card,
          alignment: Alignment.center,
          child: SvgPicture.network(
            imageUrl,
            width:  (width ?? double.infinity) * 0.75,
            height: height * 0.75,
            fit:    BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      width: width, height: height,
      decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(r)),
    );
  }
}

class _GreenCard extends StatelessWidget {
  final double? width;
  final double? height;
  final String  text;
  final Color   color;
  final double? fontSize;
  final bool    isRtl;

  const _GreenCard({
    this.width,
    this.height,
    required this.text,
    required this.color,
    this.fontSize,
    this.isRtl = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   width,
      height:  height,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color:        color,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        text,
        textAlign:     isRtl ? TextAlign.right : TextAlign.left,
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        style: GoogleFonts.cairo(
          fontSize:   fontSize ?? 12.sp,
          fontWeight: FontWeight.w400,
          color:      Colors.white,
          height:     1.4,
        ),
      ),
    );
  }
}
