// ******************* FILE INFO *******************
// File Name: app_footer.dart
// UPDATED: Footer background now reads from model.branding.headerFooterColor
// FIXED: _socialIcons / _socialIconsRaw now filter by l.visibility ✅
//        Toggling visibility OFF in admin hides the icon in the footer.
// Description: AppFooter driven by HomePageModel via HomeCmsCubit.
// Created by: Amr Mesbah

import 'package:flutter/material.dart';
import '../widgets/smart_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/home/data/models/home_model.dart';
import '../../features/home/presentation/controller/home_cubit.dart';
import '../../features/home/presentation/controller/home_state.dart';
import '../../features/home/presentation/controller/lang_state.dart';
import '../theme/app_wight.dart';
import '../theme/appcolors.dart';
import '../theme/new_theme.dart';



class _BP {
  static const double mobile = 768;
  static const double tablet = 1024;
}

const Color _kFallbackPrimary    = Color(0xFF008037);
const Color _kFallbackFooterBg   = Color(0xFFF5F5F5); // fallback if headerFooterColor is empty

List<FooterColumnModel> _syncedFooterColumns(HomePageModel model) {
  // Footer column titles/visibility follow the MAIN navbar items
  // (mainNavButtons / mainPage/main), NOT the Home page nav cards.
  final navByRoute = <String, NavButtonModel>{
    for (final btn in model.mainNavButtons)
      if (btn.route.isNotEmpty) btn.route: btn,
  };
  final List<FooterColumnModel> result = [];
  for (final col in model.footerColumns) {
    final nav = col.route.isNotEmpty ? navByRoute[col.route] : null;
    if (nav != null) {
      if (!nav.status) continue;
      result.add(col.copyWith(title: nav.name));
    } else {
      result.add(col);
    }
  }
  return result;
}

String _bi(BiText b, bool isRtl) {
  final v = isRtl ? b.ar : b.en;
  return v.isNotEmpty ? v : b.en;
}

Color _hexColor(String hex, Color fallback) {
  final clean = hex.replaceAll('#', '');
  if (clean.length == 6) {
    final value = int.tryParse('FF$clean', radix: 16);
    if (value != null) return Color(value);
  }
  return fallback;
}

String _staticCopyright(bool isRtl) {
  final year = DateTime.now().year.toString();
  return isRtl
      // BUG-49 / BUG-81: brand is "Bayanatz" (was "Bayanat", "ALL RIGHT
      // RESERVED"); the Arabic line now uses the same brand name as the site.
      ? '© $year بيانات زي. جميع الحقوق محفوظة.'
      : '© $year Bayanatz. All rights reserved.';
}

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCmsCubit, HomeCmsState>(
      builder: (context, state) {
        final HomePageModel model = switch (state) {
          HomeCmsLoaded(:final data) => data,
          HomeCmsSaved(:final data)  => data,
          _                          => HomePageModel.defaultModel,
        };

        final Color primary    = _hexColor(model.branding.primaryColor,      _kFallbackPrimary);
        // ✅ Footer background from CMS branding
        final Color footerBg   = _hexColor(model.branding.headerFooterColor, _kFallbackFooterBg);
        final List<FooterColumnModel> columns = _syncedFooterColumns(model);

        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, langState) {
            final bool isRtl = langState.isArabic;
            final double screenWidth = MediaQuery.of(context).size.width;

            Widget footer;
            if (screenWidth >= _BP.tablet) {
              footer = _FooterDesktop(
                model: model, columns: columns,
                primary: primary, footerBg: footerBg, isRtl: isRtl,
              );
            } else if (screenWidth >= _BP.mobile) {
              footer = _FooterTablet(
                model: model, columns: columns,
                primary: primary, footerBg: footerBg, isRtl: isRtl,
              );
            } else {
              footer = _FooterMobile(
                model: model, columns: columns,
                primary: primary, footerBg: footerBg, isRtl: isRtl,
              );
            }

            return Directionality(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: footer,
            );
          },
        );
      },
    );
  }
}

// ─── DESKTOP ──────────────────────────────────────────────────────────────────

class _FooterDesktop extends StatelessWidget {
  final HomePageModel model;
  final List<FooterColumnModel> columns;
  final Color primary;
  final Color footerBg; // ✅ from branding.headerFooterColor
  final bool isRtl;

  const _FooterDesktop({
    required this.model,
    required this.columns,
    required this.primary,
    required this.footerBg,
    required this.isRtl,
  });

  @override
  Widget build(BuildContext context) {
    final double contentW = (248.w * 4) + (8.w * 3);
    final double hPad =
    ((MediaQuery.of(context).size.width - contentW) / 2)
        .clamp(16.0, double.infinity);

    return Container(
      padding: EdgeInsets.all(22.sp),
      decoration: BoxDecoration(
        color: footerBg, // ✅ CMS-driven color
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(24.r),
          topEnd:   Radius.circular(24.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LogoBox(logoUrl: model.branding.logoUrl, primary: primary, size: 50.sp),
              SizedBox(width: 32.w),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: columns
                      .map((col) => _FooterColumnWidget(
                    column:     col,
                    titleColor: AppColors.text,
                    primary:    primary,
                    isRtl:      isRtl,
                  ))
                      .toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Divider(color: primary, thickness: 0.5),
          SizedBox(height: 14.h),
          // BUG-140: social icons centred on the PAGE (were ≈39 px left of
          // centre — centred in the space left over by the copyright).
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: _socialIcons(model.socialLinks, primary),
              ),
              PositionedDirectional(
                end: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(
                    _staticCopyright(isRtl),
                    style: StyleText.fontSize14Weight400.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w900,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── TABLET ───────────────────────────────────────────────────────────────────

class _FooterTablet extends StatelessWidget {
  final HomePageModel model;
  final List<FooterColumnModel> columns;
  final Color primary;
  final Color footerBg; // ✅ from branding.headerFooterColor
  final bool isRtl;

  const _FooterTablet({
    required this.model,
    required this.columns,
    required this.primary,
    required this.footerBg,
    required this.isRtl,
  });

  @override
  Widget build(BuildContext context) {
    final int mid  = (columns.length / 2).ceil();
    final row1     = columns.sublist(0, mid);
    final row2     = columns.sublist(mid);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(20.sp),
        decoration: BoxDecoration(
          color: footerBg, // ✅ CMS-driven color
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(18.r),
            topEnd:   Radius.circular(18.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LogoBox(logoUrl: model.branding.logoUrl, primary: primary, size: 32),
            SizedBox(height: 18.h),
            Wrap(
              spacing: 16.w, runSpacing: 16.h,
              children: row1
                  .map((col) => _FooterColumnWidget(
                column: col, titleColor: AppColors.text,
                primary: primary, isRtl: isRtl,
              ))
                  .toList(),
            ),
            if (row2.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Wrap(
                spacing: 16.w, runSpacing: 16.h,
                children: row2
                    .map((col) => _FooterColumnWidget(
                  column: col, titleColor: AppColors.text,
                  primary: primary, isRtl: isRtl,
                ))
                    .toList(),
              ),
            ],
            SizedBox(height: 20.h),
            Divider(color: primary, thickness: 1),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: _socialIcons(model.socialLinks, primary, gap: 8)),
                Flexible(
                  child: Text(
                    _staticCopyright(isRtl),
                    textAlign: TextAlign.end,
                    style: GoogleFonts.cairo(
                      fontSize:   10.sp,
                      fontWeight: FontWeight.w400,
                      color:      AppColors.secondaryText,
                    ),
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

// ─── MOBILE ───────────────────────────────────────────────────────────────────

class _FooterMobile extends StatelessWidget {
  final HomePageModel model;
  final List<FooterColumnModel> columns;
  final Color primary;
  final Color footerBg; // ✅ from branding.headerFooterColor
  final bool isRtl;

  const _FooterMobile({
    required this.model,
    required this.columns,
    required this.primary,
    required this.footerBg,
    required this.isRtl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(child: Divider(color: primary.withOpacity(0.5), thickness: 1)),
              SizedBox(width: 10.w),
              ..._socialIconsRaw(model.socialLinks, primary),
              SizedBox(width: 10.w),
              Expanded(child: Divider(color: primary.withOpacity(0.5), thickness: 1)),
            ],
          ),
          SizedBox(height: 16.h),
          // BUG-108: phones showed one random link ("Vision"). Figma (iPhone
          // view, Footer 7126:41848) has exactly one link under the social
          // icons: "Terms and Conditions" — so that is the one shown here.
          Builder(builder: (context) {
            FooterLabelModel? terms;
            for (final col in columns) {
              for (final l in col.labels) {
                final r = l.route.toLowerCase();
                final en = l.label.en.toLowerCase();
                if (r.contains('terms') || en.contains('terms')) {
                  terms ??= l;
                }
              }
            }
            final String label = terms != null
                ? _bi(terms.label, isRtl)
                : (isRtl ? 'الشروط والأحكام' : 'Terms and Conditions');
            final String route = (terms != null && terms.route.isNotEmpty)
                ? terms.route
                : '/about?tab=terms-and-conditions';
            return Center(
              child: _FooterLink(label: label, route: route, primary: primary),
            );
          }),
          SizedBox(height: 12.h),
          Text(
            _staticCopyright(isRtl),
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize:   10.sp,
              fontWeight: FontWeight.w400,
              color:      AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Footer Column ────────────────────────────────────────────────────────────

class _FooterColumnWidget extends StatefulWidget {
  final FooterColumnModel column;
  final Color titleColor;
  final Color primary;
  final bool isRtl;

  const _FooterColumnWidget({
    required this.column,
    required this.titleColor,
    required this.primary,
    required this.isRtl,
  });

  @override
  State<_FooterColumnWidget> createState() => _FooterColumnWidgetState();
}

class _FooterColumnWidgetState extends State<_FooterColumnWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final String title = _bi(widget.column.title, widget.isRtl);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit:  (_) => setState(() => _hovered = false),
          cursor: widget.column.route.isNotEmpty
              ? SystemMouseCursors.click
              : MouseCursor.defer,
          child: GestureDetector(
            onTap: widget.column.route.isNotEmpty
                ? () => _navigateTo(context, widget.column.route)
                : null,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: GoogleFonts.cairo(
                fontSize:   13.sp,
                fontWeight: _hovered ? FontWeight.w900 : AppFontWeights.semiBold,
                color: _hovered ? widget.primary : widget.titleColor,
              ),
              child: Text(title),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        ...widget.column.labels.map((lbl) => _FooterLink(
          label:   _bi(lbl.label, widget.isRtl),
          route:   lbl.route.isNotEmpty ? lbl.route : widget.column.route,
          primary: widget.primary,
        )),
      ],
    );
  }
}

// ─── Footer Link ──────────────────────────────────────────────────────────────

class _FooterLink extends StatefulWidget {
  final String  label;
  final String? route;
  final Color   primary;

  const _FooterLink({
    required this.label,
    required this.primary,
    this.route,
  });

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  void _handleTap(BuildContext context) {
    final route = widget.route;
    if (route == null || route.isEmpty) return;
    final uri = Uri.tryParse(route);
    if (uri == null) { context.go(route); return; }
    final String path        = uri.path;
    final String queryString = uri.query;
    final currentPath        = GoRouterState.of(context).uri.path;
    // BUG-117: push() kept the OLD address in the bar (Refresh/Share/Back
    // went to the wrong page). go() changes the URL; the pages read their
    // tab from the query, so the same page with a new ?tab= switches tab.
    if (queryString.isNotEmpty) {
      context.go('$path?$queryString');
    } else {
      if (currentPath == path) { context.push(path); } else { context.go(path); }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: widget.route != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: () => _handleTap(context),
        child: Text(
          widget.label,
          style: GoogleFonts.cairo(
            fontSize:        12.sp,
            fontWeight:      AppFontWeights.regular,
            height:          2.0,
            color:           _hovered ? widget.primary : AppColors.secondaryBlack,
            decoration:      _hovered ? TextDecoration.underline : null,
            decorationColor: widget.primary,
          ),
        ),
      ),
    );
  }
}

// ─── Logo box ─────────────────────────────────────────────────────────────────

class _LogoBox extends StatelessWidget {
  final String logoUrl;
  final Color  primary;
  final double size;

  const _LogoBox({
    required this.logoUrl,
    required this.primary,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:  size.w,
      height: size.h,
      child: logoUrl.isNotEmpty
          ? SmartNetworkImage( // BUG-68 / BUG-18
        logoUrl,
        width:   size.w,
        height:  size.h,
        fit:     BoxFit.contain,   // ← was BoxFit.cover (clips sides)
        fallback: Image.asset('assets/images/logo.jpg', fit: BoxFit.contain),
      )
          : Image.asset('assets/images/logo.jpg', fit: BoxFit.contain),
    );
  }
}

// ─── Social icon helpers ──────────────────────────────────────────────────────

/// ✅ filters by l.visibility — hidden icons won't appear in footer
List<Widget> _socialIcons(
    List<SocialLinkModel> links,
    Color borderColor, {
      double gap = 10,
    }) {
  return links
      .where((l) => l.visibility && (l.iconUrl.isNotEmpty || l.url.isNotEmpty))
      .map((l) => Padding(
    padding: EdgeInsetsDirectional.only(end: gap.w),
    child: _SocialIconWidget(link: l, borderColor: borderColor, size: 32),
  ))
      .toList();
}

/// ✅ same visibility filter for mobile
List<Widget> _socialIconsRaw(List<SocialLinkModel> links, Color borderColor) {
  return links
      .where((l) => l.visibility && (l.iconUrl.isNotEmpty || l.url.isNotEmpty))
      .expand((l) => [
    _SocialIconWidget(link: l, borderColor: borderColor, size: 32, raw: true),
    SizedBox(width: 8.w),
  ])
      .toList();
}

class _SocialIconWidget extends StatelessWidget {
  final SocialLinkModel link;
  final Color           borderColor;
  final double          size;
  final bool            raw;

  const _SocialIconWidget({
    required this.link,
    required this.borderColor,
    required this.size,
    this.raw = false,
  });

  double get _ic => raw ? size * 0.47 : (size * 0.47).w;

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget = link.iconUrl.isNotEmpty
        ? SvgPicture.network(
      link.iconUrl,
      width:  20.w,
      height: 20.w,
      fit:    BoxFit.contain,
      // Show the uploaded logo in its own colors — tinting it with srcIn
      // flattens a multi-color logo into a solid brand-color blob.
      placeholderBuilder: (_) => SizedBox(width: _ic, height: _ic),
    )
        : Icon(Icons.link, size: _ic, color: borderColor);

    final box = Container(
      width:  40.w,
      height: 40.w,
      decoration: BoxDecoration(
        border:       Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(raw ? 8 : 8.r),
      ),
      child: Center(child: iconWidget),
    );

    // BUG-138: icon-only buttons need a name for screen readers.
    final String name = _socialName(link.url);
    return link.url.isNotEmpty
        ? Semantics(
      button: true,
      link: true,
      label: name,
      child: GestureDetector(
      onTap: () async {
        String rawUrl = link.url.trim();
        if (!rawUrl.startsWith('http://') && !rawUrl.startsWith('https://')) {
          rawUrl = 'https://$rawUrl';
        }

        final uri = Uri.tryParse(rawUrl);
        if (uri == null || !uri.hasAuthority) return; // ✅ guard empty/invalid URLs

        final canLaunch = await canLaunchUrl(uri);
        if (!canLaunch) return;

        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // ✅ works reliably on web
          webOnlyWindowName: '_blank',
        );
      },
      child: MouseRegion(cursor: SystemMouseCursors.click, child: box),
    ))
        : box;
  }
}

/// BUG-138: "Facebook", "LinkedIn", … from the link's address.
String _socialName(String url) {
  final u = url.toLowerCase();
  const names = {
    'facebook': 'Facebook', 'fb.com': 'Facebook', 'instagram': 'Instagram',
    'linkedin': 'LinkedIn', 'twitter': 'X (Twitter)', 'x.com': 'X (Twitter)',
    'youtube': 'YouTube', 'youtu.be': 'YouTube', 'tiktok': 'TikTok',
    'snapchat': 'Snapchat', 'whatsapp': 'WhatsApp', 'wa.me': 'WhatsApp',
    'telegram': 't.me', 'github': 'GitHub', 'behance': 'Behance',
  };
  for (final e in names.entries) {
    if (u.contains(e.key)) return e.value == 't.me' ? 'Telegram' : e.value;
  }
  return 'Social link';
}

void _navigateTo(BuildContext context, String route) {
  final uri = Uri.tryParse(route);
  if (uri == null) { context.go(route); return; }
  if (uri.query.isNotEmpty) {
    context.go('${uri.path}?${uri.query}'); // BUG-117: URL must change
  } else {
    context.go(uri.path);
  }
}