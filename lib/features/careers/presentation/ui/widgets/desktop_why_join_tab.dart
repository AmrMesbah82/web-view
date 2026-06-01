part of '../pages/careers_page.dart';

class _DesktopWhyJoinTab extends StatelessWidget {
  final Color primary;
  final bool isTablet;
  final bool isRtl;
  final List<CareersSectionItem> items;
  const _DesktopWhyJoinTab({
    required this.primary,
    this.isTablet = false,
    required this.isRtl,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final double svgW = isTablet ? 160.w : 200.w;
    final double svgH = isTablet ? 140.h : 170.h;
    final double gap = isTablet ? 20.w : 28.w;
    final double textFz = isTablet ? 13.sp : 15.sp;
    final double rowGap = isTablet ? 18.h : 22.h;

    return Column(
      children: List.generate(items.length, (i) {
        final item = items[i];
        final String text =
        isRtl ? item.description.ar : item.description.en;
        final String svgUrl = item.svgUrl;
        final imgLeft = i.isOdd;

        final Widget svgWidget = svgUrl.isNotEmpty
            ? SvgPicture.network(
          svgUrl,
          width: svgW,
          height: svgH,
          fit: BoxFit.contain,
          placeholderBuilder: (_) =>
              SizedBox(width: svgW, height: svgH),
        )
            : SizedBox(width: svgW, height: svgH);

        return _Reveal(
          delay: Duration(milliseconds: 60 + i * 80),
          direction: imgLeft
              ? _SlideDirection.fromRight
              : _SlideDirection.fromLeft,
          duration: const Duration(milliseconds: 700),
          child: Padding(
            padding: EdgeInsets.only(bottom: rowGap),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: imgLeft
                    ? [
                  SizedBox(
                    width: svgW,
                    child: Center(child: svgWidget),
                  ),
                  SizedBox(width: gap),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        text,
                        style:
                        StyleText.fontSize16Weight400.copyWith(
                          fontSize: textFz,
                          height: 1.7,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ]
                    : [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        text,
                        style:
                        StyleText.fontSize16Weight400.copyWith(
                          fontSize: textFz,
                          height: 1.7,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: gap),
                  SizedBox(
                    width: svgW,
                    child: Center(child: svgWidget),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DESKTOP TAB: OUR INTERNS  (Firebase data via InternModel)
// ═══════════════════════════════════════════════════════════════════════════════
