part of '../pages/about_us_page.dart';

class _ValuesGridDesktop extends StatefulWidget {
  final List<AboutValueItem> values;
  final bool isRtl;
  final Color primaryColor, secondaryColor;
  const _ValuesGridDesktop({
    required this.values,
    required this.primaryColor,
    required this.secondaryColor,
    this.isRtl = false,
  });
  @override
  State<_ValuesGridDesktop> createState() => _ValuesGridDesktopState();
}

class _ValuesGridDesktopState extends State<_ValuesGridDesktop> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.values.isEmpty)
      return Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            'No values added yet.',
            style: StyleText.fontSize14Weight400.copyWith(
              fontFamily: 'Cairo',
              fontSize: 13.sp,
              color: Colors.grey[500],
            ),
          ),
        ),
      );
    final int idx = _selectedIndex.clamp(0, widget.values.length - 1);
    final selected = widget.values[idx];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Green gradient cards container ──
        Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.primaryColor.withOpacity(.06),
                widget.primaryColor.withOpacity(.25),
                widget.primaryColor.withOpacity(.06),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.w,
            children: List.generate(widget.values.length, (i) {
              final v = widget.values[i];
              final sel = i == idx;
              return _ValueGridCard(
                title: _ab(v.title, widget.isRtl),
                iconUrl: v.iconUrl,
                isSelected: sel,
                primaryColor: widget.primaryColor,
                width: 100.w,
                iconSize: 22.sp,
                fontSize: 9.sp,
                padding: 10.r,
                onTap: () => setState(() => _selectedIndex = i),
              );
            }),
          ),
        ),
        // ── Detail panel OUTSIDE the green container ──
        SizedBox(height: 12.h),
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

// ══════════════════════════════════════════════════════════════════════════════
// Value Grid Card
// ══════════════════════════════════════════════════════════════════════════════
