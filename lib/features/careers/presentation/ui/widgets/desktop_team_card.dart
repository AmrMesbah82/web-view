part of '../pages/careers_page.dart';

class _DesktopTeamCard extends StatefulWidget {
  final OurTeamItem data;
  final double width;
  final Color primary;
  final Color secondary;
  final bool isTablet;
  final bool isRtl;

  const _DesktopTeamCard({
    required this.data,
    required this.width,
    required this.primary,
    required this.secondary,
    this.isTablet = false,
    required this.isRtl,
  });

  @override
  State<_DesktopTeamCard> createState() => _DesktopTeamCardState();
}

class _DesktopTeamCardState extends State<_DesktopTeamCard> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final double iconBoxSz = widget.isTablet ? 60.w : 72.w;
    final double iconSz = widget.isTablet ? 30.w : 36.w;
    final double nameFz = widget.isTablet ? 10.sp : 11.sp;
    final double descFz = widget.isTablet ? 9.sp : 10.sp;
    final double cardPad = widget.isTablet ? 14.w : 18.w;

    final String name =
    widget.isRtl ? widget.data.title.ar : widget.data.title.en;
    final String desc = widget.isRtl
        ? widget.data.description.ar
        : widget.data.description.en;
    final List<String> deliverables = widget.data.deliverableItems
        .map((d) => widget.isRtl ? d.label.ar : d.label.en)
        .where((s) => s.isNotEmpty)
        .toList();

    return SizedBox(
      width: widget.width,
      child: Container(
        padding: EdgeInsets.all(cardPad),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Icon: network SVG ──────────────────────────────────────
            Container(
              width: iconBoxSz,
              height: iconBoxSz,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: widget.secondary,
              ),
              child: Center(
                child: widget.data.iconUrl.isNotEmpty
                    ? SvgPicture.network(
                  widget.data.iconUrl,
                  width: iconSz,
                  height: iconSz,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                      widget.primary, BlendMode.srcIn),
                  placeholderBuilder: (_) =>
                      SizedBox(width: iconSz, height: iconSz),
                )
                    : SizedBox(width: iconSz, height: iconSz),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 12.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: widget.primary,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: StyleText.fontSize12Weight600.copyWith(
                  fontSize: nameFz,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    desc,
                    textAlign: TextAlign.center,
                    style: StyleText.fontSize12Weight600.copyWith(
                      fontSize: descFz,
                      height: 1.6,
                      color:
                      AppColors.secondaryText.withOpacity(.7),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _DesktopDeliverableButtons(
                    deliverables: deliverables,
                    primary: widget.primary,
                    isRtl: widget.isRtl,
                    fontSize: descFz,
                    selectedIndex: _selectedIndex,
                    onSelectIndex: (index) => setState(() {
                      _selectedIndex =
                      _selectedIndex == index ? null : index;
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
