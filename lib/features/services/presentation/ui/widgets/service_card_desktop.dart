part of '../pages/services_page.dart';

class _ServiceCardDesktop extends StatefulWidget {
  final JourneyItemModel item;
  final bool             isRtl;
  final Color            primaryColor;
  final Color            secondaryColor;
  const _ServiceCardDesktop({
    required this.item,
    this.isRtl = false,
    required this.primaryColor,
    this.secondaryColor = _kGreenLight,
  });
  @override
  State<_ServiceCardDesktop> createState() => _ServiceCardDesktopState();
}

class _ServiceCardDesktopState extends State<_ServiceCardDesktop> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width:    double.infinity,
        padding:  EdgeInsets.all(14.r),
        decoration: BoxDecoration(
            color:        _kSurface,
            borderRadius: BorderRadius.circular(12.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _svgIconBox(
                url:            widget.item.iconUrl,
                size:           30.w,
                radius:         7.r,
                primaryColor:   widget.primaryColor,
                secondaryColor: widget.secondaryColor),
            SizedBox(height: 10.h),
            Text(_t(widget.item.title, widget.isRtl),
                style: StyleText.fontSize14Weight400
                    .copyWith(fontSize: 13.sp)),
            SizedBox(height: 6.h),
            Text(_t(widget.item.description, widget.isRtl),
                style: StyleText.fontSize12Weight500.copyWith(
                    color:    AppColors.secondaryBlack,
                    fontSize: 11.sp,
                    height:   1.6)),
          ],
        ),
      ),
    );
  }
}

// ─── Blog Card – Mobile ───────────────────────────────────────────────────────
