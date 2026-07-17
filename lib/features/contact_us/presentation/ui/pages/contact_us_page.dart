// ******************* FILE INFO *******************
// File Name: contact_us_page.dart  (public-facing website page)
// Created by: Amr Mesbah
// UPDATED: backgroundColor now dynamic from CMS branding.backgroundColor ✅
// Updated: All sizes normalized to match main.dart ScreenUtil design sizes:
//          Desktop (≥1366) → 1366×768, Tablet (768–1365) → 1024×768,
//          Mobile (<768)   → 375×812
//          Full AR / EN bilingual support.
//          PRIMARY COLOR: Fully dynamic from HomeCmsCubit branding.
//          NEW: Twilio OTP verification before form submission.
//          NEW: Office cards open mapLink in Google Maps on tap ✅
//          NEW: Form fields updated — firstName/lastName split, preferredLanguage
//               radio, location country picker, entityName, entityType, entitySize
//          NEW: SendGrid sends 2 emails (client thank-you + sales notification)
//          NEW: "Other" language radio option shows custom text field ✅
// FIX: _SvgPulseLoader backgroundColor now uses branding.backgroundColor from
//      Firebase. Shows neutral background before Firebase responds, then
//      switches to real backgroundColor once HomeCmsLoaded fires.
// FIX: Desktop layout now fully responsive — no overflow when window resized.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:website_app/core/constant.dart';
import 'package:website_app/core/widgets/button.dart';
import 'package:website_app/core/widgets/circle_progress.dart';
import 'package:website_app/core/widgets/custom_dropdown.dart';
import 'package:website_app/core/widgets/navigator.dart';
import 'package:website_app/core/widgets/textfield.dart';
import 'package:website_app/core/custom/2-custom_textfield.dart' as custom;

import '../../../../../core/main_widgets/app_footer.dart';
import '../../../../../core/main_widgets/app_navbar.dart';
import '../../../../../core/theme/appcolors.dart';
import '../../../../../core/theme/new_theme.dart';
import '../../../../home/presentation/controller/home_cubit.dart';
import '../../../../home/presentation/controller/home_state.dart';
import '../../../../home/presentation/controller/lang_state.dart';
import '../../../data/models/contact_us_model_location.dart';
import '../../../data/models/contact_us_model.dart';
import '../../controller/contact_us_otp_cubit.dart';
import '../../controller/contact_us_otp_state.dart';
import '../../controller/contact_us_location_cubit.dart';
import '../../controller/contact_us_location_state.dart';
import '../../controller/contact_us_cubit.dart';
import '../../controller/contact_us_state.dart';

part '../widgets/contact_helpers.dart';
part '../widgets/reveal_coordinator.dart';
part '../widgets/reveal_coordinator_widget.dart';
part '../widgets/reveal.dart';
part '../widgets/svg_pulse_loader.dart';
part '../widgets/contact_page_view.dart';
part '../widgets/otp_dialog.dart';
part '../widgets/desktop_body.dart';
part '../widgets/mobile_body.dart';
part '../widgets/mobile_info_card.dart';
part '../widgets/left_info_card.dart';
part '../widgets/form_card.dart';
part '../widgets/form_label.dart';
part '../widgets/dropdown_field.dart';
part '../widgets/searchable_dropdown.dart';
part '../widgets/phone_field.dart';
part '../widgets/office_card.dart';
part '../widgets/office_card_mobile.dart';
part '../widgets/social_row.dart';
part '../widgets/social_icon_scaled.dart';
part '../widgets/social_icon_raw.dart';
part '../widgets/success_dialog.dart';

// Fallback colors
const Color _kDefaultGreen  = Color(0xFF2D8C4E);
const Color _kGreenLight    = Color(0xFFE8F5EE);
const Color _kDivider       = Color(0xFFDDE8DD);
// Neutral loader background shown before Firebase responds
const Color _kLoaderNeutral = Color(0xFFF5F5F5);

// Sentinel value used to identify "Other" language selection
const String _kOtherLanguage = 'other';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ContactCubit()),
        BlocProvider(create: (_) => ContactUsCmsCubit()..load()),
        BlocProvider(create: (_) => ContactOtpCubit()),
      ],
      child: const _ContactPageView(),
    );
  }
}
