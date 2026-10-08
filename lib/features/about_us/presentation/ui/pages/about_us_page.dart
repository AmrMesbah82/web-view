// ******************* FILE INFO *******************
// File Name: about_us_page.dart
// FIX: Values tab left panel no longer shows expanded description (was causing
//      huge padding vs Vision/Mission). All 3 sub-tabs now behave identically
//      in the left panel — icon + label only, no description shown there. ✅
// FIX: _DesktopTabItem selectedDesc is now only shown for Vision/Mission,
//      never for Values tab. ✅
// FIX: colorFilter removed from all value/section icon _netImg calls so real
//      uploaded images render correctly. ✅
// UPDATED: Added Strategic House images (EN and AR) to Tab 1 "Our Strategy"
// UPDATED: All device sizes (Desktop, Tablet, Mobile) now display both Strategic House images
// UPDATED: Responsive design for all screen sizes
// UPDATED: AboutPage now accepts optional pre-built cubits. The live site
//          passes nothing and behaves exactly as before — the page creates and
//          loads its own from Firestore. The ADMIN preview passes in cubits
//          already seeded with the draft being edited, so the same page code
//          renders unsaved work without a single network read.

// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:website_app/core/custom_svg.dart';
import 'package:website_app/core/widgets/format_heper.dart';

import '../../../../../core/main_widgets/app_footer.dart';
import '../../../../../core/widgets/scroll_with_footer.dart';
import '../../../../../core/main_widgets/app_navbar.dart';
import '../../../../../core/theme/appcolors.dart';
import '../../../../../core/theme/new_theme.dart';
import '../../../../careers/data/models/careers_section_model.dart';
import '../../../../home/presentation/controller/home_cubit.dart';
import '../../../../home/presentation/controller/home_state.dart';
import '../../../../home/presentation/controller/lang_state.dart';
import '../../../data/models/about_us_model.dart';
import '../../controller/about_us_cubit.dart';
import '../../controller/about_us_state.dart';

part '../widgets/about_helpers.dart';
part '../widgets/reveal_coordinator.dart';
part '../widgets/reveal_coordinator_widget.dart';
part '../widgets/reveal.dart';
part '../widgets/svg_pulse_loader.dart';
part '../widgets/about_page_view.dart';
part '../widgets/about_header_desktop.dart';
part '../widgets/about_header_mobile.dart';
part '../widgets/about_body_desktop.dart';
part '../widgets/desktop_top_tab_item.dart';
part '../widgets/desktop_tab_item.dart';
part '../widgets/desktop_right_panel.dart';
part '../widgets/value_detail_panel.dart';
part '../widgets/values_grid_desktop.dart';
part '../widgets/value_grid_card.dart';
part '../widgets/tablet_tab_item.dart';
part '../widgets/tablet_content_panel.dart';
part '../widgets/values_grid_tablet.dart';
part '../widgets/about_body_mobile.dart';
part '../widgets/mobile_top_tab_item.dart';
part '../widgets/mobile_about_us_content.dart';
part '../widgets/mobile_doc_panel.dart';
part '../widgets/mobile_tab_data.dart';
part '../widgets/mobile_accordion_item.dart';
part '../widgets/values_grid_mobile.dart';

// BUG-65: used from a part file — referenced here so an IDE
// "Optimize Imports" can't drop the import.
typedef _ScrollWithFooter = ScrollWithFooter;

const Color _kDefaultGreen = Color(0xFF2D8C4E);
const Color _kGreenLight = Color(0xFFE8F5EE);
const Color _kSurface = Color(0xFFFFFFFF);
const Color _kDivider = Color(0xFFDDE8DD);
const Color _kLoaderNeutral = Color(0xFFF5F5F5);

class AboutPage extends StatelessWidget {
  const AboutPage({
    super.key,
    this.aboutCubit,
    this.termsCubit,
    this.strategyCubit,
    this.initialTopTab,
    this.initialSubTab,
    this.showFooter = true,
  });

  /// Optional pre-built cubits.
  ///
  /// Leave them null — as the live site does — and the page creates its own and
  /// loads them from Firestore, exactly as before.
  ///
  /// The admin preview passes cubits already holding the draft being edited.
  /// They are provided with `.value`, so nothing calls `load()` on them and no
  /// network read happens; the page renders unsaved work through the very same
  /// widgets visitors see.
  final AboutCubit? aboutCubit;
  final TermsCubit? termsCubit;
  final StrategyCubit? strategyCubit;

  /// Which tab to open on, when the caller already knows.
  ///
  /// The live site leaves these null and keeps reading `?tab=` from the URL, as
  /// before. The admin previews pass them so the Strategy screen opens on the
  /// Our Strategy tab and the Terms screen on Terms / Privacy — their preview
  /// frame does not take taps, so the tab cannot be picked by hand there.
  ///
  /// 0 = About Us · 1 = Our Strategy · 2 = Terms and Conditions ·
  /// 3 = Privacy Policy. [initialSubTab] picks Vision / Mission / Values inside
  /// the About Us tab.
  final int? initialTopTab;
  final int? initialSubTab;

  /// Whether the site footer is drawn under the page.
  ///
  /// The live site always shows it. The admin previews hide it — the preview
  /// frame is a fixed-height viewport, and the footer takes room the page's own
  /// content needs; the admin screen carries its own actions below the frame.
  final bool showFooter;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        aboutCubit == null
            ? BlocProvider<AboutCubit>(create: (_) => AboutCubit()..load())
            : BlocProvider<AboutCubit>.value(value: aboutCubit!),
        termsCubit == null
            ? BlocProvider<TermsCubit>(create: (_) => TermsCubit()..load())
            : BlocProvider<TermsCubit>.value(value: termsCubit!),
        strategyCubit == null
            ? BlocProvider<StrategyCubit>(create: (_) => StrategyCubit()..load())
            : BlocProvider<StrategyCubit>.value(value: strategyCubit!),
      ],
      child: _AboutPageView(
        initialTopTab: initialTopTab,
        initialSubTab: initialSubTab,
        showFooter:    showFooter,
      ),
    );
  }
}
