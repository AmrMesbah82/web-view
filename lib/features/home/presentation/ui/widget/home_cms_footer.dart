part of '../pages/home_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _CmsFooter (legacy — AppFooter is the primary one)
// ─────────────────────────────────────────────────────────────────────────────

class _CmsFooter extends StatelessWidget {
  final HomePageModel data;
  const _CmsFooter({required this.data});

  Color get _primary =>
      _hexColor(data.branding.primaryColor, fallback: _kDefaultPrimary);

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    if (w >= _BP.tablet) return _CmsFooterDesktop(data: data, primary: _primary);
    if (w >= _BP.mobile) return _CmsFooterTablet(data: data, primary: _primary);
    return _CmsFooterMobile(data: data, primary: _primary);
  }
}

class _CmsFooterDesktop extends StatelessWidget {
  final HomePageModel data;
  final Color primary;
  const _CmsFooterDesktop({required this.data, required this.primary});

  @override
  Widget build(BuildContext context) {
    final isRtl       = context.read<LanguageCubit>().state.isArabic;
    final double contentW = (248.w * 4) + (8.w * 3);
    final double hPad =
    ((MediaQuery.of(context).size.width - contentW) / 2)
        .clamp(16.w, double.infinity);

    String colTitle(FooterColumnModel col) => isRtl
        ? (col.title.ar.isNotEmpty ? col.title.ar : col.title.en)
        : col.title.en;

    List<String> colLabels(FooterColumnModel col) => col.labels
        .map((l) => isRtl
        ? (l.label.ar.isNotEmpty ? l.label.ar : l.label.en)
        : l.label.en)
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Container(
        padding: EdgeInsets.all(22.sp),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(24.r),
              topLeft:  Radius.circular(24.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36.w, height: 36.h,
                  decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Center(
                    child: data.branding.logoUrl.isNotEmpty
                        ? SvgPicture.network(
                      data.branding.logoUrl,
                      width: 28.w, height: 28.h,
                      fit: BoxFit.contain,
                    )
                        : Image.asset('assets/images/logo.jpg',
                        width: 56.w, height: 56.h, fit: BoxFit.fill),
                  ),
                ),
                SizedBox(width: 32.w),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                    children: data.footerColumns
                        .map((col) => _CmsFooterColumn(
                      title:   colTitle(col),
                      labels:  colLabels(col),
                      routes:
                      col.labels.map((l) => l.route).toList(),
                      primary: primary,
                      isRtl:   isRtl,
                    ))
                        .toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Divider(color: primary, thickness: 0.5),
            SizedBox(height: 14.h),
            Row(
              children: [
                const Expanded(flex: 3, child: SizedBox()),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      ...data.socialLinks.take(3).map((sl) => Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: _SocialIconBox(
                            iconUrl: sl.iconUrl,
                            url:     sl.url,
                            primary: primary),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CmsFooterTablet extends StatelessWidget {
  final HomePageModel data;
  final Color primary;
  const _CmsFooterTablet({required this.data, required this.primary});

  @override
  Widget build(BuildContext context) {
    final isRtl = context.read<LanguageCubit>().state.isArabic;
    final half  = data.footerColumns.length > 2
        ? data.footerColumns.length ~/ 2
        : data.footerColumns.length;

    String colTitle(FooterColumnModel col) => isRtl
        ? (col.title.ar.isNotEmpty ? col.title.ar : col.title.en)
        : col.title.en;

    List<String> colLabels(FooterColumnModel col) => col.labels
        .map((l) => isRtl
        ? (l.label.ar.isNotEmpty ? l.label.ar : l.label.en)
        : l.label.en)
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(20.sp),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(18.r),
              topLeft:  Radius.circular(18.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              children: data.footerColumns
                  .take(half)
                  .map((col) => _CmsFooterColumn(
                title:   colTitle(col),
                labels:  colLabels(col),
                routes:  col.labels.map((l) => l.route).toList(),
                primary: primary,
                isRtl:   isRtl,
              ))
                  .toList(),
            ),
            if (data.footerColumns.length > half) ...[
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: data.footerColumns
                    .skip(half)
                    .map((col) => _CmsFooterColumn(
                  title:   colTitle(col),
                  labels:  colLabels(col),
                  routes:  col.labels.map((l) => l.route).toList(),
                  primary: primary,
                  isRtl:   isRtl,
                ))
                    .toList(),
              ),
            ],
            SizedBox(height: 20.h),
            Divider(color: primary, thickness: 1.h),
            SizedBox(height: 12.h),
            Row(
              children: data.socialLinks
                  .take(3)
                  .map((sl) => Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: _SocialIconBox(
                    iconUrl: sl.iconUrl,
                    url:     sl.url,
                    primary: primary),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CmsFooterMobile extends StatelessWidget {
  final HomePageModel data;
  final Color primary;
  const _CmsFooterMobile({required this.data, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [
            Expanded(
                child: Divider(
                    color: primary.withOpacity(0.5), thickness: 1.h)),
            SizedBox(width: 10.w),
            ...data.socialLinks.take(3).map((sl) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: _SocialIconBox(
                  iconUrl: sl.iconUrl,
                  url:     sl.url,
                  primary: primary,
                  size:    32.w),
            )),
            SizedBox(width: 10.w),
            Expanded(
                child: Divider(
                    color: primary.withOpacity(0.5), thickness: 1.h)),
          ]),
        ],
      ),
    );
  }
}

// ─── Footer column helpers ────────────────────────────────────────────────────

class _CmsFooterColumn extends StatelessWidget {
  final String       title;
  final List<String> labels;
  final List<String> routes;
  final Color        primary;
  final bool         isRtl;

  const _CmsFooterColumn({
    required this.title,
    required this.labels,
    required this.primary,
    this.routes = const [],
    this.isRtl  = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(title,
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            style: GoogleFonts.cairo(
                fontSize:   13.sp,
                fontWeight: AppFontWeights.semiBold,
                color:      AppColors.text)),
        SizedBox(height: 6.h),
        ...List.generate(
          labels.length,
              (i) => _CmsFooterLink(
            label:   labels[i],
            primary: primary,
            route:   i < routes.length ? routes[i] : null,
            isRtl:   isRtl,
          ),
        ),
      ],
    );
  }
}

class _CmsFooterLink extends StatefulWidget {
  final String  label;
  final String? route;
  final Color   primary;
  final bool    isRtl;

  const _CmsFooterLink({
    required this.label,
    required this.primary,
    this.route,
    this.isRtl = false,
  });

  @override
  State<_CmsFooterLink> createState() => _CmsFooterLinkState();
}

class _CmsFooterLinkState extends State<_CmsFooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (widget.route != null && widget.route!.isNotEmpty)
            ? () => context.go(widget.route!)
            : null,
        child: Text(widget.label,
            textAlign: widget.isRtl ? TextAlign.right : TextAlign.left,
            style: GoogleFonts.cairo(
              fontSize:        12.sp,
              fontWeight:      AppFontWeights.regular,
              height:          2.0,
              color:           _hovered
                  ? widget.primary
                  : AppColors.secondaryBlack,
              decoration:      _hovered ? TextDecoration.underline : null,
              decorationColor: widget.primary,
            )),
      ),
    );
  }
}
