part of '../pages/blog_detail_Page.dart';

class _BlogNavButton extends StatefulWidget {
  final String       label;
  final bool         isSelected;
  final VoidCallback onTap;
  final bool         isMobile;
  final Color        primary;
  final Color        secondary;

  const _BlogNavButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isMobile,
    required this.primary,
    required this.secondary,
  });

  @override
  State<_BlogNavButton> createState() => _BlogNavButtonState();
}

class _BlogNavButtonState extends State<_BlogNavButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    // Derive a soft tinted hover background using Color.lerp instead of opacity
    final Color hoverBg = Color.lerp(Colors.white, widget.primary, 0.10)!;

    final Color bgColor = widget.isSelected
        ? widget.primary
        : (_hovered ? hoverBg : Colors.white);

    final Color textColor = widget.isSelected
        ? Colors.white
        : (_hovered ? widget.primary : AppColors.text);

    return MouseRegion(
      cursor:  SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: widget.isMobile
              ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
              : EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius:
            BorderRadius.circular(widget.isMobile ? 10 : 10.r),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize:   widget.isMobile ? 12 : 13.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
