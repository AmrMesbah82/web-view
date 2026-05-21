part of '../pages/about_us_page.dart';

class _ValuesGridTablet extends StatefulWidget {
  final List<AboutValueItem> values;
  final bool isRtl;
  final Color primaryColor, secondaryColor;
  const _ValuesGridTablet({
    required this.values,
    this.isRtl = false,
    required this.primaryColor,
    required this.secondaryColor,
  });
  @override
  State<_ValuesGridTablet> createState() => _ValuesGridTabletState();
}

class _ValuesGridTabletState extends State<_ValuesGridTablet> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.values.isEmpty)
      return Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            'No values added yet.',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12.sp,
              color: Colors.grey[500],
            ),
          ),
        ),
      );
    final int idx = _selectedIndex.clamp(0, widget.values.length - 1);
    final selected = widget.values[idx];
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: widget.secondaryColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(widget.values.length, (i) {
                final v = widget.values[i];
                final sel = i == idx;
                return _ValueGridCard(
                  title: _ab(v.title, widget.isRtl),
                  iconUrl: v.iconUrl,
                  isSelected: sel,
                  primaryColor: widget.primaryColor,
                  width: 88.w,
                  iconSize: 18.sp,
                  fontSize: 8.sp,
                  padding: 9.r,
                  onTap: () => setState(() => _selectedIndex = i),
                );
              }),
            ),
          ),
          SizedBox(height: 12.h),
          _ValueDetailPanel(
            value: selected,
            isRtl: widget.isRtl,
            primaryColor: widget.primaryColor,
            secondaryColor: widget.secondaryColor,
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// MOBILE BODY
// ══════════════════════════════════════════════════════════════════════════════
