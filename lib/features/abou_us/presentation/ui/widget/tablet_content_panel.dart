part of '../pages/about_us_page.dart';

class _TabletContentPanel extends StatelessWidget {
  final AboutPageModel model;
  final int tabIndex;
  final bool isRtl;
  final Color primaryColor, secondaryColor;
  const _TabletContentPanel({
    required this.model,
    required this.tabIndex,
    required this.isRtl,
    required this.primaryColor,
    required this.secondaryColor,
  });
  @override
  Widget build(BuildContext context) {
    if (tabIndex == 2) {
      final otherValues = model.values.length > 1
          ? model.values.sublist(1)
          : <AboutValueItem>[];
      return _ValuesGridTablet(
        values: otherValues,
        isRtl: isRtl,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
      );
    }
    if (tabIndex == 1) {
      return BlocBuilder<StrategyCubit, StrategyState>(
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
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: _kSurface,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: _netImg(
                          url: svgUrl,
                          width: 250.w,
                          height: 250.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  SizedBox(height: 20.h),
                  if (strategicHouseUrl.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isRtl ? 'البيت الاستراتيجي' : 'Strategic House',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(14.r),
                          decoration: BoxDecoration(
                            color: _kSurface,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: _netImg(
                              url: strategicHouseUrl,
                              width: double.infinity,
                              height: 250.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (svgUrl.isEmpty && strategicHouseUrl.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: _kSurface,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text(
                          isRtl ? 'لا يوجد محتوى بعد' : 'No content yet',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13.sp,
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
      );
    }
    final AboutSection section = tabIndex == 0 ? model.vision : model.mission;
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.svgUrl.isNotEmpty) ...[
            Center(
              child: _netImg(
                url: section.svgUrl,
                width: 160.w,
                height: 160.h,
                fit: BoxFit.contain,
                borderRadius: BorderRadius.circular(10.r),
                // ✅ FIX: no colorFilter
              ),
            ),
            SizedBox(height: 12.h),
          ],
          Text(
            _ab(section.description, isRtl),
            style: StyleText.fontSize14Weight400.copyWith(
              fontSize: 11.sp,
              height: 1.75,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// VALUES GRID — TABLET
// ══════════════════════════════════════════════════════════════════════════════
