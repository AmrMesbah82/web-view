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

  // Localize Western digits (0-9) to Arabic-Indic (٠-٩).
  String _arDigits(String s) {
    const ar = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    final buf = StringBuffer();
    for (final ch in s.split('')) {
      final code = ch.codeUnitAt(0);
      buf.write(code >= 48 && code <= 57 ? ar[code - 48] : ch);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final String dateStr = post.createdAt != null
        ? isRtl
        ? _arDigits(
            '${post.createdAt!.day} ${_monthNameAr(post.createdAt!.month)} ${post.createdAt!.year}')
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
                  fit:    BoxFit.contain,
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
                style: StyleText.fontSize14Weight600.copyWith(
                    color:  primaryColor,
                    height: 1.4)),
            SizedBox(height: 8.h),
            Text(_tb(post.shortDescription, isRtl),
                style: StyleText.fontSize10Weight400.copyWith(
                    fontWeight: FontWeight.w600,
                    color:      AppColors.text,
                    height:     1.4)),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(dateStr,
                    style: StyleText.fontSize12Weight400.copyWith(
                        color: AppColors.secondaryBlack)),
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
