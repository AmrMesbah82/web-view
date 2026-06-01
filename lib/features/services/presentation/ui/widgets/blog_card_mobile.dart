part of '../pages/services_page.dart';

class _BlogCardMobile extends StatelessWidget {
  final BlogPostModel post;
  final bool          isRtl;
  final Color         primaryColor;
  const _BlogCardMobile({
    required this.post,
    this.isRtl = false,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final String dateStr = post.createdAt != null
        ? isRtl
        ? '${post.createdAt!.day} ${_monthNameAr(post.createdAt!.month)} ${post.createdAt!.year}'
        : '${post.createdAt!.day} ${_monthName(post.createdAt!.month)} ${post.createdAt!.year}'
        : '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color:        _kSurface,
          borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(10.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: SizedBox(
                width:  double.infinity,
                height: 80.h,
                child: post.imageUrl.isNotEmpty
                    ? SvgPicture.network(
                  post.imageUrl,
                  width:  double.infinity,
                  height: 80.h,
                  fit:    BoxFit.cover,
                  placeholderBuilder: (_) => Container(
                    color: _kGreenLight,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color:       primaryColor,
                      ),
                    ),
                  ),
                )
                    : Container(color: _kGreenLight),
              ),
            ),
            SizedBox(height: 12.h),
            Text(_tb(post.question, isRtl),
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize:   14.sp,
                    fontWeight: FontWeight.w600,
                    color:      primaryColor,
                    height:     1.4)),
            SizedBox(height: 8.h),
            Text('• • • • • • • • • • • • • • • • •',
                style: TextStyle(
                    color:         _kDivider,
                    fontSize:      8.sp,
                    letterSpacing: 1.5)),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(dateStr,
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize:   12.sp,
                        color:      AppColors.secondaryBlack)),
                const Spacer(),
                _ReadMoreBtnMobile(
                  label:        isRtl ? 'اقرأ المزيد' : 'Read More',
                  onTap:        () => context.go('/blog/${post.id}'),
                  primaryColor: primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Blog Card – Desktop ──────────────────────────────────────────────────────
