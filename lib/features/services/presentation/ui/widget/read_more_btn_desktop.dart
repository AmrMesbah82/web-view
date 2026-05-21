part of '../pages/services_page.dart';

class _ReadMoreBtnDesktop extends StatefulWidget {
  final bool  isRtl;
  final Color primaryColor;
  final String postId;
  const _ReadMoreBtnDesktop({
    this.isRtl = false,
    required this.primaryColor,
    required this.postId,
  });
  @override
  State<_ReadMoreBtnDesktop> createState() => _ReadMoreBtnDesktopState();
}

class _ReadMoreBtnDesktopState extends State<_ReadMoreBtnDesktop> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Color hoverColor =
    Color.lerp(widget.primaryColor, Colors.black, 0.2)!;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor:  SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/blog/${widget.postId}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width:    88.w,
          height:   28.h,
          decoration: BoxDecoration(
              color:        _hovered ? hoverColor : widget.primaryColor,
              borderRadius: BorderRadius.circular(6.r)),
          child: Center(
            child: Text(
                widget.isRtl ? 'اقرأ المزيد' : 'Read More',
                style: AppTextStyles.font12WhiteCairo.copyWith(
                    fontSize:   12.sp,
                    fontWeight: FontWeight.w500)),
          ),
        ),
      ),
    );
  }
}
