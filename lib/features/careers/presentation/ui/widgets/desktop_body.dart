part of '../pages/careers_page.dart';

class _DesktopBody extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChange;
  final Color primary;
  final Color secondary;
  final bool isRtl;
  final CareersCmsModel careersData;
  final List<CareersSectionItem> whyJoinItems;
  final List<InternModel> interns;
  final List<OurTeamItem> teams;
  final String internsIconUrl;
  final String internsTitle;
  final String teamIconUrl;
  final String teamTitle;

  const _DesktopBody({
    required this.selectedTab,
    required this.onTabChange,
    required this.primary,
    required this.secondary,
    required this.isRtl,
    required this.careersData,
    required this.whyJoinItems,
    required this.interns,
    required this.teams,
    this.internsIconUrl = '',
    this.internsTitle = '',
    this.teamIconUrl = '',
    this.teamTitle = '',
  });

  @override
  Widget build(BuildContext context) {
    final double screenW = MediaQuery.of(context).size.width;
    final bool isTablet = screenW < _BP.tablet;
    final double hPad =
    isTablet ? _tabletHPad() : _desktopHPad(screenW);

    final double topSpace = isTablet ? 28.h : 36.h;
    final double titleFz = isTablet ? 30.sp : 40.sp;
    final double sectionGap = isTablet ? 18.h : 24.h;
    final double bottomSpace = isTablet ? 40.h : 56.h;
    final double cardPad = isTablet ? 18.w : 24.w;
    final double headerFz = isTablet ? 12.sp : 14.sp;
    final double plainFz = isTablet ? 11.sp : 13.sp;
    final double statValFz = isTablet ? 20.sp : 24.sp;
    final double statDescFz = isTablet ? 9.sp : 10.sp;
    final double tabFz = isTablet ? 11.sp : 13.sp;
    final double tabIconSz = isTablet ? 16.sp : 18.sp;
    final double tabIconBox = isTablet ? 32.w : 36.w;

    final String overviewDesc = isRtl
        ? careersData.overview.description.ar
        : careersData.overview.description.en;
    final String btnLabel = isRtl
        ? careersData.overview.actionButtonLabel.ar
        : careersData.overview.actionButtonLabel.en;
    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: topSpace),

          _Reveal(
            delay: const Duration(milliseconds: 60),
            direction: _SlideDirection.fromLeft,
            duration: const Duration(milliseconds: 650),
            child: Text(
              _t('Careers', 'الوظائف', isRtl),
              style: StyleText.fontSize45Weight600.copyWith(
                fontSize: titleFz,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
          ),
          SizedBox(height: sectionGap),

          _Reveal(
            delay: const Duration(milliseconds: 110),
            direction: _SlideDirection.fromBottom,
            duration: const Duration(milliseconds: 650),
            child: Container(
              padding: EdgeInsets.only(
                left: 10.sp,
                right: 10.sp,
                top: 5.sp,
                bottom: 10.sp,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (overviewDesc.isNotEmpty)
                    _PlainText(overviewDesc, fontSize: plainFz),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      if (btnLabel.isNotEmpty)
                        _ApplyNowBtnDesktop(
                          label: btnLabel,
                          primary: primary,
                          isTablet: isTablet,
                          isRtl: isRtl,
                        ),
                      // const Spacer(),
                      // customButton(
                      //   title: isArabic ? "قدم الان " : "apply now",
                      //   color: primary,
                      //   textStyle: StyleText.fontSize28Weight600.copyWith(
                      //     fontSize: 14.sp,
                      //     fontWeight: FontWeight.w600,
                      //     color: Colors.white,
                      //   ),
                      //   function: () {
                      //     navigateTo(context, JobListingsPage());
                      //   },
                      //   width: 100.w,
                      //   height: 36.h,
                      //   radius: 8.r,
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: sectionGap),

          if (careersData.statistics.isNotEmpty)
            _Reveal(
              delay: const Duration(milliseconds: 150),
              direction: _SlideDirection.fromBottom,
              duration: const Duration(milliseconds: 650),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: cardPad,
                  vertical: isTablet ? 14.h : 18.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Column(
                  children: () {
                    const int maxPerRow = 5;
                    final stats = careersData.statistics;
                    final List<Widget> rows = [];
                    for (int i = 0; i < stats.length; i += maxPerRow) {
                      final chunk = stats.sublist(
                        i, (i + maxPerRow).clamp(0, stats.length),
                      );
                      rows.add(
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: chunk.map((s) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isRtl ? s.title.ar : s.title.en,
                                    maxLines: 1,
                                    style: StyleText.fontSize28Weight600.copyWith(
                                      fontSize: statValFz,
                                      fontWeight: FontWeight.w700,
                                      color: primary,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    isRtl ? s.shortDescription.ar : s.shortDescription.en,
                                    style: StyleText.fontSize10Weight400.copyWith(
                                      fontSize: statDescFz,
                                      height: 1.5,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )).toList(),
                        ),
                      );
                      if (i + maxPerRow < stats.length) {
                        rows.add(SizedBox(height: 16.h));
                      }
                    }
                    return rows;
                  }(),
                ),
              ),
            ),
          SizedBox(height: sectionGap),

          // ── Tab Bar ────────────────────────────────────────────────────
          _Reveal(
            delay: const Duration(milliseconds: 180),
            direction: _SlideDirection.fromBottom,
            duration: const Duration(milliseconds: 600),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_tabs.length, (i) {
                final bool selected = selectedTab == i;
                // Admin-controlled icon/label overrides:
                //   tab 0 → "Why Join Our Team" section item 0
                //   tab 1 → "Our Interns" section header
                final String tabIconUrl = switch (i) {
                  0 => whyJoinItems.isNotEmpty
                      ? whyJoinItems.first.iconUrl
                      : '',
                  1 => internsIconUrl,
                  2 => teamIconUrl,
                  _ => '',
                };
                final String tabLabelOverride = switch (i) {
                  0 => whyJoinItems.isNotEmpty
                      ? (isRtl
                          ? whyJoinItems.first.title.ar
                          : whyJoinItems.first.title.en)
                      : '',
                  1 => internsTitle,
                  2 => teamTitle,
                  _ => '',
                };
                return GestureDetector(
                  onTap: () => onTabChange(i),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin:
                      EdgeInsets.symmetric(horizontal: 6.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: selected
                                ? primary
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration:
                            const Duration(milliseconds: 200),
                            width: tabIconBox,
                            height: tabIconBox,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(8.r),
                              color: selected ? primary : secondary,
                            ),
                            child: Center(
                              child: tabIconUrl.isNotEmpty
                                  ? SvgPicture.network(
                                      tabIconUrl,
                                      width: tabIconSz,
                                      height: tabIconSz,
                                      fit: BoxFit.scaleDown,
                                      colorFilter: ColorFilter.mode(
                                        selected ? Colors.white : primary,
                                        BlendMode.srcIn,
                                      ),
                                      placeholderBuilder: (_) => SizedBox(
                                          width: tabIconSz,
                                          height: tabIconSz),
                                    )
                                  : SvgPicture.asset(
                                      _tabs[i].icon,
                                      width: tabIconSz,
                                      height: tabIconSz,
                                      fit: BoxFit.scaleDown,
                                      colorFilter: ColorFilter.mode(
                                        selected ? Colors.white : primary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            tabLabelOverride.isNotEmpty
                                ? tabLabelOverride
                                : _tabs[i].label(isRtl),
                            style:
                            StyleText.fontSize14Weight400.copyWith(
                              fontSize: tabFz,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: selected
                                  ? primary
                                  : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: sectionGap),

          _buildDesktopTabContent(
              selectedTab, primary, secondary, isTablet, isRtl),

          SizedBox(height: bottomSpace),
        ],
      ),
    );
  }

  Widget _buildDesktopTabContent(
      int tab,
      Color primary,
      Color secondary,
      bool isTablet,
      bool isRtl,
      ) {
    switch (tab) {
      case 0:
        return _DesktopWhyJoinTab(
          primary: primary,
          isTablet: isTablet,
          isRtl: isRtl,
          items: whyJoinItems,
        );
      case 1:
        return _DesktopInternsTab(
          primary: primary,
          isTablet: isTablet,
          isRtl: isRtl,
          interns: interns,
        );
      case 2:
        return _DesktopOurTeamTab(
          primary: primary,
          secondary: secondary,
          isTablet: isTablet,
          isRtl: isRtl,
          teams: teams,
        );
      default:
        return _DesktopWhyJoinTab(
          primary: primary,
          isTablet: isTablet,
          isRtl: isRtl,
          items: whyJoinItems,
        );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DESKTOP TAB: WHY JOIN OUR TEAM  (Firebase data via CareersSectionItem)
// ═══════════════════════════════════════════════════════════════════════════════
