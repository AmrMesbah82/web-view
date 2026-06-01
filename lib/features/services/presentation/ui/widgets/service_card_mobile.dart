part of '../pages/services_page.dart';

class _ServiceCardMobile extends StatelessWidget {
  final JourneyItemModel item;
  final bool             isRtl;
  final Color            primaryColor;
  final Color            secondaryColor;
  const _ServiceCardMobile({
    required this.item,
    this.isRtl = false,
    required this.primaryColor,
    this.secondaryColor = _kGreenLight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
          color:        _kSurface,
          borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _svgIconBox(
                  url:            item.iconUrl,
                  size:           36.w,
                  radius:         8.r,
                  primaryColor:   primaryColor,
                  secondaryColor: secondaryColor),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(_t(item.title, isRtl),
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize:   13.sp,
                        fontWeight: FontWeight.w600,
                        color:      const Color(0xFF1A1A1A))),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(_t(item.description, isRtl),
              style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize:   12.sp,
                  fontWeight: FontWeight.w400,
                  color:      AppColors.secondaryBlack,
                  height:     1.6)),
        ],
      ),
    );
  }
}

// ─── Service Card – Desktop ───────────────────────────────────────────────────
