part of '../pages/blog_detail_page.dart';

class _DesktopBody extends StatelessWidget {
  final List<BlogPostModel>  posts;
  final BlogPostModel        selected;
  final bool                 expanded;
  final bool                 isRtl;
  final Color                primary;
  final Color                secondary;
  final ValueChanged<String> onTabChange;
  final VoidCallback         onToggleExpand;

  const _DesktopBody({
    required this.posts,
    required this.selected,
    required this.expanded,
    required this.isRtl,
    required this.primary,
    required this.secondary,
    required this.onTabChange,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    final double pageW = (450.w * 3) + (12.w * 2);

    return SizedBox(
      width: 1010.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 32.h),

          // ── Tab buttons ────────────────────────────────────────────────
          SizedBox(
            width: pageW,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: posts.asMap().entries.map((e) {
                final bool isLast = e.key == posts.length - 1;
                return Padding(
                  padding: EdgeInsets.only(right: 10.sp),
                  child: _BlogNavButton(
                    label: FormatHelper.capitalize(
                        _tb(e.value.descriptionTitle, isRtl).isNotEmpty
                            ? _tb(e.value.descriptionTitle, isRtl)
                            : _tb(e.value.question, isRtl)),  // ← new:
                    isSelected: selected.id == e.value.id,
                    onTap:      () => onTabChange(e.value.id),
                    isMobile:   false,
                    primary:    primary,
                    secondary:  secondary,
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 40.h),

          // ── Article body ───────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            width: pageW,
            child: Padding(
              padding:  EdgeInsets.only(right: 15.sp, left: 15.sp, top: 10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question as page title
                  Text(
                    FormatHelper.capitalize(_tb(selected.question, isRtl)),
                    style: AppTextStyles.font28BlackSemiBoldCairo.copyWith(
                      fontSize:   28.sp,
                      fontWeight: FontWeight.w700,
                      color:      primary,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // ── Intro row: text left, image right ──────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // descriptionTitle
                            Text(
                              FormatHelper.capitalize(
                                  _tb(selected.descriptionTitle, isRtl)),
                              style: AppTextStyles.font14BlackCairo.copyWith(
                                fontSize:   15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            // shortDescription
                            Text(
                              _tb(selected.shortDescription, isRtl),
                              style: AppTextStyles.font12BlackCairoRegular
                                  .copyWith(
                                fontSize: 13.sp,
                                height:   1.7,
                                color:    AppColors.secondaryBlack,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            // date
                            Text(
                              _formatDate(selected.createdAt, isRtl),
                              style: AppTextStyles.font10BlackCairoRegular
                                  .copyWith(
                                fontSize: 12.sp,
                                color:    AppColors.secondaryBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 32.w),

                      // ✅ SVG-only image
                      _BlogImage(
                        url:           selected.imageUrl,
                        width:         240.w,
                        height:        190.h,
                        radius:        12.r,
                        fallbackColor: secondary,
                        primaryColor:  primary,
                      ),
                    ],
                  ),

                  // ── Blocks: always shown (no read more/less) ───────────
                  SizedBox(height: 28.h),
                  _BlockList(
                    blocks:   selected.blocks,
                    isRtl:    isRtl,
                    fontSize: 13.sp,
                    isMobile: false,
                    primary:  primary,
                  ),

                ],
              ),
            ),
          ),

          SizedBox(height: 48.h),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// BLOCK LIST — renders all BlogDescriptionBlocks
// ═══════════════════════════════════════════════════════════════════════════════
