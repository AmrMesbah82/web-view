/// ******************* FILE INFO *******************
/// File Name: textfield_2.dart
/// Description: Input formatters + DEPRECATED SHIM. CustomValidatedTextFieldInv
///              now delegates rendering to the single shared text field in
///              lib/core/custom/2-custom_textfield.dart while keeping the
///              language/capitalize formatters and legacy API.
/// Created by: Amr Mesbah

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../custom/2-custom_textfield.dart' as custom;
import '../theme/appcolors.dart';
import '../theme/new_theme.dart';

class ArabicOnlyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final hasEnglishLetters = RegExp(r'[a-zA-Z]').hasMatch(newValue.text);
    if (hasEnglishLetters) {
      return oldValue;
    }
    return newValue;
  }
}

class EnglishOnlyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final hasArabicCharacters =
        RegExp(r'[؀-ۿ]').hasMatch(newValue.text);
    if (hasArabicCharacters) {
      return oldValue;
    }
    return newValue;
  }
}

class CapitalizeTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    String capitalizedText = newValue.text.split(' ').map((word) {
      if (word.isEmpty) return word;
      if (word.length == 1) return word.toUpperCase();
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');

    return TextEditingValue(
      text: capitalizedText,
      selection: TextSelection.collapsed(offset: capitalizedText.length),
    );
  }
}

class CustomValidatedTextFieldInv extends StatelessWidget {
  final String? label;
  final String hint;
  final TextEditingController controller;
  final double height;
  final double? width;
  final int maxLines;
  final bool enabled;

  /// IGNORED — no character counter in the shared design.
  final bool showCharCount;
  final ValueChanged<String>? onChanged;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final bool onlyDigits;
  final bool submitted;
  final TextStyle? textStyle;
  final Color? fillColor;
  final String? errorText;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;

  // SVG prefix icon parameters
  final String? prefixSvgAsset;
  final double? prefixIconWidth;
  final double? prefixIconHeight;
  final EdgeInsetsGeometry? prefixPadding;
  final VoidCallback? onPrefixTap;
  final BoxConstraints? prefixConstraints;

  final int? maxLength;

  final List<TextInputFormatter>? additionalInputFormatters;

  final bool autoCapitalize;

  const CustomValidatedTextFieldInv({
    super.key,
    this.label,
    required this.hint,
    required this.controller,
    this.height = 36,
    this.width,
    this.maxLines = 1,
    this.enabled = true,
    this.showCharCount = false,
    this.onChanged,
    this.textDirection = TextDirection.ltr,
    this.textAlign = TextAlign.start,
    this.onlyDigits = false,
    this.submitted = false,
    this.textStyle,
    this.fillColor,
    this.errorText,
    this.keyboardType,
    this.onTap,
    this.readOnly = false,
    this.prefixSvgAsset,
    this.prefixIconWidth,
    this.prefixIconHeight,
    this.prefixPadding,
    this.onPrefixTap,
    this.prefixConstraints,
    this.maxLength = 500,
    this.additionalInputFormatters,
    this.autoCapitalize = true,
  });

  TextInputType _getKeyboardType() {
    if (keyboardType != null) return keyboardType!;
    return onlyDigits ? TextInputType.number : TextInputType.text;
  }

  List<TextInputFormatter> _getInputFormatters() {
    final List<TextInputFormatter> formatters = [];
    if (maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(maxLength));
    }
    if (autoCapitalize && textDirection == TextDirection.ltr && !onlyDigits) {
      formatters.add(CapitalizeTextFormatter());
    }
    if (textDirection == TextDirection.rtl) {
      formatters.add(ArabicOnlyInputFormatter());
    } else if (textDirection == TextDirection.ltr && !onlyDigits) {
      formatters.add(EnglishOnlyInputFormatter());
    }
    if (onlyDigits) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    }
    if (additionalInputFormatters != null) {
      formatters.addAll(additionalInputFormatters!);
    }
    return formatters;
  }

  @override
  Widget build(BuildContext context) {
    final String text = controller.text;
    final bool isEmpty = text.trim().isEmpty;

    String? resolvedError;
    if (errorText != null && errorText!.isNotEmpty) {
      resolvedError = errorText;
    } else if (submitted && isEmpty) {
      resolvedError = textDirection == TextDirection.rtl
          ? 'هذا الحقل مطلوب'
          : 'This field is required.';
    }

    Widget? prefix;
    if (prefixSvgAsset != null && prefixSvgAsset!.isNotEmpty) {
      final svg = SvgPicture.asset(
        prefixSvgAsset!,
        width: (prefixIconWidth ?? 16).w,
        height: (prefixIconHeight ?? 16).h,
      );
      final padded = Padding(
        padding: prefixPadding ?? EdgeInsets.symmetric(horizontal: 8.w),
        child: svg,
      );
      prefix = onPrefixTap != null
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onPrefixTap,
              child: padded,
            )
          : padded;
    }

    final field = custom.CustomTextField(
      controller: controller,
      hint: hint,
      label: null,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      maxLength: maxLength ?? 500,
      width: width,
      height: height,
      textDirection: textDirection,
      textAlign: textAlign,
      onlyDigits: onlyDigits,
      keyboardType: _getKeyboardType(),
      onChanged: onChanged,
      fillColor: fillColor ?? AppColors.background,
      errorText: resolvedError,
      prefixIcon: prefix,
      contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      valueStyle: textStyle ??
          StyleText.fontSize12Weight400.copyWith(color: AppColors.text),
      hintStyle:
          StyleText.fontSize12Weight500.copyWith(color: const Color(0xFF9E9E9E)),
      inputFormatters: _getInputFormatters(),
    );

    if (label == null || label!.isEmpty) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          textDirection: textDirection,
          textAlign:
              textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left,
          style: StyleText.fontSize14Weight400.copyWith(color: AppColors.text),
        ),
        SizedBox(height: 6.h),
        field,
      ],
    );
  }
}
