part of '../pages/about_us_page.dart';

class _ValueGridCard extends StatefulWidget {
  final String title;
  final String iconUrl;
  final bool isSelected;
  final Color primaryColor;
  final double width;
  final double iconSize;
  final double fontSize;
  final double padding;
  final VoidCallback onTap;
  final bool rowLayout;
  const _ValueGridCard({
    required this.title,
    required this.iconUrl,
    required this.isSelected,
    required this.primaryColor,
    required this.width,
    required this.iconSize,
    required this.fontSize,
    required this.padding,
    required this.onTap,
    this.rowLayout = false,
  });
  @override
  State<_ValueGridCard> createState() => _ValueGridCardState();
}

class _ValueGridCardState extends State<_ValueGridCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool sel = widget.isSelected;
    final Color hoverBg = _hoverTint(widget.primaryColor);

    // ✅ FIX: only apply white colorFilter when the card is selected
    // so the real icon image is visible on non-selected cards
    final Widget iconWidget = widget.iconUrl.isNotEmpty
        ? _netImg(
      url: widget.iconUrl,
      width: widget.iconSize,
      height: widget.iconSize,
      fit: BoxFit.contain,
      colorFilter: (sel && _isSvgUrl(widget.iconUrl))
          ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
          : null,
    )
        : Icon(
      Icons.star_outline,
      size: widget.iconSize,
      color: sel ? Colors.white : widget.primaryColor,
    );

    final Widget titleWidget = Text(
      widget.title,
      textAlign: widget.rowLayout ? TextAlign.start : TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: 'Cairo',
        fontSize: widget.fontSize,
        fontWeight: FontWeight.w600,
        color: sel
            ? Colors.white
            : (_hovered ? widget.primaryColor : Colors.black87),
        height: 1,
      ),
    );

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.rowLayout ? null : widget.width,
          height: widget.rowLayout ? null : 90.r,
          padding: EdgeInsets.all(widget.padding),
          decoration: BoxDecoration(
            color: sel
                ? widget.primaryColor
                : (_hovered ? hoverBg : Colors.white),
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: sel
                ? [
              BoxShadow(
                color: widget.primaryColor.withOpacity(0.28),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
            border: Border.all(
              color: _hovered && !sel
                  ? widget.primaryColor.withOpacity(0.3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: widget.rowLayout
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconWidget,
              SizedBox(width: 6.w),
              Expanded(child: titleWidget),
            ],
          )
              : Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconWidget,
              SizedBox(height: 6.h),
              titleWidget,
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Tablet Tab Item
// ══════════════════════════════════════════════════════════════════════════════
