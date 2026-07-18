part of '../pages/services_page.dart';

class _ServicesBodyDesktop extends StatefulWidget {
  final ServicePageModel    model;
  final List<BlogPostModel> blogs;
  final bool                isRtl;
  final Color               primaryColor;
  final Color               secondaryColor;
  const _ServicesBodyDesktop({
    required this.model,
    required this.blogs,
    required this.isRtl,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  State<_ServicesBodyDesktop> createState() => _ServicesBodyDesktopState();
}

class _ServicesBodyDesktopState extends State<_ServicesBodyDesktop> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final double screenW  = MediaQuery.of(context).size.width;
    final double contentW = _desktopContentWidth(context);
    final double hPad =
    ((screenW - contentW) / 2).clamp(16.0, double.infinity);
    final double gap = 10.w;

    final String sectionTitle =
    _t(widget.model.journeyTitle, widget.isRtl).isNotEmpty
        ? _t(widget.model.journeyTitle, widget.isRtl)
        : (widget.isRtl
        ? 'أسباب اختيار بيانتز لرحلتك الرقمية'
        : 'Reasons to Choose Bayanatz for Your Digital Journey');
    final String importantReads =
    widget.isRtl ? 'قراءات مهمة' : 'Important Reads';

    final bool hasMore = widget.model.journeyItems.length > 4;
    final List<JourneyItemModel> visibleItems =
    hasMore && !_showAll
        ? widget.model.journeyItems.take(4).toList()
        : widget.model.journeyItems;

    final List<List<JourneyItemModel>> rows = [];
    for (int i = 0; i < visibleItems.length; i += 4) {
      rows.add(visibleItems.skip(i).take(4).toList());
    }

    // ✅ FIX: blog card width calculated for up to 5 posts using Wrap
    final double blogCardW = (contentW - gap * 2) / 3;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),

          // ── Title row ──────────────────────────────────────────────────
          _Reveal(
            delay:     const Duration(milliseconds: 80),
            direction: _SlideDirection.fromLeft,
            duration:  const Duration(milliseconds: 650),
            child: Row(
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(FormatHelper.capitalize(sectionTitle),
                      style: StyleText.fontSize22Weight700.copyWith(
                          fontSize:   30.sp,
                          color:      widget.primaryColor,
                          fontWeight: AppFontWeights.extraBold)),
                ),
                if (hasMore)
                  GestureDetector(
                    onTap: () =>
                        setState(() => _showAll = !_showAll),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color:        widget.primaryColor,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                              color: widget.primaryColor, width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _showAll
                                  ? (widget.isRtl ? 'عرض أقل' : 'See Less')
                                  : (widget.isRtl ? 'عرض المزيد' : 'See More'),
                              style: StyleText.fontSize13Weight600.copyWith(
                                color:    Colors.white,
                                fontSize: 13.sp,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            AnimatedRotation(
                              turns:    _showAll ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Colors.white,
                                size:  18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // ── Service cards ──────────────────────────────────────────────
          widget.model.journeyItems.isEmpty
              ? _Reveal(
            delay:     const Duration(milliseconds: 150),
            direction: _SlideDirection.fromBottom,
            child: Container(
              height: 100.h,
              decoration: BoxDecoration(
                  color:        _kSurface,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: _kDivider)),
              child: Center(
                child: Text(
                    widget.isRtl
                        ? 'لم تتم إضافة خدمات بعد.'
                        : 'No services added yet.',
                    style: StyleText.fontSize14Weight400.copyWith(
                        fontFamily: 'Cairo',
                        fontSize:   12.sp,
                        color:      _kDivider)),
              ),
            ),
          )
              : AnimatedSize(
            duration: const Duration(milliseconds: 350),
            curve:    Curves.easeInOut,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rows.asMap().entries.map((rowEntry) {
                final int  rowIdx    = rowEntry.key;
                final bool isLastRow = rowIdx == rows.length - 1;
                return Padding(
                    padding: EdgeInsets.only(bottom: isLastRow ? 0 : gap),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize:       MainAxisSize.max,
                        children: rowEntry.value
                            .asMap()
                            .entries
                            .map((e) {
                          final int  cardIdx = e.key;
                          final bool isLast  = cardIdx == rowEntry.value.length - 1;
                          final int  delayMs = 120 + rowIdx * 60 + cardIdx * 80;
                          return Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(
                                  end: isLast ? 0 : gap),
                              child: _Reveal(
                                delay:     Duration(milliseconds: delayMs),
                                direction: _SlideDirection.fromBottom,
                                duration:  const Duration(milliseconds: 650),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: _ServiceCardDesktop(
                                      item:           e.value,
                                      isRtl:          widget.isRtl,
                                      primaryColor:   widget.primaryColor,
                                      secondaryColor: widget.secondaryColor),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ));
              }).toList(),
            ),
          ),
          SizedBox(height: 36.h),

          // ── Blog section title ─────────────────────────────────────────
          _Reveal(
            delay:     const Duration(milliseconds: 80),
            direction: _SlideDirection.fromLeft,
            duration:  const Duration(milliseconds: 650),
            child: Text(importantReads,
                style: StyleText.fontSize22Weight700.copyWith(
                    fontSize:   30.sp,
                    color:      widget.primaryColor,
                    fontWeight: AppFontWeights.extraBold)),
          ),
          SizedBox(height: 14.h),

          // ✅ FIX: Wrap instead of Row — supports any number of blog posts
          if (widget.blogs.isNotEmpty)
            Wrap(
              spacing:    gap,
              runSpacing: gap,
              children: widget.blogs.asMap().entries.map((e) {
                final int i = e.key;
                final _SlideDirection dir = i == 0
                    ? _SlideDirection.fromLeft
                    : i == widget.blogs.length - 1
                    ? _SlideDirection.fromRight
                    : _SlideDirection.fromBottom;
                return _Reveal(
                  delay:     Duration(milliseconds: 100 + i * 120),
                  direction: dir,
                  duration:  const Duration(milliseconds: 700),
                  child: SizedBox(
                    width: blogCardW,
                    child: _BlogCardDesktop(
                        post:         e.value,
                        isRtl:        widget.isRtl,
                        primaryColor: widget.primaryColor),
                  ),
                );
              }).toList(),
            ),
          SizedBox(height: 36.h),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TABLET BODY
// ═══════════════════════════════════════════════════════════════════════════════
