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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_topTabs.length, (i) {
                return _MobileTopTabItem(
                  label: widget.isRtl
                      ? (_topTabs[i].ar.isNotEmpty
                      ? _topTabs[i].ar
                      : _topTabs[i].en)
                      : _topTabs[i].en,
                  svgAsset: _svgAssets[i],
                  isSelected: i == _selectedTopTab,
                  primaryColor: widget.primaryColor,
                  secondaryColor: widget.secondaryColor,
                  onTap: () => setState(() => _selectedTopTab = i),
                );
              }),
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
                  final String strategicHouseEnUrl = switch (strategyState) {
                    StrategyLoaded(:final data) => data.strategicHouseEnUrl,
                    StrategySaved(:final data) => data.strategicHouseEnUrl,
                    _ => '',
                  };
                  final String strategicHouseArUrl = switch (strategyState) {
                    StrategyLoaded(:final data) => data.strategicHouseArUrl,
                    StrategySaved(:final data) => data.strategicHouseArUrl,
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
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: widget.primaryColor,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12.r),
                                  decoration: BoxDecoration(
                                    color: _kSurface,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
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
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12.sp,
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
                svgUrl: terms.svgUrl,
                attachEnUrl: terms.attachEnUrl,
                attachArUrl: terms.attachArUrl,
                labelEn: 'Download PDF of Terms and Conditions (ENG)',
                labelAr: 'Download PDF of Terms and Conditions (ARB)',
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
                svgUrl: privacy.svgUrl,
                attachEnUrl: privacy.attachEnUrl,
                attachArUrl: privacy.attachArUrl,
                labelEn: 'Download PDF of Privacy Policy (ENG)',
                labelAr: 'Download PDF of Privacy Policy (ARB)',
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
