part of '../pages/about_us_page.dart';

class _AboutBodyMobile extends StatefulWidget {
  final AboutPageModel model;
  final bool isRtl;
  final Color primaryColor, secondaryColor;
  final int? initialTopTab, initialSubTab;
  final VoidCallback? onTabApplied;
  const _AboutBodyMobile({
    required this.model,
    required this.isRtl,
    required this.primaryColor,
    required this.secondaryColor,
    this.initialTopTab,
    this.initialSubTab,
    this.onTabApplied,
  });
  @override
  State<_AboutBodyMobile> createState() => _AboutBodyMobileState();
}

class _AboutBodyMobileState extends State<_AboutBodyMobile> {
  late int _selectedTopTab;
  @override
  void initState() {
    super.initState();
    _selectedTopTab = widget.initialTopTab ?? 0;
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => widget.onTabApplied?.call(),
    );
  }

  final List<BiText> _topTabs = [
    BiText(ar: 'من نحن', en: 'About Us'),
    BiText(ar: 'استراتيجيتنا', en: 'Our Strategy'),
    BiText(ar: 'الشروط والأحكام', en: 'Terms and Conditions'),
    BiText(ar: 'سياسة الخصوصية', en: 'Privacy Policy'),
  ];
  final List<String> _svgAssets = [
    'assets/images/about_us/about_us.svg',
    'assets/images/about_us/Our Strategy.svg',
    'assets/images/about_us/Terms and Conditions.svg',
    'assets/images/about_us/Privacy Policy.svg',
  ];

  @override
  Widget build(BuildContext context) {
    final TermsOfServiceModel termsModel =
    context.read<TermsCubit>().state is TermsLoaded
        ? (context.read<TermsCubit>().state as TermsLoaded).data
        : context.read<TermsCubit>().state is TermsSaved
        ? (context.read<TermsCubit>().state as TermsSaved).data
        : TermsOfServiceModel.empty();
    final TermsSection terms = termsModel.termsAndConditions,
        privacy = termsModel.privacyPolicy;
    // App logo (same source as the main/home branding) for the doc top row.
    final String logoUrl =
        context.read<HomeCmsCubit>().current.branding.logoUrl;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: BlocBuilder<StrategyCubit, StrategyState>(
              builder: (context, strategyState) {
                // CMS navigation-label icons (set in the admin app)
                final String strategyIconUrl = switch (strategyState) {
                  StrategyLoaded(:final data) => data.navigationLabel.iconUrl,
                  StrategySaved(:final data) => data.navigationLabel.iconUrl,
                  _ => '',
                };
                return Row(
                  children: List.generate(_topTabs.length, (i) {
                    final String cmsIconUrl = switch (i) {
                      0 => widget.model.navigationLabel.iconUrl,
                      1 => strategyIconUrl,
                      2 => terms.iconUrl.isNotEmpty
                          ? terms.iconUrl
                          : termsModel.navigationLabel.iconUrl,
                      _ => privacy.iconUrl.isNotEmpty
                          ? privacy.iconUrl
                          : termsModel.navigationLabel.iconUrl,
                    };
                    final String cmsLabel = switch (i) {
                      2 => widget.isRtl ? terms.title.ar : terms.title.en,
                      3 => widget.isRtl ? privacy.title.ar : privacy.title.en,
                      _ => '',
                    };
                    return _MobileTopTabItem(
                      index: i,
                      label: cmsLabel.isNotEmpty
                          ? cmsLabel
                          : (widget.isRtl
                              ? (_topTabs[i].ar.isNotEmpty
                                  ? _topTabs[i].ar
                                  : _topTabs[i].en)
                              : _topTabs[i].en),
                      svgAsset: _svgAssets[i],
                      iconUrl: cmsIconUrl,
                      isSelected: i == _selectedTopTab,
                      primaryColor: widget.primaryColor,
                      secondaryColor: widget.secondaryColor,
                      onTap: () => setState(() => _selectedTopTab = i),
                    );
                  }),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),

          if (_selectedTopTab == 0)
            _Reveal(
              key: const ValueKey('mob_top_0'),
              delay: const Duration(milliseconds: 100),
              direction: _SlideDirection.fromBottom,
              child: _MobileAboutUsContent(
                model: widget.model,
                isRtl: widget.isRtl,
                primaryColor: widget.primaryColor,
                secondaryColor: widget.secondaryColor,
                initialExpanded: widget.initialSubTab,
              ),
            ),

          if (_selectedTopTab == 1)
            _Reveal(
              key: const ValueKey('mob_top_1'),
              delay: const Duration(milliseconds: 100),
              direction: _SlideDirection.fromBottom,
              child: BlocBuilder<StrategyCubit, StrategyState>(
                builder: (context, strategyState) {
                  final String svgUrl = switch (strategyState) {
                    StrategyLoaded(:final data) => data.vision.svgUrl,
                    StrategySaved(:final data) => data.vision.svgUrl,
                    _ => '',
                  };
                  // Mobile layout → mobile image, falling back to desktop
                  final String strategicHouseEnUrl = switch (strategyState) {
                    StrategyLoaded(:final data) => data.strategicHouseEnMobileUrl.isNotEmpty
                        ? data.strategicHouseEnMobileUrl
                        : data.strategicHouseEnDesktopUrl,
                    StrategySaved(:final data) => data.strategicHouseEnMobileUrl.isNotEmpty
                        ? data.strategicHouseEnMobileUrl
                        : data.strategicHouseEnDesktopUrl,
                    _ => '',
                  };
                  final String strategicHouseArUrl = switch (strategyState) {
                    StrategyLoaded(:final data) => data.strategicHouseArMobileUrl.isNotEmpty
                        ? data.strategicHouseArMobileUrl
                        : data.strategicHouseArDesktopUrl,
                    StrategySaved(:final data) => data.strategicHouseArMobileUrl.isNotEmpty
                        ? data.strategicHouseArMobileUrl
                        : data.strategicHouseArDesktopUrl,
                    _ => '',
                  };
                  return BlocBuilder<LanguageCubit, LanguageState>(
                    builder: (context, langState) {
                      final bool isRtl = langState.isArabic;
                      final String strategicHouseUrl =
                      isRtl ? strategicHouseArUrl : strategicHouseEnUrl;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (svgUrl.isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: _kSurface,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: _netImg(
                                  url: svgUrl,
                                  width: double.infinity,
                                  height: 180.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          SizedBox(height: 16.h),
                          if (strategicHouseUrl.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isRtl ? 'البيت الاستراتيجي' : 'Strategic House',
                                  style: StyleText.fontSize14Weight700.copyWith(
                                    color: widget.primaryColor,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12.r),
                               
                                  child: Center(
                                    child: _netImg(
                                      url: strategicHouseUrl,
                                      width: double.infinity,
                                      height: 180.h,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (svgUrl.isEmpty && strategicHouseUrl.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: _kSurface,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: Text(
                                  isRtl ? 'لا يوجد محتوى بعد' : 'No content yet',
                                  style: StyleText.fontSize12Weight400.copyWith(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

          if (_selectedTopTab == 2)
            _Reveal(
              key: const ValueKey('mob_top_2'),
              delay: const Duration(milliseconds: 100),
              direction: _SlideDirection.fromBottom,
              child: _MobileDocPanel(
                description: _ab(terms.description, widget.isRtl),
                lastUpdated: termsModel.lastUpdatedAt,
                logoUrl: logoUrl,
                attachEnUrl: terms.attachEnUrl,
                attachArUrl: terms.attachArUrl,
                labelEn: _downloadDocLabel(
                  isRtl: widget.isRtl,
                  titleEn: _kTermsTitleEn,
                  titleAr: _kTermsTitleAr,
                  isArabicFile: false,
                ),
                labelAr: _downloadDocLabel(
                  isRtl: widget.isRtl,
                  titleEn: _kTermsTitleEn,
                  titleAr: _kTermsTitleAr,
                  isArabicFile: true,
                ),
                primaryColor: widget.primaryColor,
              ),
            ),
          if (_selectedTopTab == 3)
            _Reveal(
              key: const ValueKey('mob_top_3'),
              delay: const Duration(milliseconds: 100),
              direction: _SlideDirection.fromBottom,
              child: _MobileDocPanel(
                description: _ab(privacy.description, widget.isRtl),
                lastUpdated: termsModel.lastUpdatedAt,
                logoUrl: logoUrl,
                attachEnUrl: privacy.attachEnUrl,
                attachArUrl: privacy.attachArUrl,
                labelEn: _downloadDocLabel(
                  isRtl: widget.isRtl,
                  titleEn: _kPrivacyTitleEn,
                  titleAr: _kPrivacyTitleAr,
                  isArabicFile: false,
                ),
                labelAr: _downloadDocLabel(
                  isRtl: widget.isRtl,
                  titleEn: _kPrivacyTitleEn,
                  titleAr: _kPrivacyTitleAr,
                  isArabicFile: true,
                ),
                primaryColor: widget.primaryColor,
              ),
            ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Mobile Top Tab Item
// ══════════════════════════════════════════════════════════════════════════════
