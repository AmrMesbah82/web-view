part of '../pages/careers_page.dart';

class _MobileTabBar extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChange;
  final Color primary;
  final Color secondary;
  final bool isRtl;
  const _MobileTabBar({
    required this.selectedTab,
    required this.onTabChange,
    required this.primary,
    required this.secondary,
    required this.isRtl,
  });

  @override
  Widget build(BuildContext context) {
    final double boxSize = 48.w;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final bool selected = selectedTab == i;
          return GestureDetector(
            onTap: () => onTabChange(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected ? primary : Colors.transparent,
                    width: 2.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: boxSize,
                    height: boxSize,
                    decoration: BoxDecoration(
                      color: selected ? primary : secondary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        _tabs[i].icon,
                        width: 26.sp,
                        height: 26.sp,
                        colorFilter: ColorFilter.mode(
                          selected ? Colors.white : primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    _tabs[i].label(isRtl),
                    style: StyleText.fontSize13Weight400.copyWith(
                      fontSize: 16.sp,
                      fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? primary : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MOBILE TAB: WHY JOIN OUR TEAM  (Firebase data via CareersSectionItem)
// ═══════════════════════════════════════════════════════════════════════════════
