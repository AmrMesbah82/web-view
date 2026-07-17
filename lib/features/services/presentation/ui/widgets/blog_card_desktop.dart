part of '../pages/services_page.dart';

class _BlogCardDesktop extends StatefulWidget {
  final BlogPostModel post;
  final bool          isRtl;
  final Color         primaryColor;
  const _BlogCardDesktop({
    required this.post,
    this.isRtl = false,
    required this.primaryColor,
  });
  @override
  State<_BlogCardDesktop> createState() => _BlogCardDesktopState();
}

class _BlogCardDesktopState extends State<_BlogCardDesktop> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final String dateStr = widget.post.createdAt != null
        ? widget.isRtl
        ? '${_monthNameAr(widget.post.createdAt!.month)} ${widget.post.createdAt!.day} ${widget.post.createdAt!.year}'
        : '${_monthName(widget.post.createdAt!.month)} ${widget.post.createdAt!.day} ${widget.post.createdAt!.year}'
        : '';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration:   const Duration(milliseconds: 200),
        decoration: BoxDecoration(
            color:        _kSurface,
            borderRadius: BorderRadius.circular(12.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:       MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize:       MainAxisSize.max,
                      mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                      children: [
                        Text(FormatHelper.capitalize(_tb(widget.post.question, widget.isRtl)),
                            style: StyleText.fontSize12Weight500
                                .copyWith(
                                fontSize:   15.sp,
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: 10.h),
                        Builder(builder: (_) {
                          final shortDesc =
                              _tb(widget.post.shortDescription, widget.isRtl);
                          if (shortDesc.trim().isEmpty) {
                            return Text('• • • • • • • • • • •',
                                style: TextStyle(
                                    color:         _kDivider,
                                    fontSize:      9.sp,
                                    letterSpacing: 2));
                          }
                          return Text(
                            shortDesc,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign:
                                widget.isRtl ? TextAlign.right : TextAlign.left,
                            style: AppTextStyles.font14BlackCairoRegular.copyWith(
                                color:    AppColors.secondaryBlack,
                                fontSize: 12.sp),
                          );
                        }),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  _svgBlogImage(
                      url:          widget.post.imageUrl,
                      width:        80.w,
                      height:       96.h,
                      radius:       10.r,
                      primaryColor: widget.primaryColor),
                ],
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  Text(dateStr,
                      style: AppTextStyles.font14BlackCairoRegular
                          .copyWith(
                          color:    AppColors.secondaryBlack,
                          fontSize: 12.sp)),
                  const Spacer(),
                  _ReadMoreBtnDesktop(
                      isRtl:        widget.isRtl,
                      primaryColor: widget.primaryColor,
                      postId: widget.post.id),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Read-more buttons ────────────────────────────────────────────────────────
