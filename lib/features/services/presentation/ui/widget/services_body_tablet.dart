part of '../pages/services_page.dart';

class _ServicesBodyTablet extends StatelessWidget {
  final ServicePageModel    model;
  final List<BlogPostModel> blogs;
  final bool                isRtl;
  final Color               primaryColor;
  final Color               secondaryColor;
  const _ServicesBodyTablet({
    required this.model,
    required this.blogs,
    required this.isRtl,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final double screenW = MediaQuery.of(context).size.width;
    final double hPad    = 16.w;
    final double gap     = 10.w;
    final double cardW   = (screenW - hPad * 2 - gap) / 2;

    final String sectionTitle =
    _t(model.journeyTitle, isRtl).isNotEmpty
        ? _t(model.journeyTitle, isRtl)
        : (isRtl
        ? 'أسباب اختيار بيانتز لرحلتك الرقمية'
        : 'Reasons to Choose Bayanatz for Your Digital Journey');
    final String importantReads =
    isRtl ? 'قراءات مهمة' : 'Important Reads';

    final List<List<JourneyItemModel>> rows = [];
    for (int i = 0; i < model.journeyItems.length; i += 2) {
      rows.add(model.journeyItems.skip(i).take(2).toList());
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Reveal(
            delay:     const Duration(milliseconds: 80),
            direction: _SlideDirection.fromLeft,
            duration:  const Duration(milliseconds: 600),
            child: Text(sectionTitle,
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize:   16.sp,
                    fontWeight: FontWeight.w800,
                    color:      primaryColor,
                    height:     1.4)),
          ),
          SizedBox(height: 14.h),

          ...rows.asMap().entries.map((rowEntry) {
            final int  rowIdx    = rowEntry.key;
            final bool isLastRow = rowIdx == rows.length - 1;
            return Padding(
                padding: EdgeInsets.only(bottom: isLastRow ? 0 : gap),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize:       MainAxisSize.max,
                    children: rowEntry.value.asMap().entries.map((e) {
                      final int  cardIdx = e.key;
                      final bool isLast  = cardIdx == rowEntry.value.length - 1;
                      final int  delayMs = 100 + rowIdx * 60 + cardIdx * 90;
                      return Flexible(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(end: isLast ? 0 : gap),
                          child: _Reveal(
                            delay:     Duration(milliseconds: delayMs),
                            direction: _SlideDirection.fromBottom,
                            duration:  const Duration(milliseconds: 650),
                            child: SizedBox(
                              width: double.infinity,
                              child: _ServiceCardMobile(
                                  item:           e.value,
                                  isRtl:          isRtl,
                                  primaryColor:   primaryColor,
                                  secondaryColor: secondaryColor),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ));
          }),
          SizedBox(height: 30.h),

          _Reveal(
            delay:     const Duration(milliseconds: 80),
            direction: _SlideDirection.fromLeft,
            duration:  const Duration(milliseconds: 600),
            child: Text(importantReads,
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize:   18.sp,
                    fontWeight: FontWeight.w800,
                    color:      primaryColor,
                    height:     1.4)),
          ),
          SizedBox(height: 14.h),

          // ✅ Wrap supports any number of blog posts on tablet too
          Wrap(
            spacing:    gap,
            runSpacing: gap,
            children: blogs.asMap().entries.map((e) => _Reveal(
              delay:     Duration(milliseconds: 100 + e.key * 110),
              direction: _SlideDirection.fromBottom,
              duration:  const Duration(milliseconds: 650),
              child: SizedBox(
                width: cardW,
                child: _BlogCardMobile(
                    post:         e.value,
                    isRtl:        isRtl,
                    primaryColor: primaryColor),
              ),
            )).toList(),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MOBILE BODY
// ═══════════════════════════════════════════════════════════════════════════════
