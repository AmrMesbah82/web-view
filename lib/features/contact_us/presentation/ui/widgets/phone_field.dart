part of '../pages/contact_us_page.dart';

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final bool   submitted, isMobile, isRtl;
  final String selectedCode, label;
  final ValueChanged<String?> onCodeChanged;
  final Color  primaryColor;
  /// BUG-102: "Please enter a valid mobile number."
  final String? errorText;

  const _PhoneField({
    required this.controller,
    required this.submitted,
    required this.selectedCode,
    required this.onCodeChanged,
    required this.isRtl,
    required this.label,
    required this.primaryColor,
    this.isMobile = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BUG-128: required marker. BUG-132: same 6.h label gap as the other
        // fields (was 3.h, so the phone box sat 3 px higher than Email).
        _FormLabel(label: label),
        SizedBox(height: 6.h),
        LayoutBuilder(builder: (context, c) {
          // BUG-133: on tablets the fixed 110.w picker left the number box
          // only 86 px ("Enter y…"). The picker now takes at most 40 % of the
          // row so the number field is never narrower than the picker.
          final double maxCode = isMobile ? 100.w : 110.w;
          final double codeW = (c.maxWidth * 0.4)
              .clamp(80.0, maxCode < 80.0 ? 80.0 : maxCode)
              .toDouble();
          // BUG-147: the code is always shown LTR ("+20", flag first).
          final Widget dropdown = Directionality(
            textDirection: TextDirection.ltr,
            child: CustomDropdownFormFieldInvMaster(
              selectedValue: selectedCode,
              items:         _phoneCodes,
              primaryColor:  primaryColor,
              onChanged:     onCodeChanged,
              widthIcon:  16,
              heightIcon: 16,
              width:  codeW,
              height: 36,
              borderRadius: 4,
              hint: Text(
                  isRtl ? 'الرمز' : 'Code',
                  style: StyleText.fontSize12Weight400
                      .copyWith(color: AppColors.secondaryBlack)),
            ),
          );

          final Widget input = Expanded(
            child: CustomValidatedTextFieldMaster(
              hint:          isRtl ? 'أدخل النص هنا' : 'Text Here', // Figma
              controller:    controller,
              submitted:     submitted,
              errorText:     errorText,
              primaryColor:  primaryColor,
              height:        36,
              onlyDigits:    true,
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              textAlign:     isRtl ? TextAlign.right   : TextAlign.left,
            ),
          );

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [dropdown, SizedBox(width: 6.w), input],
          );
        }),
        SizedBox(height: 2.h),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// OFFICE CARDS
// ═══════════════════════════════════════════════════════════════════════════════
