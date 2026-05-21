part of '../pages/blog_detail_Page.dart';

class _BlockList extends StatelessWidget {
  final List<BlogDescriptionBlock> blocks;
  final bool   isRtl;
  final double fontSize;
  final bool   isMobile;
  final Color  primary; // ✅ passed in so bullet uses CMS color

  const _BlockList({
    required this.blocks,
    required this.isRtl,
    required this.fontSize,
    required this.isMobile,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    int numberingCounter = 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map((block) {
        final String text = _tb(block.content, isRtl);

        switch (block.type) {

        // ── Paragraph ───────────────────────────────────────────────
          case BlogBlockType.paragraph:
            numberingCounter = 0;
            return Padding(
              padding: EdgeInsets.only(bottom: isMobile ? 10 : 10.h),
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize:   fontSize,
                  height:     1.7,
                  color:      AppColors.secondaryBlack,
                ),
              ),
            );

        // ── Numbered list item ───────────────────────────────────────
          case BlogBlockType.numbering:
            numberingCounter++;
            final int idx = numberingCounter;
            return Padding(
              padding: EdgeInsets.only(bottom: isMobile ? 10 : 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$idx.  ',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize:   fontSize,
                      height:     1.7,
                      fontWeight: FontWeight.w600,
                      color:      Colors.black87,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize:   fontSize,
                        height:     1.7,
                        color:      AppColors.secondaryBlack,
                      ),
                    ),
                  ),
                ],
              ),
            );

        // ── Bullet point ─────────────────────────────────────────────
          case BlogBlockType.bulletPoint:
            numberingCounter = 0;
            return Padding(
              padding: EdgeInsets.only(bottom: isMobile ? 10 : 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top:   isMobile ? 6.0 : 6.h,
                      right: isRtl ? 0 : (isMobile ? 8.0 : 8.w),
                      left:  isRtl ? (isMobile ? 8.0 : 8.w) : 0,
                    ),
                    child: Container(
                      width:  isMobile ? 6.0 : 6.w,
                      height: isMobile ? 6.0 : 6.w,
                      decoration: BoxDecoration(
                        color: primary, // ✅ uses CMS primary color
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize:   fontSize,
                        height:     1.7,
                        color:      AppColors.secondaryBlack,
                      ),
                    ),
                  ),
                ],
              ),
            );
        }
      }).toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// BLOG IMAGE — ✅ SVG-only, no Image.network fallback
// ═══════════════════════════════════════════════════════════════════════════════
