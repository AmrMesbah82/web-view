part of '../pages/about_us_page.dart';

class _ValuesGridMobile extends StatefulWidget {
  final List<AboutValueItem> values;
  final bool isRtl;
  final Color primaryColor, secondaryColor;
  const _ValuesGridMobile({
    required this.values,
    this.isRtl = false,
    required this.primaryColor,
    required this.secondaryColor,
  });
  @override
  State<_ValuesGridMobile> createState() => _ValuesGridMobileState();
}

class _ValuesGridMobileState extends State<_ValuesGridMobile> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.values.isEmpty)
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Center(
          child: CustomSvg(assetPath: "assets/null.svg")
        ),
      );
    final double innerW =
        MediaQuery.of(context).size.width - 16.w * 2 - 12.w * 2,
        gap = 7.w,
        cardW = (innerW - gap) / 2;
    final int idx = _selectedIndex.clamp(0, widget.values.length - 1);
    final selected = widget.values[idx];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: gap,
          runSpacing: gap,
          children: List.generate(widget.values.length, (i) {
            final v = widget.values[i];
            final sel = i == idx;
            return _ValueGridCard(
              title: _ab(v.title, widget.isRtl),
              iconUrl: v.iconUrl,
              isSelected: sel,
              primaryColor: widget.primaryColor,
              width: cardW,
              iconSize: 16.sp,
              fontSize: 10.sp,
              padding: 9.r,
              rowLayout: true,
              onTap: () => setState(() => _selectedIndex = i),
            );
          }),
        ),
        SizedBox(height: 10.h),
        _ValueDetailPanel(
          value: selected,
          isRtl: widget.isRtl,
          primaryColor: widget.primaryColor,
          secondaryColor: widget.secondaryColor,
        ),
      ],
    );
  }
}
