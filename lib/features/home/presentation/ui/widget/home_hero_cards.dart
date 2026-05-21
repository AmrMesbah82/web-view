part of '../pages/home_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Hero Cards Section — dispatches to breakpoint layout
// ─────────────────────────────────────────────────────────────────────────────

class _HeroCardsSection extends StatelessWidget {
  final HomePageModel data;
  final Color         bgColor;
  const _HeroCardsSection({required this.data, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    if (w >= _BP.tablet) return _DesktopCards(data: data, bgColor: bgColor);
    if (w >= _BP.mobile) return _TabletCards(data: data, bgColor: bgColor);
    return _MobileCards(data: data, bgColor: bgColor);
  }
}

Color _sectionColor(String hex) {
  try {
    final h = hex.replaceAll('#', '');
    if (h.length == 6) return Color(int.parse('FF$h', radix: 16));
  } catch (_) {}
  return _kDefaultPrimary;
}

// ─────────────────────────────────────────────────────────────────────────────
// DESKTOP
// ─────────────────────────────────────────────────────────────────────────────

class _DesktopCards extends StatelessWidget {
  final HomePageModel data;
  final Color         bgColor;
  const _DesktopCards({required this.data, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    final double innerOffset = 36.h + 10.h + 90.h;
    final double btnOffset   = innerOffset + 36.h + 10.h;
    final sec     = data.sections;
    final isRtl   = context.read<LanguageCubit>().state.isArabic;
    final primary = _sectionColor(data.branding.primaryColor);

    String secDesc(int i) => i < sec.length
        ? (isRtl
        ? (sec[i].description.ar.isNotEmpty
        ? sec[i].description.ar
        : sec[i].description.en)
        : sec[i].description.en)
        : '';

    // ✅ Check section visibility from Firestore
    bool secVisible(int i) => i < sec.length ? sec[i].visibility : true;

    return Container(
      color:   bgColor,
      padding: EdgeInsets.symmetric(horizontal: 36.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:  MainAxisAlignment.center,
        children: [
          // ✅ Section 0 — Left outer card
          Flexible(
            flex: 2,
            child: Visibility(
              visible: secVisible(0),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: _Reveal(
                delay:     const Duration(milliseconds: 100),
                direction: _SlideDirection.fromLeft,
                duration:  const Duration(milliseconds: 700),
                child: _OuterCard(
                  iconUrl:     sec.isNotEmpty ? sec[0].iconUrl  : '',
                  imageUrl:    sec.isNotEmpty ? sec[0].imageUrl : '',
                  text:        secDesc(0),
                  cardColor:   primary,
                  iconOnRight: true,
                  isRtl:       isRtl,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // ✅ Section 1 — Left inner column
          Flexible(
            flex: 1,
            child: Visibility(
              visible: secVisible(1),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: _Reveal(
                delay:     const Duration(milliseconds: 180),
                direction: _SlideDirection.fromBottom,
                duration:  const Duration(milliseconds: 700),
                child: SizedBox(
                  width: 160.w,
                  child: Column(
                    mainAxisSize:       MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: innerOffset),
                      _CircleIcon(
                          iconUrl:   sec.length > 1 ? sec[1].iconUrl : '',
                          iconColor: primary),
                      SizedBox(height: 10.h),
                      _SectionImage(
                          imageUrl: sec.length > 1 ? sec[1].imageUrl : '',
                          width:    160.w,
                          height:   180.h),
                      SizedBox(height: 10.h),
                      _GreenCard(
                        width: 160.w,
                        text:  secDesc(1),
                        color: primary,
                        isRtl: isRtl,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // Nav buttons column (no visibility toggle — always visible)
          Flexible(
            flex: 2,
            child: SizedBox(
              width: 240.w,
              child: Column(
                mainAxisAlignment:  MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: btnOffset),
                  ...data.navButtons
                      .where((btn) => btn.status)
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final btn   = entry.value;
                    final label = isRtl
                        ? (btn.name.ar.isNotEmpty
                        ? btn.name.ar
                        : btn.name.en)
                        : btn.name.en;

                    final double btnWidth = index == 0
                        ? 240.w
                        : index == 1
                        ? 196.w
                        : index == 2
                        ? 172.w
                        : index == 3
                        ? 150.w
                        : index == 4
                        ? 120.w
                        : 100.w;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _Reveal(
                        delay: Duration(milliseconds: 200 + index * 80),
                        direction: _SlideDirection.fromBottom,
                        duration:  const Duration(milliseconds: 600),
                        child: SizedBox(
                          width: btnWidth,
                          child: _CmsNavBtn(
                            label:   label,
                            route:   btn.route,
                            primary: primary,
                            isRtl:   isRtl,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // ✅ Section 2 — Right inner column
          Flexible(
            flex: 1,
            child: Visibility(
              visible: secVisible(2),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: _Reveal(
                delay:     const Duration(milliseconds: 180),
                direction: _SlideDirection.fromBottom,
                duration:  const Duration(milliseconds: 700),
                child: SizedBox(
                  width: 160.w,
                  child: Column(
                    mainAxisSize:       MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: innerOffset),
                      _CircleIcon(
                          iconUrl:   sec.length > 2 ? sec[2].iconUrl : '',
                          iconColor: primary),
                      SizedBox(height: 10.h),
                      _SectionImage(
                          imageUrl: sec.length > 2 ? sec[2].imageUrl : '',
                          width:    160.w,
                          height:   180.h),
                      SizedBox(height: 10.h),
                      _GreenCard(
                        width: 160.w,
                        text:  secDesc(2),
                        color: primary,
                        isRtl: isRtl,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // ✅ Section 3 — Right outer card
          Flexible(
            flex: 2,
            child: Visibility(
              visible: secVisible(3),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: _Reveal(
                delay:     const Duration(milliseconds: 100),
                direction: _SlideDirection.fromRight,
                duration:  const Duration(milliseconds: 700),
                child: _OuterCard(
                  iconUrl:     sec.length > 3 ? sec[3].iconUrl  : '',
                  imageUrl:    sec.length > 3 ? sec[3].imageUrl : '',
                  text:        secDesc(3),
                  cardColor:   primary,
                  iconOnRight: false,
                  isRtl:       isRtl,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OuterCard extends StatelessWidget {
  final String iconUrl;
  final String imageUrl;
  final String text;
  final Color  cardColor;
  final bool   iconOnRight;
  final bool   isRtl;

  const _OuterCard({
    required this.iconUrl,
    required this.imageUrl,
    required this.text,
    required this.cardColor,
    this.iconOnRight = false,
    this.isRtl       = false,
  });

  @override
  Widget build(BuildContext context) {
    final double totalW = 212.w;
    final double iconSz = 36.w;
    final double imgW   = 160.w;
    final double gap    = 12.w;

    final Widget img = _SectionImage(
        imageUrl: imageUrl, width: imgW, height: 180.h, radius: 16.r);

    final Widget icn = Container(
      width:  iconSz,
      height: iconSz,
      decoration:
      const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: ClipOval(
        child: _smartImage(
          url:         iconUrl,
          width:       18.w,
          height:      18.w,
          fit:         BoxFit.scaleDown,
          colorFilter: cardColor,
          fallback:
          Icon(Icons.image_outlined, size: 16.sp, color: cardColor),
        ),
      ),
    );

    return SizedBox(
      width: totalW,
      child: Column(
        mainAxisSize:       MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:       MainAxisSize.min,
            children: iconOnRight
                ? [img, SizedBox(width: gap), icn]
                : [icn, SizedBox(width: gap), img],
          ),
          SizedBox(height: 10.h),
          _GreenCard(
            width: totalW,
            text:  text,
            color: cardColor,
            isRtl: isRtl,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TABLET
// ─────────────────────────────────────────────────────────────────────────────

class _TabletCards extends StatelessWidget {
  final HomePageModel data;
  final Color         bgColor;
  const _TabletCards({required this.data, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    final double cardW  = 130.w;
    final double imageH = 150.h;
    final sec     = data.sections;
    final isRtl   = context.read<LanguageCubit>().state.isArabic;
    final primary = _sectionColor(data.branding.primaryColor);

    String secDesc(int i) => i < sec.length
        ? (isRtl
        ? (sec[i].description.ar.isNotEmpty
        ? sec[i].description.ar
        : sec[i].description.en)
        : sec[i].description.en)
        : '';

    // ✅ Check section visibility from Firestore
    bool secVisible(int i) => i < sec.length ? sec[i].visibility : true;

    return Container(
      color:   bgColor,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Section 0 image+icon (top-left)
              Visibility(
                visible: secVisible(0),
                maintainSize: true, maintainAnimation: true, maintainState: true,
                child: _Reveal(
                  delay:     const Duration(milliseconds: 100),
                  direction: _SlideDirection.fromLeft,
                  duration:  const Duration(milliseconds: 650),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: cardW,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: _CircleIcon(
                              iconUrl:   sec.isNotEmpty ? sec[0].iconUrl : '',
                              iconColor: primary),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      _SectionImage(
                          imageUrl: sec.isNotEmpty ? sec[0].imageUrl : '',
                          width:    cardW,
                          height:   imageH),
                    ],
                  ),
                ),
              ), // ✅ closes Visibility for section 0
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 36.w + 6.h),
                    ...data.navButtons
                        .where((btn) => btn.status)
                        .take(2)
                        .toList()
                        .asMap()
                        .entries
                        .map((e) {
                      final btn   = e.value;
                      final label = isRtl
                          ? (btn.name.ar.isNotEmpty
                          ? btn.name.ar
                          : btn.name.en)
                          : btn.name.en;
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _Reveal(
                          delay: Duration(
                              milliseconds: 150 + e.key * 80),
                          direction: _SlideDirection.fromBottom,
                          duration:
                          const Duration(milliseconds: 600),
                          child: _CmsNavBtn(
                            label:   label,
                            route:   btn.route,
                            primary: primary,
                            isRtl:   isRtl,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              // ✅ Section 3 image+icon (top-right)
              Visibility(
                visible: secVisible(3),
                maintainSize: true, maintainAnimation: true, maintainState: true,
                child: _Reveal(
                  delay:     const Duration(milliseconds: 100),
                  direction: _SlideDirection.fromRight,
                  duration:  const Duration(milliseconds: 650),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: cardW,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _CircleIcon(
                              iconUrl:   sec.length > 3 ? sec[3].iconUrl : '',
                              iconColor: primary),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      _SectionImage(
                          imageUrl: sec.length > 3 ? sec[3].imageUrl : '',
                          width:    cardW,
                          height:   imageH),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ✅ Section 0 green card
                Visibility(
                  visible: secVisible(0),
                  maintainSize: true, maintainAnimation: true, maintainState: true,
                  child: _Reveal(
                    delay:     const Duration(milliseconds: 120),
                    direction: _SlideDirection.fromBottom,
                    duration:  const Duration(milliseconds: 650),
                    child: _GreenCard(
                      width:    cardW,
                      text:     secDesc(0),
                      color:    primary,
                      fontSize: 11.sp,
                      isRtl:    isRtl,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                // ✅ Section 1 column
                Expanded(
                  child: Visibility(
                    visible: secVisible(1),
                    maintainSize: true, maintainAnimation: true, maintainState: true,
                    child: _Reveal(
                      delay:     const Duration(milliseconds: 200),
                      direction: _SlideDirection.fromBottom,
                      duration:  const Duration(milliseconds: 650),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _CircleIcon(
                              iconUrl:   sec.length > 1 ? sec[1].iconUrl : '',
                              iconColor: primary),
                          SizedBox(height: 6.h),
                          _SectionImage(
                              imageUrl: sec.length > 1 ? sec[1].imageUrl : '',
                              height:   imageH * 0.6),
                          SizedBox(height: 6.h),
                          _GreenCard(
                            text:     secDesc(1),
                            color:    primary,
                            fontSize: 11.sp,
                            isRtl:    isRtl,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                // ✅ Section 2 column
                Expanded(
                  child: Visibility(
                    visible: secVisible(2),
                    maintainSize: true, maintainAnimation: true, maintainState: true,
                    child: _Reveal(
                      delay:     const Duration(milliseconds: 280),
                      direction: _SlideDirection.fromBottom,
                      duration:  const Duration(milliseconds: 650),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _CircleIcon(
                              iconUrl:   sec.length > 2 ? sec[2].iconUrl : '',
                              iconColor: primary),
                          SizedBox(height: 6.h),
                          _SectionImage(
                              imageUrl: sec.length > 2 ? sec[2].imageUrl : '',
                              height:   imageH * 0.6),
                          SizedBox(height: 6.h),
                          _GreenCard(
                            text:     secDesc(2),
                            color:    primary,
                            fontSize: 11.sp,
                            isRtl:    isRtl,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                // ✅ Section 3 green card
                Visibility(
                  visible: secVisible(3),
                  maintainSize: true, maintainAnimation: true, maintainState: true,
                  child: _Reveal(
                    delay:     const Duration(milliseconds: 120),
                    direction: _SlideDirection.fromBottom,
                    duration:  const Duration(milliseconds: 650),
                    child: _GreenCard(
                      width:    cardW,
                      text:     secDesc(3),
                      color:    primary,
                      fontSize: 11.sp,
                      isRtl:    isRtl,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MOBILE
// ─────────────────────────────────────────────────────────────────────────────

class _MobileCards extends StatelessWidget {
  final HomePageModel data;
  final Color         bgColor;
  const _MobileCards({required this.data, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    final double sw   = MediaQuery.of(context).size.width;
    final double hPad = 16.w;
    final double gap  = 8.w;

    final double colWidth   = (sw - hPad * 2 - gap) / 2;
    final double imageCardH = colWidth * 1.25;

    final sec     = data.sections;
    final isRtl   = context.read<LanguageCubit>().state.isArabic;
    final primary = _sectionColor(data.branding.primaryColor);

    String secDesc(int i)  => i < sec.length
        ? (isRtl
        ? (sec[i].description.ar.isNotEmpty
        ? sec[i].description.ar
        : sec[i].description.en)
        : sec[i].description.en)
        : '';
    String secIcon(int i)  => i < sec.length ? sec[i].iconUrl  : '';
    String secImage(int i) => i < sec.length ? sec[i].imageUrl : '';

    // ✅ Check section visibility from Firestore
    bool secVisible(int i) => i < sec.length ? sec[i].visibility : true;

    Widget imageIconCard({
      required double width,
      required String imageUrl,
      String? iconUrl,
      bool    iconOnLeft = true,
    }) {
      final double iconSize    = 36.w;
      final double imageHeight = imageCardH - iconSize - 8.h;
      return SizedBox(
        width:  width,
        height: imageCardH,
        child: Column(
          mainAxisSize:       MainAxisSize.min,
          crossAxisAlignment: iconOnLeft
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (iconUrl != null && iconUrl.isNotEmpty)
              _CircleIcon(iconUrl: iconUrl, iconColor: primary)
            else
              SizedBox(height: iconSize, width: iconSize),
            SizedBox(height: 8.h),
            _SectionImage(
              imageUrl: imageUrl,
              width:    width,
              height:   imageHeight,
              radius:   8.r,
            ),
          ],
        ),
      );
    }

    Widget statCard({
      required double width,
      required String text,
      required Color  color,
      String? iconUrl,
    }) {
      return Container(
        width:   width,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color:        color,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisSize:       MainAxisSize.min,
          crossAxisAlignment: isRtl
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              textAlign:     isRtl ? TextAlign.right : TextAlign.left,
              textDirection:
              isRtl ? TextDirection.rtl : TextDirection.ltr,
              style: GoogleFonts.cairo(
                fontSize:   11.sp,
                fontWeight: FontWeight.w400,
                color:      Colors.white,
                height:     1.4,
              ),
            ),
          ],
        ),
      );
    }

    Widget fullWidthCard({
      required double width,
      required String imageUrl,
      String? iconUrl,
      required String text,
      required Color  color,
    }) {
      final double iconSize = 36.w;
      return SizedBox(
        height: imageCardH,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            statCard(
                width: colWidth, text: text, color: color, iconUrl: iconUrl),
            SizedBox(width: gap),
            SizedBox(
              width: colWidth,
              child: Column(
                mainAxisSize:       MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (iconUrl != null && iconUrl.isNotEmpty)
                    _CircleIcon(iconUrl: iconUrl, iconColor: primary)
                  else
                    SizedBox(height: iconSize, width: iconSize),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: _SectionImage(
                      imageUrl: imageUrl,
                      width:    colWidth,
                      height:   double.infinity,
                      radius:   8.r,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      color:   bgColor,
      padding: EdgeInsets.fromLTRB(hPad, 0.h, hPad, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...data.navButtons
              .where((btn) => btn.status)
              .toList()
              .asMap()
              .entries
              .map((e) {
            final btn   = e.value;
            final index = e.key;
            final label = isRtl
                ? (btn.name.ar.isNotEmpty ? btn.name.ar : btn.name.en)
                : btn.name.en;
            final double fullWidth = sw - hPad * 2;
            final double btnWidth  = fullWidth * (1.0 - index * 0.12);
            return _Reveal(
              delay:     Duration(milliseconds: 80 + index * 60),
              direction: _SlideDirection.fromBottom,
              duration:  const Duration(milliseconds: 550),
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: btnWidth,
                    child: _CmsNavBtn(
                      label:   label,
                      route:   btn.route,
                      primary: primary,
                      mobile:  true,
                      isRtl:   isRtl,
                    ),
                  ),
                ),
              ),
            );
          }),

          SizedBox(height: 12.h),

          // ✅ Section 0
          Visibility(
            visible: secVisible(0),
            maintainSize: true, maintainAnimation: true, maintainState: true,
            child: _Reveal(
              delay:     const Duration(milliseconds: 200),
              direction: _SlideDirection.fromLeft,
              duration:  const Duration(milliseconds: 650),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    imageIconCard(
                        width:     colWidth,
                        imageUrl:  secImage(0),
                        iconUrl:   secIcon(0),
                        iconOnLeft: true),
                    SizedBox(width: gap),
                    statCard(
                        width: colWidth,
                        text:  secDesc(0),
                        color: primary),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: gap),

          // ✅ Section 1
          Visibility(
            visible: secVisible(1),
            maintainSize: true, maintainAnimation: true, maintainState: true,
            child: _Reveal(
              delay:     const Duration(milliseconds: 280),
              direction: _SlideDirection.fromRight,
              duration:  const Duration(milliseconds: 650),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    statCard(
                        width: colWidth,
                        text:  secDesc(1),
                        color: primary),
                    SizedBox(width: gap),
                    imageIconCard(
                        width:     colWidth,
                        imageUrl:  secImage(1),
                        iconUrl:   secIcon(1),
                        iconOnLeft: false),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: gap),

          // ✅ Section 2
          Visibility(
            visible: secVisible(2),
            maintainSize: true, maintainAnimation: true, maintainState: true,
            child: _Reveal(
              delay:     const Duration(milliseconds: 360),
              direction: _SlideDirection.fromBottom,
              duration:  const Duration(milliseconds: 650),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    imageIconCard(
                        width:     colWidth,
                        imageUrl:  secImage(2),
                        iconUrl:   secIcon(2),
                        iconOnLeft: true),
                    SizedBox(width: gap),
                    statCard(
                        width: colWidth,
                        text:  secDesc(2),
                        color: primary),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: gap),

          // ✅ Section 3
          Visibility(
            visible: secVisible(3),
            maintainSize: true, maintainAnimation: true, maintainState: true,
            child: _Reveal(
              delay:     const Duration(milliseconds: 440),
              direction: _SlideDirection.fromBottom,
              duration:  const Duration(milliseconds: 650),
              child: fullWidthCard(
                width:    sw - hPad * 2,
                imageUrl: secImage(3),
                iconUrl:  secIcon(3),
                text:     secDesc(3),
                color:    primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
