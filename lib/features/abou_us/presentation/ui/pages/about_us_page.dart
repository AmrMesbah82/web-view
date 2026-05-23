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

// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:website_app/core/custom_svg.dart';

import '../../../../../core/main_widgets/app_footer.dart';
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

part '../widget/b_p.dart';
part '../widget/reveal_coordinator.dart';
part '../widget/reveal_coordinator_widget.dart';
part '../widget/reveal.dart';
part '../widget/svg_pulse_loader.dart';
part '../widget/about_page_view.dart';
part '../widget/about_header_desktop.dart';
part '../widget/about_header_mobile.dart';
part '../widget/about_body_desktop.dart';
part '../widget/desktop_top_tab_item.dart';
part '../widget/desktop_tab_item.dart';
part '../widget/desktop_right_panel.dart';
part '../widget/value_detail_panel.dart';
part '../widget/values_grid_desktop.dart';
part '../widget/value_grid_card.dart';
part '../widget/tablet_tab_item.dart';
part '../widget/tablet_content_panel.dart';
part '../widget/values_grid_tablet.dart';
part '../widget/about_body_mobile.dart';
part '../widget/mobile_top_tab_item.dart';
part '../widget/mobile_about_us_content.dart';
part '../widget/mobile_doc_panel.dart';
part '../widget/mobile_tab_data.dart';
part '../widget/mobile_accordion_item.dart';
part '../widget/values_grid_mobile.dart';

const Color _kDefaultGreen = Color(0xFF2D8C4E);
const Color _kGreenLight = Color(0xFFE8F5EE);
const Color _kSurface = Color(0xFFFFFFFF);
const Color _kDivider = Color(0xFFDDE8DD);
const Color _kLoaderNeutral = Color(0xFFF5F5F5);

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AboutCubit()..load()),
        BlocProvider(create: (_) => TermsCubit()..load()),
        BlocProvider(create: (_) => StrategyCubit()..load()),
      ],
      child: const _AboutPageView(),
      // test
    );
  }
}
