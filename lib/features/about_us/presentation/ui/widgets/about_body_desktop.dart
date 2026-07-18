part of '../pages/about_us_page.dart';

class _AboutBodyDesktop extends StatefulWidget {
  final AboutPageModel model;
  final TermsOfServiceModel termsModel;
  final bool isRtl;
  final Color primaryColor, secondaryColor;
  final int? initialTopTab, initialSubTab;
  final VoidCallback? onTabApplied;
  const _AboutBodyDesktop({
    required this.model,
    required this.termsModel,
    required this.isRtl,
    required this.primaryColor,
    required this.secondaryColor,
    this.initialTopTab,
    this.initialSubTab,
    this.onTabApplied,
  });
  @override
  State<_AboutBodyDesktop> createState() => _AboutBodyDesktopState();
}

class _AboutBodyDesktopState extends State<_AboutBodyDesktop> {
  late int _selectedTab, _selectedTopTab;

  @override
  void initState() {
    super.initState();
    _selectedTopTab = widget.initialTopTab ?? 0;
    _selectedTab = widget.initialSubTab ?? 0;
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => widget.onTabApplied?.call(),
    );
  }

  String _tabLabel(int i) => switch (i) {
    0 => widget.isRtl ? 'الرؤية' : 'Vision',
    1 => widget.isRtl ? 'الرسالة' : 'Mission',
    _ => widget.isRtl ? 'القيم' : 'Values',
  };

  String _tabIconUrl(int i) => switch (i) {
    0 => widget.model.vision.iconUrl,
    1 => widget.model.mission.iconUrl,
    _ =>
    widget.model.values.isNotEmpty ? widget.model.values.first.iconUrl : '',
  };

  // ✅ FIX: Left panel shows icon+label ONLY for all 3 tabs.
  // Right panel shows the full description — no extra height in left panel.
  String _tabDesc(int i) => switch (i) {
    0 => _ab(widget.model.vision.subDescription, widget.isRtl),
    1 => _ab(widget.model.mission.subDescription, widget.isRtl),
    _ => _ab(widget.model.mission.subDescription, widget.isRtl),
  };

  Widget _downloadButton(String label, String url) {
    if (url.isEmpty) return const SizedBox.shrink();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => html.window.open(url, '_blank'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomSvg(
              assetPath: "assets/download 1.svg",
              width: 12.h,
              height: 16.h,
              fit: BoxFit.scaleDown,
              color: widget.primaryColor,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: StyleText.fontSize12Weight500.copyWith(
                fontFamily: 'Cairo',
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: widget.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bilingual "Last Updated" label for the Terms / Privacy top row.
  String _lastUpdatedLabel(DateTime? d) {
    if (d == null) return widget.isRtl ? 'آخر تحديث: —' : 'Last Updated: —';
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final String ds = '${d.day} ${months[d.month]} ${d.year}';
    return widget.isRtl ? 'آخر تحديث: $ds' : 'Last Updated: $ds';
  }

  Widget _docPanel({
    required String description,
    required DateTime? lastUpdated,
    required String logoUrl,
    required String attachEnUrl,
    required String attachArUrl,
    required String labelEn,
    required String labelAr,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: app logo (start) + last updated (end) ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (logoUrl.isNotEmpty)
                    _netImg(
                      url: logoUrl,
                      width: 44.w,
                      height: 44.h,
                      fit: BoxFit.contain,
                    ),
                  const Spacer(),
                  Text(
                    _lastUpdatedLabel(lastUpdated),
                    style: StyleText.fontSize14Weight400.copyWith(
                      fontSize: 12.sp,
                      color: widget.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                description,
                style: StyleText.fontSize14Weight400.copyWith(
                  fontSize: 13.sp,
                  height: 1.75,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _downloadButton(labelEn, attachEnUrl),
            _downloadButton(labelAr, attachArUrl),
          ],
        ),
      ],
    );
  }

  final List<BiText> _topTabs = [
    BiText(ar: 'من نحن', en: 'About Us'),
    BiText(ar: 'استراتيجيتنا', en: 'Our Strategy'),
    BiText(ar: 'الشروط والأحكام', en: 'Terms and Conditions'),
    BiText(ar: 'سياسة الخصوصية', en: 'Privacy Policy'),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenW = MediaQuery.of(context).size.width,
        contentW = _desktopContentWidth(context);
    final double hPad = ((screenW - contentW) / 2).clamp(36.0, double.infinity),
        gap = 16.w,
        leftW = 280.w;
    final TermsSection terms = widget.termsModel.termsAndConditions,
        privacy = widget.termsModel.privacyPolicy;
    // App logo (same source as the main/home branding) for the doc top row.
    final String logoUrl =
        context.read<HomeCmsCubit>().current.branding.logoUrl;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Tab Bar ──
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: BlocBuilder<StrategyCubit, StrategyState>(
              builder: (context, strategyState) {
                // CMS navigation-label icons (set in the admin app)
                final String strategyIconUrl = switch (strategyState) {
                  StrategyLoaded(:final data) => data.navigationLabel.iconUrl,
                  StrategySaved(:final data) => data.navigationLabel.iconUrl,
                  _ => '',
                };
                // CMS navigation-label title for the Strategy tab.
                final String strategyTitleEn = switch (strategyState) {
                  StrategyLoaded(:final data) => data.navigationLabel.title.en,
                  StrategySaved(:final data) => data.navigationLabel.title.en,
                  _ => '',
                };
                final String strategyTitleAr = switch (strategyState) {
                  StrategyLoaded(:final data) => data.navigationLabel.title.ar,
                  StrategySaved(:final data) => data.navigationLabel.title.ar,
                  _ => '',
                };
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_topTabs.length, (i) {
                    final bool isRtl =
                        context.read<LanguageCubit>().state.isArabic;
                    // CMS titles for Terms (tab 2) / Privacy (tab 3).
                    final String cmsLabel = switch (i) {
                      0 => isRtl
                          ? widget.model.navigationLabel.title.ar
                          : widget.model.navigationLabel.title.en,
                      1 => isRtl ? strategyTitleAr : strategyTitleEn,
                      2 => isRtl ? terms.title.ar : terms.title.en,
                      _ => isRtl ? privacy.title.ar : privacy.title.en,
                    };
                    final String label = cmsLabel.isNotEmpty
                        ? cmsLabel
                        : (isRtl
                            ? (_topTabs[i].ar.isNotEmpty
                                ? _topTabs[i].ar
                                : _topTabs[i].en)
                            : _topTabs[i].en);
                    final String svgAsset = switch (i) {
                      0 => 'assets/images/about_us/about_us.svg',
                      1 => 'assets/images/about_us/Our Strategy.svg',
                      2 => 'assets/images/about_us/Terms and Conditions.svg',
                      _ => 'assets/images/about_us/Privacy Policy.svg',
                    };
                    final String cmsIconUrl = switch (i) {
                      0 => widget.model.navigationLabel.iconUrl,
                      1 => strategyIconUrl,
                      2 => terms.iconUrl.isNotEmpty
                          ? terms.iconUrl
                          : widget.termsModel.navigationLabel.iconUrl,
                      _ => privacy.iconUrl.isNotEmpty
                          ? privacy.iconUrl
                          : widget.termsModel.navigationLabel.iconUrl,
                    };
                    return _DesktopTopTabItem(
                      index: i,
                      label: label,
                      svgAsset: svgAsset,
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

          // ── Tab 0: About Us ──
          if (_selectedTopTab == 0)
            _Reveal(
              key: const ValueKey('top_0'),
              delay: const Duration(milliseconds: 100),
              direction: _SlideDirection.fromBottom,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: leftW,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(3, (i) {
                          final bool isLast = i == 2;
                          return _Reveal(
                            key: ValueKey('top_0_tab_$i'),
                            delay: Duration(milliseconds: 120 + i * 80),
                            direction: _SlideDirection.fromLeft,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
                              child: _DesktopTabItem(
                                label: _tabLabel(i),
                                iconUrl: _tabIconUrl(i),
                                // ✅ FIX: Values tab passes '' so no extra
                                // description block renders in the left panel
                                selectedDesc: _selectedTab == i ? _tabDesc(i) : '',
                                isSelected: _selectedTab == i,
                                primaryColor: widget.primaryColor,
                                secondaryColor: widget.secondaryColor,
                                onTap: () => setState(() => _selectedTab = i),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(width: gap),
                    Expanded(
                      child: _Reveal(
                        key: const ValueKey('top_0_right'),
                        delay: const Duration(milliseconds: 180),
                        direction: _SlideDirection.fromRight,
                        child: _DesktopRightPanel(
                          model: widget.model,
                          tabIndex: _selectedTab,
                          isRtl: widget.isRtl,
                          primaryColor: widget.primaryColor,
                          secondaryColor: widget.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Tab 1: Our Strategy ──
          if (_selectedTopTab == 1)
            _Reveal(
              key: const ValueKey('top_1'),
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
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: _kSurface,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: _netImg(
                                  url: svgUrl,
                                  width: 300.w,
                                  height: 300.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          SizedBox(height: 24.h),
                          if (strategicHouseUrl.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isRtl ? 'البيت الاستراتيجي' : 'Strategic House',
                                  style: StyleText.fontSize14Weight400.copyWith(
                                    fontFamily: 'Cairo',
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: widget.primaryColor,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Center(
                                    child: _netImg(
                                      url: strategicHouseUrl,
                                      width: double.infinity,
                                      height: 640.h,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (svgUrl.isEmpty && strategicHouseUrl.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: _kSurface,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: Text(
                                  isRtl ? 'لا يوجد محتوى بعد' : 'No content yet',
                                  style: StyleText.fontSize14Weight400.copyWith(
                                    fontFamily: 'Cairo',
                                    fontSize: 14.sp,
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

          // ── Tab 2: Terms ──
          if (_selectedTopTab == 2)
            _Reveal(
              key: const ValueKey('top_2'),
              delay: const Duration(milliseconds: 100),
              direction: _SlideDirection.fromBottom,
              child: _docPanel(
                description: _ab(terms.description, widget.isRtl),
                lastUpdated: widget.termsModel.lastUpdatedAt,
                logoUrl: logoUrl,
                attachEnUrl: terms.attachEnUrl,
                attachArUrl: terms.attachArUrl,
                labelEn: 'Download PDF of Terms and Conditions (ENG)',
                labelAr: 'Download PDF of Terms and Conditions (ARB)',
              ),
            ),

          // ── Tab 3: Privacy ──
          if (_selectedTopTab == 3)
            _Reveal(
              key: const ValueKey('top_3'),
              delay: const Duration(milliseconds: 100),
              direction: _SlideDirection.fromBottom,
              child: _docPanel(
                description: _ab(privacy.description, widget.isRtl),
                lastUpdated: widget.termsModel.lastUpdatedAt,
                logoUrl: logoUrl,
                attachEnUrl: privacy.attachEnUrl,
                attachArUrl: privacy.attachArUrl,
                labelEn: 'Download PDF of Privacy Policy (ENG)',
                labelAr: 'Download PDF of Privacy Policy (ARB)',
              ),
            ),

          SizedBox(height: 36.h),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Desktop Top Tab Item
// ══════════════════════════════════════════════════════════════════════════════
