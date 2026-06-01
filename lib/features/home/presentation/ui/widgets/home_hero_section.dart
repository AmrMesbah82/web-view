part of '../pages/home_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Hero Section
// ─────────────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final HomePageModel data;
  final Color         bgColor;
  const _HeroSection({required this.data, required this.bgColor});

  Color get _primary =>
      _hexColor(data.branding.primaryColor, fallback: _kDefaultPrimary);

  @override
  Widget build(BuildContext context) {
    final double w       = MediaQuery.of(context).size.width;
    final bool   isMobile = w < _BP.mobile;
    final isAr            = context.read<LanguageCubit>().state.isArabic;

    final String titleText = data.title.l(context);
    final String descText  = data.shortDescription.l(context);

    final TextStyle titleStyle = GoogleFonts.cairo(
      fontSize:      isMobile ? 28.sp : 48.sp,
      fontWeight:    AppFontWeights.bold,
      color:         _primary,
      letterSpacing: isAr ? 0.0 : -0.5,
      height:        isAr ? 1.2 : 1.1,
    );

    final TextStyle descStyle = GoogleFonts.cairo(
      fontSize:      isMobile ? 12.sp : 20.sp,
      fontWeight:    AppFontWeights.regular,
      color:         _primary,
      letterSpacing: isAr ? 0.0 : 0.5,
    );

    return Container(
      color:  bgColor,
      width:  w,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20.w : 36.w,
        vertical:   isMobile ? 20.h : 44.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints:
            BoxConstraints(maxWidth: w - (isMobile ? 40.w : 72.w)),
            child: Text(
              titleText,
              textAlign:     TextAlign.center,
              textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
              style:         titleStyle,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: 1000.w,
            child: Text(
              descText,
              textAlign:     TextAlign.center,
              textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
              style:         descStyle,
            ),
          ),
        ],
      ),
    );
  }
}
