part of '../pages/contact_us_page.dart';

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final bool   submitted, isMobile, isRtl;
  final String selectedCode, label;
  final ValueChanged<String?> onCodeChanged;
  final Color  primaryColor;

  const _PhoneField({
    required this.controller,
    required this.submitted,
    required this.selectedCode,
    required this.onCodeChanged,
    required this.isRtl,
    required this.label,
    required this.primaryColor,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final Widget dropdown = CustomDropdownFormFieldInvMaster(
      selectedValue: selectedCode,
      items:         _phoneCodes,
      primaryColor:  primaryColor,
      onChanged:     onCodeChanged,
      widthIcon:  16,
      heightIcon: 16,
      width:  isMobile ? 100.w : 110.w,
      height: 32,
      borderRadius: 4,
      hint: Text(
          isRtl ? 'أدخل رقم هاتفك' : 'Enter your number',
          style: StyleText.fontSize12Weight400
              .copyWith(color: AppColors.secondaryBlack)),
    );

    final Widget input = Expanded(
      child: CustomValidatedTextFieldMaster(
        hint:          isRtl ? 'أدخل رقم الهاتف' : 'Enter your number',
        controller:    controller,
        submitted:     submitted,
        primaryColor:  primaryColor,
        height:        32,
        onlyDigits:    true,
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        textAlign:     isRtl ? TextAlign.right   : TextAlign.left,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: StyleText.fontSize14Weight400
                .copyWith(color: AppColors.text, fontSize: 14.sp)),
        SizedBox(height: 3.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [dropdown, SizedBox(width: 6.w), input],
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// OFFICE CARDS
// ═══════════════════════════════════════════════════════════════════════════════
