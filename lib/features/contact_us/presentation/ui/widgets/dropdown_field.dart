part of '../pages/contact_us_page.dart';

class _DropdownField extends StatelessWidget {
  final String  label, hint;
  final String? value;
  final List<Map<String, String>> items;
  final ValueChanged<String?> onChanged;
  final bool submitted, isRtl, isMobile;
  final Color primaryColor;
  final bool isSearchable;
  final bool required; // BUG-128

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
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool showError = submitted && (value == null || value!.isEmpty);
    final String requiredMsg = _t(context,
        en: 'This field is required.', // BUG-33: same wording as text fields
        ar: 'هذا الحقل مطلوب');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FormLabel(label: label, required: required),
        SizedBox(height: 6.h),
        // Every dropdown (incl. searchable Location) now uses the shared
        // custom dropdown widget.
        CustomDropdownFormFieldInvMaster(
          selectedValue: value,
          items:         items,
          onChanged:     onChanged,
          primaryColor:  primaryColor,
          width:         double.infinity,
          height:        36,
          borderRadius:  4,
          widthIcon:     16,
          heightIcon:    16,
          hint: Text(hint,
              style: StyleText.fontSize12Weight400
                  .copyWith(color: AppColors.secondaryBlack)),
          // BUG-131: red border + the same message style as text fields.
          errorText: showError ? requiredMsg : null,
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}

/// Searchable dropdown for country selection (long list)
