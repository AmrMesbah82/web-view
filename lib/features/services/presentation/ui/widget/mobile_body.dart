part of '../pages/blog_detail_Page.dart';

class _MobileBody extends StatelessWidget {
  final List<BlogPostModel>  posts;
  final BlogPostModel        selected;
  final bool                 expanded;
  final bool                 isRtl;
  final Color                primary;
  final Color                secondary;
  final ValueChanged<String> onTabChange;
  final VoidCallback         onToggleExpand;

  const _MobileBody({
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // ── Horizontal scrollable tab buttons ─────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: posts.asMap().entries.map((e) {
                final bool isLast = e.key == posts.length - 1;
                return Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : 10),
                  child: _BlogNavButton(
                    label: _tb(e.value.descriptionTitle, isRtl).isNotEmpty
                        ? _tb(e.value.descriptionTitle, isRtl)
                        : _tb(e.value.question, isRtl),  // ← new:
                    isSelected: selected.id == e.value.id,
                    onTap:      () => onTabChange(e.value.id),
                    isMobile:   true,
                    primary:    primary,
                    secondary:  secondary,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // ── Title (question) ──────────────────────────────────────────
          Text(
            _tb(selected.question, isRtl),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize:   18,
              fontWeight: FontWeight.w700,
              color:      primary,
            ),
          ),
          const SizedBox(height: 16),

          // ── icon + heading + date LEFT, image RIGHT ───────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width:  36,
                      height: 36,
                      decoration: BoxDecoration(
                        color:        secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(Icons.bar_chart_rounded,
                            color: primary, size: 20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _tb(selected.descriptionTitle, isRtl),
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize:   14,
                        fontWeight: FontWeight.w700,
                        color:      Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatDate(selected.createdAt, isRtl),
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize:   12,
                        color:      Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // ✅ SVG-only image
              _BlogImage(
                url:           selected.imageUrl,
                width:         130,
                height:        110,
                radius:        10,
                fallbackColor: secondary,
                primaryColor:  primary,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Short description ─────────────────────────────────────────
          Text(
            _tb(selected.shortDescription, isRtl),
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize:   13,
              height:     1.7,
              color:      Colors.black54,
            ),
          ),

          const SizedBox(height: 12),

          // ── Read More / Read Less ─────────────────────────────────────
          GestureDetector(
            onTap: onToggleExpand,
            child: Text(
              expanded
                  ? (isRtl ? 'اقرأ أقل'    : 'Read Less')
                  : (isRtl ? 'اقرأ المزيد' : 'Read More'),
              style: TextStyle(
                fontFamily:      'Cairo',
                fontSize:        13,
                fontWeight:      FontWeight.w600,
                color:           primary,
                decoration:      TextDecoration.underline,
                decorationColor: primary,
              ),
            ),
          ),

          // ── Expandable: blocks ────────────────────────────────────────
          if (expanded) ...[
            const SizedBox(height: 20),
            _BlockList(
              blocks:   selected.blocks,
              isRtl:    isRtl,
              fontSize: 13,
              isMobile: true,
              primary:  primary,
            ),
            const SizedBox(height: 32),
          ] else
            const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DESKTOP BODY
// ═══════════════════════════════════════════════════════════════════════════════
