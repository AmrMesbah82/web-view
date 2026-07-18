part of '../pages/about_us_page.dart';

class _AboutPageView extends StatefulWidget {
  const _AboutPageView();
  @override
  State<_AboutPageView> createState() => _AboutPageViewState();
}

class _AboutPageViewState extends State<_AboutPageView> {
  bool _showLoader = true, _preloadStarted = false;
  int? _initialTopTab, _initialSubTab;
  bool _tabParamApplied = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 12), () {
      if (mounted && _showLoader) setState(() => _showLoader = false);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCmsCubit>().load();
      _readTabParam();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _readTabParam();
  }

  void _readTabParam() {
    if (!mounted) return;
    final uri = GoRouterState.of(context).uri;
    final tabParam = uri.queryParameters['tab'];
    if (tabParam != null && tabParam.isNotEmpty) {
      final resolved = _resolveTabParam(tabParam);
      if (_initialTopTab != resolved.topTab ||
          _initialSubTab != resolved.subTab) {
        setState(() {
          _initialTopTab = resolved.topTab;
          _initialSubTab = resolved.subTab;
          _tabParamApplied = false;
        });
      }
    }
  }

  Future<void> _preloadAndReveal({
    required String logoUrl,
    required AboutPageModel model,
  }) async {
    if (_preloadStarted) return;
    _preloadStarted = true;
    final urls = [
      if (logoUrl.isNotEmpty) logoUrl,
      if (model.vision.iconUrl.isNotEmpty) model.vision.iconUrl,
      if (model.vision.svgUrl.isNotEmpty) model.vision.svgUrl,
      if (model.mission.iconUrl.isNotEmpty) model.mission.iconUrl,
      if (model.mission.svgUrl.isNotEmpty) model.mission.svgUrl,
      for (final v in model.values)
        if (v.iconUrl.isNotEmpty) v.iconUrl,
    ];
    await _preloadImages(urls)
        .timeout(const Duration(milliseconds: 700), onTimeout: () {});
    if (mounted) setState(() => _showLoader = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCmsCubit, HomeCmsState>(
      builder: (context, homeState) {
        final String logoUrl = switch (homeState) {
          HomeCmsLoaded(:final data) => data.branding.logoUrl,
          HomeCmsSaved(:final data) => data.branding.logoUrl,
          _ => context.read<HomeCmsCubit>().current.branding.logoUrl,
        };
        final Color primaryColor = switch (homeState) {
          HomeCmsLoaded(:final data) => _parseColor(
            data.branding.primaryColor,
            fallback: _kDefaultGreen,
          ),
          HomeCmsSaved(:final data) => _parseColor(
            data.branding.primaryColor,
            fallback: _kDefaultGreen,
          ),
          _ => _kDefaultGreen,
        };
        final Color secondaryColor = switch (homeState) {
          HomeCmsLoaded(:final data) => _parseColor(
            data.branding.secondaryColor,
            fallback: _kGreenLight,
          ),
          HomeCmsSaved(:final data) => _parseColor(
            data.branding.secondaryColor,
            fallback: _kGreenLight,
          ),
          _ => _kGreenLight,
        };
        final Color backgroundColor = switch (homeState) {
          HomeCmsLoaded(:final data) => _parseColor(
            data.branding.backgroundColor,
            fallback: AppColors.background,
          ),
          HomeCmsSaved(:final data) => _parseColor(
            data.branding.backgroundColor,
            fallback: AppColors.background,
          ),
          _ => AppColors.background,
        };
        final bool homeReady =
            homeState is HomeCmsLoaded || homeState is HomeCmsSaved;

        if (homeState is HomeCmsError &&
            homeState.lastData == null &&
            _showLoader) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _showLoader = false);
          });
        }

        return BlocBuilder<AboutCubit, AboutState>(
          builder: (context, state) {
            final AboutPageModel? model = switch (state) {
              AboutLoaded() => state.data,
              AboutSaved() => state.data,
              _ => null,
            };
            final bool aboutReady = model != null,
                isError = state is AboutError,
                allReady = homeReady && aboutReady;
            if (allReady && !_preloadStarted)
              _preloadAndReveal(logoUrl: logoUrl, model: model!);
            if (isError && !aboutReady)
              return Scaffold(
                backgroundColor: backgroundColor,
                body: Center(
                  child: Text(
                    'Failed to load: ${(state as AboutError).message}',
                    style: StyleText.fontSize14Weight400.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            final Color loaderBg = switch (homeState) {
              HomeCmsLoaded(:final data) => _parseColor(
                data.branding.backgroundColor,
                fallback: AppColors.background,
              ),
              HomeCmsSaved(:final data) => _parseColor(
                data.branding.backgroundColor,
                fallback: AppColors.background,
              ),
              _ => _kLoaderNeutral,
            };
            if (_showLoader || !allReady)
              return _SvgPulseLoader(
                logoUrl: logoUrl.isEmpty ? null : logoUrl,
                backgroundColor: loaderBg,
              );

            return BlocBuilder<TermsCubit, TermsState>(
              builder: (context, termsState) {
                final TermsOfServiceModel termsModel = switch (termsState) {
                  TermsLoaded(:final data) => data,
                  TermsSaved(:final data) => data,
                  _ => TermsOfServiceModel.empty(),
                };
                return BlocBuilder<LanguageCubit, LanguageState>(
                  builder: (context, langState) {
                    final bool isRtl = langState.isArabic;
                    final double w = MediaQuery.of(context).size.width;
                    return Directionality(
                      textDirection: isRtl
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Scaffold(
                        backgroundColor: backgroundColor,
                        body: _RevealCoordinatorWidget(
                          child: Column(
                            children: [
                              Material(
                                color: backgroundColor,
                                elevation: 0,
                                child: AppNavbar(currentRoute: '/about'),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      _Reveal(
                                        delay: const Duration(milliseconds: 80),
                                        direction: _SlideDirection.fromLeft,
                                        duration: const Duration(milliseconds: 650),
                                        child: w < _BP.mobile
                                            ? _AboutHeaderMobile(
                                          model: model!,
                                          isRtl: isRtl,
                                          primaryColor: primaryColor,
                                        )
                                            : _AboutHeaderDesktop(
                                          model: model!,
                                          isRtl: isRtl,
                                          primaryColor: primaryColor,
                                        ),
                                      ),
                                      w < _BP.mobile
                                          ? _AboutBodyMobile(
                                        model: model!,
                                        isRtl: isRtl,
                                        primaryColor: primaryColor,
                                        secondaryColor: secondaryColor,
                                        initialTopTab: _tabParamApplied ? null : _initialTopTab,
                                        initialSubTab: _tabParamApplied ? null : _initialSubTab,
                                        onTabApplied: () => _tabParamApplied = true,
                                      )
                                          : _AboutBodyDesktop(
                                        model: model!,
                                        termsModel: termsModel,
                                        isRtl: isRtl,
                                        primaryColor: primaryColor,
                                        secondaryColor: secondaryColor,
                                        initialTopTab: _tabParamApplied ? null : _initialTopTab,
                                        initialSubTab: _tabParamApplied ? null : _initialSubTab,
                                        onTabApplied: () => _tabParamApplied = true,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              _Reveal(
                                delay: const Duration(milliseconds: 100),
                                direction: _SlideDirection.fromBottom,
                                duration: const Duration(milliseconds: 600),
                                child: const AppFooter(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Headers
// ══════════════════════════════════════════════════════════════════════════════
