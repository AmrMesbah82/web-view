part of '../pages/home_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Body
// ─────────────────────────────────────────────────────────────────────────────

class _HomeBody extends StatelessWidget {
  final HomePageModel data;
  final bool          isRtl;
  final double        navbarHeight;
  final GlobalKey     navbarKey;

  const _HomeBody({
    required this.data,
    required this.isRtl,
    required this.navbarHeight,
    required this.navbarKey,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = _hexColor(
      data.branding.backgroundColor,
      fallback: _kDefaultBackground,
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bgColor,
        body: _RevealCoordinatorWidget(
          child: Column(
            children: [
              // ✅ Navbar — always visible at top
              AppNavbar(
                key:          navbarKey,
                currentRoute: '/',
              ),

              // ✅ Middle content — scrolls, takes all remaining space
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Reveal(
                        delay:     const Duration(milliseconds: 80),
                        direction: _SlideDirection.fromLeft,
                        duration:  const Duration(milliseconds: 650),
                        child: _HeroSection(data: data, bgColor: bgColor),
                      ),
                      _Reveal(
                        delay:     const Duration(milliseconds: 200),
                        direction: _SlideDirection.fromBottom,
                        duration:  const Duration(milliseconds: 700),
                        child: _HeroCardsSection(data: data, bgColor: bgColor),
                      ),
                    ],
                  ),
                ),
              ),

              // ✅ Footer — always visible at bottom
              _Reveal(
                delay:     const Duration(milliseconds: 100),
                direction: _SlideDirection.fromBottom,
                duration:  const Duration(milliseconds: 600),
                child: const AppFooter(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
