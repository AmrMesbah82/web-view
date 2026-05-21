part of '../pages/home_page.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// ✅ COMING SOON PLACEHOLDER — shown when page is draft or future-scheduled
// ═══════════════════════════════════════════════════════════════════════════════

class _ComingSoonPage extends StatelessWidget {
  final HomePageModel data;
  final GlobalKey      navbarKey;

  const _ComingSoonPage({
    required this.data,
    required this.navbarKey,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary = _hexColor(
      data.branding.primaryColor,
      fallback: _kDefaultPrimary,
    );
    final Color bgColor = _hexColor(
      data.branding.backgroundColor,
      fallback: _kDefaultBackground,
    );
    final isAr = context.read<LanguageCubit>().state.isArabic;

    // ✅ Build scheduled date text if applicable
    String? scheduledText;
    if (data.publishStatus == 'scheduled' && data.scheduledPublishDate != null) {
      final d = data.scheduledPublishDate!;
      final months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      scheduledText = isAr
          ? 'سيتم النشر في ${d.day}/${d.month}/${d.year}'
          : 'Launching on ${months[d.month]} ${d.day}, ${d.year}';
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            // ✅ Main content — centered "Coming Soon"
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  if (data.branding.logoUrl.isNotEmpty) ...[
                    SvgPicture.network(
                      data.branding.logoUrl,
                      width:  80.w,
                      height: 80.w,
                      fit:    BoxFit.contain,
                      colorFilter: ColorFilter.mode(primary, BlendMode.srcIn),
                      placeholderBuilder: (_) =>
                          SizedBox(width: 80.w, height: 80.w),
                    ),
                    SizedBox(height: 24.h),
                  ],

                  // Title
                  Text(
                    isAr ? 'قريباً' : 'Coming Soon',
                    style: GoogleFonts.cairo(
                      fontSize:   36.sp,
                      fontWeight: FontWeight.w700,
                      color:      primary,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Subtitle
                  Text(
                    isAr
                        ? 'نحن نعمل على شيء مميز. ترقبوا!'
                        : 'We\'re working on something great. Stay tuned!',
                    style: GoogleFonts.cairo(
                      fontSize:   16.sp,
                      fontWeight: FontWeight.w400,
                      color:      primary.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Scheduled date
                  if (scheduledText != null) ...[
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical:   10.h,
                      ),
                      decoration: BoxDecoration(
                        color:        primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: primary.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        scheduledText,
                        style: GoogleFonts.cairo(
                          fontSize:   14.sp,
                          fontWeight: FontWeight.w500,
                          color:      primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ✅ Navbar stays on top
            Positioned(
              top:   0,
              left:  0,
              right: 0,
              child: Material(
                color:     Colors.transparent,
                elevation: 0,
                child: AppNavbar(
                  key:          navbarKey,
                  currentRoute: '/',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
