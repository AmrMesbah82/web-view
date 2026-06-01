part of '../pages/careers_page.dart';

class _MobileBody extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChange;
  final Color primary;
  final Color secondary;
  final bool isRtl;
  final CareersCmsModel careersData;
  final List<CareersSectionItem> whyJoinItems;
  final List<InternModel> interns;
  final List<OurTeamItem> teams;

  const _MobileBody({
    required this.selectedTab,
    required this.onTabChange,
    required this.primary,
    required this.secondary,
    required this.isRtl,
    required this.careersData,
    required this.whyJoinItems,
    required this.interns,
    required this.teams,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 22.h),
          _Reveal(
            delay: const Duration(milliseconds: 60),
            direction: _SlideDirection.fromLeft,
            duration: const Duration(milliseconds: 650),
            child: Text(
              _t('Careers', 'الوظائف', isRtl),
              style: StyleText.fontSize28Weight600.copyWith(
                fontSize: 28.sp,
                color: primary,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          _Reveal(
            delay: const Duration(milliseconds: 100),
            direction: _SlideDirection.fromBottom,
            duration: const Duration(milliseconds: 650),
            child: _MobileHeaderCard(
              primary: primary,
              isRtl: isRtl,
              description: isRtl
                  ? careersData.overview.description.ar
                  : careersData.overview.description.en,
              btnLabel: isRtl
                  ? careersData.overview.actionButtonLabel.ar
                  : careersData.overview.actionButtonLabel.en,
            ),
          ),
          SizedBox(height: 16.h),
          _Reveal(
            delay: const Duration(milliseconds: 140),
            direction: _SlideDirection.fromBottom,
            duration: const Duration(milliseconds: 650),
            child: _MobileStatsSection(
              primary: primary,
              isRtl: isRtl,
              statistics: careersData.statistics,
            ),
          ),
          SizedBox(height: 20.h),
          _Reveal(
            delay: const Duration(milliseconds: 170),
            direction: _SlideDirection.fromBottom,
            duration: const Duration(milliseconds: 600),
            child: _MobileTabBar(
              selectedTab: selectedTab,
              onTabChange: onTabChange,
              primary: primary,
              secondary: secondary,
              isRtl: isRtl,
            ),
          ),
          SizedBox(height: 16.h),
          _buildMobileTabContent(
              selectedTab, primary, secondary, isRtl),
          SizedBox(height: 28.h),
        ],
      ),
    );
  }

  Widget _buildMobileTabContent(
      int tab,
      Color primary,
      Color secondary,
      bool isRtl,
      ) {
    switch (tab) {
      case 0:
        return _MobileWhyJoinTab(
            primary: primary, isRtl: isRtl, items: whyJoinItems);
      case 1:
        return _MobileInternsTab(
            primary: primary, isRtl: isRtl, interns: interns);
      case 2:
        return _MobileOurTeamTab(
            primary: primary,
            secondary: secondary,
            isRtl: isRtl,
            teams: teams);
      default:
        return _MobileWhyJoinTab(
            primary: primary, isRtl: isRtl, items: whyJoinItems);
    }
  }
}

// ── Mobile header card ────────────────────────────────────────────────────────
