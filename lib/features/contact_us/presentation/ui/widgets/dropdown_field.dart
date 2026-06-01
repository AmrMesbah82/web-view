part of '../pages/contact_us_page.dart';

class _DropdownField extends StatelessWidget {
  final String  label, hint;
  final String? value;
  final List<Map<String, String>> items;
  final ValueChanged<String?> onChanged;
  final bool submitted, isRtl, isMobile;
  final Color primaryColor;
  final bool isSearchable;

  const _DropdownField({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.submitted,
    required this.isRtl,
    required this.isMobile,
    required this.primaryColor,
    this.isSearchable = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool showError = submitted && (value == null || value!.isEmpty);
    final String requiredMsg = _t(context,
        en: 'This field is required',
        ar: 'هذا الحقل مطلوب');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FormLabel(label: label),
        SizedBox(height: 3.h),
        if (isSearchable)
          _SearchableDropdown(
            hint:         hint,
            value:        value,
            items:        items,
            onChanged:    onChanged,
            isRtl:        isRtl,
            isMobile:     isMobile,
            primaryColor: primaryColor,
            hasError:     showError,
          )
        else
          CustomDropdownFormFieldInvMaster(
            selectedValue: value,
            items:         items,
            onChanged:     onChanged,
            primaryColor: primaryColor,
            width:         double.infinity,
            height:        32,
            borderRadius:  4,
            widthIcon:     16,
            heightIcon:    16,
            hint: Text(hint,
                style: StyleText.fontSize12Weight400
                    .copyWith(color: AppColors.secondaryBlack)),
          ),
        if (showError) ...[
          SizedBox(height: 2.h),
          Text(requiredMsg,
              style: StyleText.fontSize12Weight400
                  .copyWith(color: Colors.red, fontSize: 11.sp)),
        ],
        SizedBox(height: 2.h),
      ],
    );
  }
}

/// Searchable dropdown for country selection (long list)
