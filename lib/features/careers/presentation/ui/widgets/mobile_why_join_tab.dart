part of '../pages/careers_page.dart';

class _MobileWhyJoinTab extends StatelessWidget {
  final Color primary;
  final bool isRtl;
  final List<CareersSectionItem> items;
  const _MobileWhyJoinTab(
      {required this.primary, required this.isRtl, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      children: List.generate(items.length, (i) {
        final item = items[i];
        final String text =
        isRtl ? item.description.ar : item.description.en;
        final String svgUrl = item.svgUrl;

        return _Reveal(
          delay: Duration(milliseconds: 60 + i * 80),
          direction:
          i.isEven ? _SlideDirection.fromLeft : _SlideDirection.fromRight,
          duration: const Duration(milliseconds: 650),
          child: Padding(
            padding: EdgeInsets.only(bottom: 24.h),
            child: Column(
              children: [
                // ── SVG from Firebase (network) or fallback ────────────────
                if (svgUrl.isNotEmpty)
                  SvgPicture.network(
                    svgUrl,
                    width: 160.w,
                    height: 140.h,
                    fit: BoxFit.contain,
                    placeholderBuilder: (_) =>
                        SizedBox(width: 160.w, height: 140.h),
                  )
                else
                  SizedBox(width: 160.w, height: 140.h),
                SizedBox(height: 12.h),
                if (text.isNotEmpty)
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: StyleText.fontSize15Weight400.copyWith(
                      fontSize: 11.sp,
                      height: 1.7,
                      color: Colors.black45,
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MOBILE TAB: OUR INTERNS  (Firebase data via InternModel)
// ═══════════════════════════════════════════════════════════════════════════════
