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
    // Use the LIVE model from the cubit (freshest merged branding) instead of
    // the `data` passed in at construction, which can be a stale snapshot whose
    // branding wasn't merged from the Main page yet. That staleness made the
    // hero title/cards fall back to the local default color instead of the
    // admin primary, even though the navbar (which reads the live cubit) was
    // already showing the correct admin colors.
    final homeState = context.watch<HomeCmsCubit>().state;
    final HomePageModel liveData = switch (homeState) {
      HomeCmsLoaded(:final data) => data,
      HomeCmsSaved(:final data)  => data,
      _                          => this.data,
    };
    final Color bgColor = _hexColor(
      liveData.branding.backgroundColor,
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
                        child: _HeroSection(data: liveData, bgColor: bgColor),
                      ),
                      _Reveal(
                        delay:     const Duration(milliseconds: 200),
                        direction: _SlideDirection.fromBottom,
                        duration:  const Duration(milliseconds: 700),
                        child: _HeroCardsSection(data: liveData, bgColor: bgColor),
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
