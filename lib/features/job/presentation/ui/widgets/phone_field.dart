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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BUG-132: same label widget / style / gap as CustomTextField, so the
        // phone box lines up with "Email" (was 7 px higher). No "*" (Figma).
        requiredLabel(
          label,
          style: StyleText.fontSize14Weight500.copyWith(color: AppColors.text),
        ),
        SizedBox(height: 6.h),
        LayoutBuilder(builder: (context, c) {
          // BUG-116 / BUG-133: the picker never takes more than 40 % of the
          // row (the number box was 37 px wide on phones).
          final double maxCode = 110.w < 80.0 ? 80.0 : 110.w;
          final double codeW =
              (c.maxWidth * 0.4).clamp(80.0, maxCode).toDouble();
          // BUG-147: the code reads "+20" (LTR, flag first) in Arabic too, and
          // the row follows the page direction like the Contact form.
          final Widget dropdown = Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: codeW,
              child: CustomDropdown<String>(
                value: selectedCode,
                items: _kCountryCodes
                    .map((c) => DropdownItem<String>(
                        value: c['key']!, label: c['value']!))
                    .toList(),
                onChanged: (v) => onCodeChanged(v),
                hint: isRtl ? 'الرمز' : 'Code',
                fillColor: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
                itemHeight: 36.h,
                // BUG-132: exactly the text-field height (36).
                fieldHeight: 36.h,
                triggerPadding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
                valueStyle:
                    StyleText.fontSize12Weight400.copyWith(color: AppColors.text),
                hintStyle: StyleText.fontSize12Weight400
                    .copyWith(color: AppColors.secondaryBlack),
              ),
            ),
          );

          final Widget input = Expanded(
            child: CustomTextField(
              hint: _t('Text Here', 'أدخل النص هنا', isRtl), // Figma
              controller: controller,
              submitted: submitted,
              height: 36,
              fillColor: Colors.white,
              onlyDigits: true,
              textDirection: TextDirection.ltr,
              textAlign: isRtl ? TextAlign.right : TextAlign.start,
            ),
          );

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dropdown,
              SizedBox(width: 8.w),
              input,
            ],
          );
        }),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  URL VALIDATED TEXT FIELD — FOR LINK-TYPE DOCUMENTS
// ═══════════════════════════════════════════════════════════════════════════════
