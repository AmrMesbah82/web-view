part of '../pages/job_apply_page.dart';

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final bool submitted, isRtl;
  final String selectedCode, label;
  final ValueChanged<String?> onCodeChanged;
  final Color primaryColor;

  const _PhoneField({
    required this.controller,
    required this.submitted,
    required this.selectedCode,
    required this.onCodeChanged,
    required this.isRtl,
    required this.label,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final Widget dropdown = CustomDropdownFormFieldInvMaster(
      selectedValue: selectedCode,
      items: _kCountryCodes,
      primaryColor: primaryColor,
      onChanged: onCodeChanged,
      dropdownColor: Colors.white,
      widthIcon: 16,
      heightIcon: 16,
      width: 110.w,
      height: 36,
      borderRadius: 4,
      hint: Text(
        isRtl ? 'الرمز' : 'Code',
        style: StyleText.fontSize12Weight400
            .copyWith(color: AppColors.secondaryBlack),
      ),
    );

    final Widget input = Expanded(
      child: CustomValidatedTextFieldMaster(
        hint: _t('Text Here', 'اكتب هنا', isRtl),
        controller: controller,
        submitted: submitted,
        primaryColor: primaryColor,
        height: 36,
        fillColor: Colors.white,
        onlyDigits: true,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.start,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: StyleText.fontSize14Weight400.copyWith(
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: [
            dropdown,
            SizedBox(width: 8.w),
            input,
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  URL VALIDATED TEXT FIELD — FOR LINK-TYPE DOCUMENTS
// ═══════════════════════════════════════════════════════════════════════════════
