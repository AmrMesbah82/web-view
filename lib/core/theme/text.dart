// Date: 29/9/2024
// By: Youssef Ashraf, Nada Mohammed, Mohammed Ashraf
// Last update: 15/3/2026
// Objectives: This file is responsible for providing the app text styles that are used in the app.
// FIX: Removed _withFontFamily wrapper — it was overwriting GoogleFonts internal font key
//      with plain 'Cairo' string which Flutter cannot resolve, causing Arabic fallback font.
//      Cairo font natively supports both Arabic and English so no wrapper is needed.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


import 'app_wight.dart';
import 'appcolors.dart';

abstract class AppTextStyles {

  // ── Dynamic font support ───────────────────────────────────────────────────
  // Fonts chosen in the admin (English / Arabic) are written to GetStorage
  // ('font' / 'font_arabic'). Every text style below is wrapped in _dyn(), which
  // re-applies the active family (based on the current locale) via
  // GoogleFonts.getFont so the selected font is actually downloaded/loaded.
  static final GetStorage _fontBox = GetStorage();

  static String get _activeFontFamily {
    final isArabic = Get.locale?.languageCode == 'ar';
    final raw = isArabic ? _fontBox.read('font_arabic') : _fontBox.read('font');
    return (raw is String && raw.isNotEmpty) ? raw : 'Cairo';
  }

  static TextStyle _dyn(TextStyle base) {
    try {
      return GoogleFonts.getFont(_activeFontFamily, textStyle: base);
    } catch (_) {
      return base;
    }
  }


  // --------------------- REGULAR Text Styles - w400 ---------------------

  static TextStyle get font10LightGreyRegularCairo => _dyn(GoogleFonts.cairo(
    color: AppColors.lightGrey,
    fontSize: 10.sp,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font26BlackMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 26.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font20BlackCairoSemiBold => _dyn(GoogleFonts.cairo(
    fontSize: 20.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get redFont12CairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.red,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font16SecondaryBlackSemiBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font10RegularMonserrat => _dyn(GoogleFonts.cairo(
    fontSize: 10.sp,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font10BlackCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 10.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font10FullBlackCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 10.sp,
    color: AppColors.fullBlack,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font16FullBlackCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.fullBlack,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font10BlackRegularInter => _dyn(GoogleFonts.inter(
    color: AppColors.text,
    fontSize: 10.sp,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font12PrimaryColorRegularCairo => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.primary,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font12LightGreyRegularCairo => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.lightGrey,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font12SecondaryBlackMontserratRegular => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font12MediumGreyRegularCairo => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.mediumGrey,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font15MediumInverseBaseRegularCairo => _dyn(GoogleFonts.cairo(
    fontSize: 15.sp,
    color: AppColors.inverseBase,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font12RedRegularCairo => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.red,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font12BlackCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font12BlackCairoBold => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.bold,
  ));

  static TextStyle get font12BlackCairoSemiBold => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font12FullBlackCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.fullBlack,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font11FullBlackCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 11.sp,
    color: AppColors.fullBlack,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font12FullBlackCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.fullBlack,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font12SecondaryBlackCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font10SecondaryBlackCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 10.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font12BlueCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.blue,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font14BlackRegularCairo => _dyn(GoogleFonts.cairo(
    fontSize: 14.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font12darkWhiteShadowRegular => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.darkWhiteShadow,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font16inverseBaseRegularCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.inverseBase,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font14BlackCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 14.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font14FullBlackCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 14.sp,
    color: AppColors.fullBlack,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font14FullBlackCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 14.sp,
    color: AppColors.fullBlack,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font14SecondaryBlackCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 14.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font14SecondaryBlackCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 14.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16LightGreyRegularCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.lightGrey,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font16PrimaryColorRegularCairo => _dyn(GoogleFonts.cairo(
    color: AppColors.primary,
    fontSize: 16.sp,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font16BlackRegularCairo => _dyn(GoogleFonts.cairo(
    color: AppColors.text,
    fontSize: 16.sp,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font16WhiteRegularCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: Colors.white,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font18SecondaryBlackRegularCairo => _dyn(GoogleFonts.cairo(
    fontSize: 18.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font19WhiteRegularCairo => _dyn(GoogleFonts.cairo(
    fontSize: 19.sp,
    color: Colors.white,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font19BlackRegularCairo => _dyn(GoogleFonts.cairo(
    color: AppColors.text,
    fontSize: 19.sp,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font19BlackMediumCairo => _dyn(GoogleFonts.cairo(
    color: AppColors.text,
    fontSize: 19.sp,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font19LightGreyRegularCairo => _dyn(GoogleFonts.cairo(
    fontSize: 19.sp,
    color: AppColors.lightGrey,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font20BlackRegularCairo => _dyn(GoogleFonts.cairo(
    color: AppColors.text,
    fontSize: 20.sp,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font23BlackRegularCairo => _dyn(GoogleFonts.cairo(
    color: AppColors.text,
    fontSize: 23.sp,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font12SpanTextCairoRegular => _dyn(GoogleFonts.cairo(
    color: AppColors.spanText,
    fontSize: 12.sp,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font11SpanTextCairoRegular => _dyn(GoogleFonts.cairo(
    color: AppColors.spanText,
    fontSize: 11.sp,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font14SpanTextCairoMedium => _dyn(GoogleFonts.cairo(
    color: AppColors.spanText,
    fontSize: 12.sp,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font10SpanTextCairoRegular => _dyn(GoogleFonts.cairo(
    color: AppColors.spanText,
    fontSize: 10.sp,
    fontWeight: AppFontWeights.regular,
  ));

  // --------------------- MEDIUM Text Styles - w500 ---------------------

  static TextStyle get font8SecondaryBlackCairo => _dyn(GoogleFonts.cairo(
    fontSize: 8.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font8SecondaryBlackRegularCairo => _dyn(GoogleFonts.cairo(
    fontSize: 8.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font10BlueCairo => _dyn(GoogleFonts.cairo(
    fontSize: 10.sp,
    color: AppColors.blue,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font12PrimaryColorMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.primary,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font12BlackMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font10BlackCairoMediam => _dyn(GoogleFonts.cairo(
    fontSize: 10.sp,
    color: const Color(0xff797979),
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font12InputColorCairo => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.inputColor,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font12BlackCairo => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font12LighterGreyMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.lighterGrey,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font10LighterGreyMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 10.sp,
    color: AppColors.lighterGrey,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font12ButtonCairo => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.textButton,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font12SecondaryBlackCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16TextMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font12secondaryPrimaryCairo => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.secondaryPrimary,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font12WhiteCairo => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.background,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font13SecondaryBlackCairo => _dyn(GoogleFonts.cairo(
    fontSize: 13.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font12SecondaryBlackMediumCairo => _dyn(GoogleFonts.cairo(
    color: AppColors.secondaryBlack,
    fontSize: 12.sp,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font14SecondaryBlackCairo => _dyn(GoogleFonts.cairo(
    fontSize: 14.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font14BlackCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 14.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16BlackCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font14BlueCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 14.sp,
    color: AppColors.lightBlue,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16whiteCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.white,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font14TextButtonCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 14.sp,
    color: AppColors.textButton,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16MediumMonserrat => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16BlackCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.inputColor,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16SecondaryPrimaryCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.secondaryPrimary,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16SecondaryBlackCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16SecondaryYelloCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.secondaryPrimary,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16BlackMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16ButtonMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.textButton,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16MediumDarkGreyCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.darkGrey,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16MediumInverseBaseCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.inverseBase,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16MediumSecondaryTextCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.secondaryText,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font12RegularSecondaryTextCairo => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.secondaryText,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font14MediumSecondaryTextCairo => _dyn(GoogleFonts.cairo(
    fontSize: 14.sp,
    color: AppColors.secondaryText,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font20MediumSecondaryTextCairo => _dyn(GoogleFonts.cairo(
    fontSize: 20.sp,
    color: AppColors.secondaryText,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16LightGreyMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.lightGrey,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16InputColorCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.inputColor,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16SecondaryBlackCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font16PrimaryColorMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.primary,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font18BlackMediumCairo => _dyn(GoogleFonts.cairo(
    color: AppColors.text,
    fontSize: 18.sp,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font18ButtonMediumCairo => _dyn(GoogleFonts.cairo(
    color: AppColors.textButton,
    fontSize: 18.sp,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font18SecondaryPrimaryCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 18.sp,
    color: AppColors.secondaryPrimary,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font18BlackCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 18.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font18BlackCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 18.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font18secondaryPrimaryMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 18.sp,
    color: AppColors.secondaryPrimary,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font18SecondaryBlackCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 18.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font18SecondaryBlackCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 18.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font19DarkGreyMediumCairo => _dyn(GoogleFonts.cairo(
    color: AppColors.darkGrey,
    fontSize: 19.sp,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font20BlackMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 20.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font20BlackCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 20.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font23MediumDarkGreyCairo => _dyn(GoogleFonts.cairo(
    fontSize: 23.sp,
    color: AppColors.darkGrey,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font23LightGreyMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 23.sp,
    color: AppColors.lightGrey,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font23MediumBlackCairo => _dyn(GoogleFonts.cairo(
    fontSize: 23.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font28BlackMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 28.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font45BlackMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 45.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font36BlackMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 36.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font21BlackMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 21.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font36MediumBlackCairo => _dyn(GoogleFonts.cairo(
    fontSize: 36.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font24MediumBlackCairo => _dyn(GoogleFonts.cairo(
    fontSize: 24.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  // --------------------- SEMI-BOLD Text Styles - w600 -------------------

  static TextStyle get font10WhiteSemiBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 10.sp,
    color: Colors.white,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font12GrayCairo => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.grey,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font12DarkGrayCairo => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.darkGrey,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font14DarkGrayCairo => _dyn(GoogleFonts.cairo(
    fontSize: 14.sp,
    color: AppColors.darkGrey,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font14BlackCairo => _dyn(GoogleFonts.cairo(
    fontSize: 14.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font18BlackSemiBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 18.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font20BlackSemiBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 20.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font20SecondaryBlackSemiBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 20.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font26BlackSemiBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 26.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font28BlackSemiBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 28.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font14BlackSemiBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 14.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font16BlackSemiBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font16SecondaryPrimarySemiBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.secondaryPrimary,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font19SecondaryPrimarySemiBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 19.sp,
    color: AppColors.secondaryPrimary,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font14MontserratNumber => _dyn(GoogleFonts.montserrat(
    fontSize: 14.sp,
    color: const Color(0xB31A1A1A),
    fontWeight: AppFontWeights.semiBold,
  ));

  // --------------------- BOLD Text Styles - w700 -----------------------

  static TextStyle get font12LightGreyBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 12.sp,
    color: AppColors.lightGrey,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font16WhiteBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: Colors.white,
    fontWeight: AppFontWeights.bold,
  ));

  static TextStyle get font16PrimaryColorBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 16.sp,
    color: AppColors.primary,
    fontWeight: AppFontWeights.bold,
  ));

  static TextStyle get font14PrimaryColorSemiBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 14.sp,
    color: AppColors.primary,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font23PrimaryColorBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 23.sp,
    color: AppColors.primary,
    fontWeight: AppFontWeights.bold,
  ));

  static TextStyle get font23WhiteBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 23.sp,
    color: Colors.white,
    fontWeight: AppFontWeights.bold,
  ));

  static TextStyle get font20BlackCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 20.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font15BlackCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 15.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font25BlackCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 25.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font26BlackCairoRegular => _dyn(GoogleFonts.cairo(
    fontSize: 26.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.regular,
  ));

  static TextStyle get font23BlackSemiBoldCairo => _dyn(GoogleFonts.cairo(
    color: AppColors.text,
    fontSize: 23.sp,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font30BlackCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 30.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font30BlackCairoSemiBold => _dyn(GoogleFonts.cairo(
    fontSize: 30.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font35BlackCairoSemiBold => _dyn(GoogleFonts.cairo(
    fontSize: 35.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font22BlackCairoMedium => _dyn(GoogleFonts.cairo(
    fontSize: 22.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font22BlackCairoSemiBold => _dyn(GoogleFonts.cairo(
    fontSize: 22.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font20SecondaryBlackMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 20.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font30SecondaryBlackMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 30.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font25SecondaryBlackMediumCairo => _dyn(GoogleFonts.cairo(
    fontSize: 25.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.medium,
  ));

  static TextStyle get font25SecondaryBlackSemiBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 25.sp,
    color: AppColors.secondaryBlack,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font30BlackSemiBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 30.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font25BlackSemiBoldCairo => _dyn(GoogleFonts.cairo(
    fontSize: 25.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.semiBold,
  ));

  static TextStyle get font26BlackCairo => _dyn(GoogleFonts.cairo(
    fontSize: 26.sp,
    color: AppColors.text,
    fontWeight: AppFontWeights.semiBold,
  ));
}