part of '../pages/contact_us_page.dart';

class _FormCard extends StatelessWidget {
  final TextEditingController firstNameCtrl, lastNameCtrl, emailCtrl,
      phoneCtrl, entityNameCtrl, subjectCtrl, messageCtrl,
      otherLanguageCtrl; // ← NEW
  final bool   submitted, isMobile, isRtl;
  final String phoneCode, preferredLanguage;
  final String? selectedLocation, selectedEntityType, selectedEntitySize;
  final Color  primaryColor;
  final ValueChanged<String?>  onCodeChanged;
  final ValueChanged<String>   onLanguageChanged;
  final ValueChanged<String?>  onLocationChanged;
  final ValueChanged<String?>  onEntityTypeChanged;
  final ValueChanged<String?>  onEntitySizeChanged;
  final VoidCallback           onSend;

  const _FormCard({
    required this.firstNameCtrl,    required this.lastNameCtrl,
    required this.emailCtrl,        required this.phoneCtrl,
    required this.entityNameCtrl,   required this.subjectCtrl,
    required this.messageCtrl,      required this.otherLanguageCtrl,
    required this.submitted,
    required this.phoneCode,        required this.preferredLanguage,
    required this.selectedLocation, required this.selectedEntityType,
    required this.selectedEntitySize,
    required this.onCodeChanged,    required this.onLanguageChanged,
    required this.onLocationChanged, required this.onEntityTypeChanged,
    required this.onEntitySizeChanged,
    required this.onSend,           required this.isRtl,
    required this.primaryColor,     this.isMobile = false,
  });

  // ── Helper: builds one custom radio dot + label widget ──
  Widget _radioItem({
    required String lang,
    required String displayLabel,
    required String preferredLanguage,
    required Color  primaryColor,
    required bool   isMobile,
    required ValueChanged<String> onLanguageChanged,
  }) {
    final bool selected = preferredLanguage == lang;
    return GestureDetector(
      onTap: () => onLanguageChanged(lang),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width:  isMobile ? 18 : 18.w,
              height: isMobile ? 18 : 18.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? primaryColor : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                child: Container(
                  width:  isMobile ? 10 : 10.w,
                  height: isMobile ? 10 : 10.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                  ),
                ),
              )
                  : null,
            ),
            SizedBox(width: 6.w),
            Text(
              displayLabel,
              style: StyleText.fontSize13Weight400.copyWith(
                color:    selected ? Colors.black87 : Colors.black54,
                fontSize: isMobile ? 12.sp : 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double rad = isMobile ? 12 : 12.r;

    final String title             = _t(context, en: 'GET IN TOUCH',       ar: 'تواصل معنا');
    final String prefLangLabel     = _t(context, en: 'Preferred Language', ar: 'اللغة المفضلة');
    final String firstNameLabel    = _t(context, en: 'First Name',         ar: 'الاسم الأول');
    final String lastNameLabel     = _t(context, en: 'Last Name',          ar: 'اسم العائلة');
    final String emailLabel        = _t(context, en: 'Email',              ar: 'البريد الإلكتروني');
    final String phoneLabel        = _t(context, en: 'Phone Number',       ar: 'رقم الهاتف');
    final String locationLabel     = _t(context, en: 'Location',           ar: 'الموقع');
    final String entityNameLabel   = _t(context, en: "Entity's Name",      ar: 'اسم الجهة');
    final String entityTypeLabel   = _t(context, en: "Entity's Type",      ar: 'نوع الجهة');
    final String entitySizeLabel   = _t(context, en: "Entity's Size",      ar: 'حجم الجهة');
    final String subjectLabel      = _t(context, en: 'Subject',            ar: 'الموضوع');
    final String msgLabel          = _t(context, en: 'Message',            ar: 'الرسالة');
    final String hint              = _t(context, en: 'Text Here',          ar: 'اكتب هنا');
    final String sendLabel         = _t(context, en: 'Send',               ar: 'إرسال');
    final String selectLocation    = _t(context, en: 'Select Location',    ar: 'اختر الموقع');
    final String selectType        = _t(context, en: 'Select Type',        ar: 'اختر النوع');
    final String selectSize        = _t(context, en: 'Select Size',        ar: 'اختر الحجم');
    final String otherLangHint     = _t(context, en: 'e.g. French, Spanish…', ar: 'مثال: الفرنسية، الإسبانية…');
    final String otherLangRequired = _t(context, en: 'Please enter your preferred language', ar: 'يرجى إدخال لغتك المفضلة');

    final TextDirection dir   = isRtl ? TextDirection.rtl : TextDirection.ltr;
    final TextAlign     align = isRtl ? TextAlign.right   : TextAlign.left;

    // ── Build dropdown items for entity type ──
    final entityTypes = isRtl
        ? ContactFormConstants.entityTypesAr
        : ContactFormConstants.entityTypesEn;
    final entityTypeItems = entityTypes
        .map((t) => {'key': t, 'value': t})
        .toList();

    // ── Build dropdown items for entity size ──
    final entitySizes = isRtl
        ? ContactFormConstants.entitySizesAr
        : ContactFormConstants.entitySizes;
    final entitySizeItems = entitySizes
        .map((s) => {'key': s, 'value': s})
        .toList();

    // ── Build dropdown items for location (countries) ──
    final countries = isRtl
        ? ContactFormConstants.countriesAr
        : ContactFormConstants.countriesEn;
    final countryItems = countries
        .map((c) => {'key': c, 'value': c})
        .toList();

    // ── Standard language keys (ar / en) — whatever ContactFormConstants provides,
    //    but strip any pre-existing "other" key so we never duplicate it ──
    final List<String> standardLanguageKeys = ContactFormConstants
        .preferredLanguages
        .where((k) => k != _kOtherLanguage)
        .toList();

    final langLabels = isRtl
        ? ContactFormConstants.preferredLanguageLabelsAr
        : ContactFormConstants.preferredLanguageLabelsEn;

    final String otherRadioLabel = isRtl ? 'أخرى' : 'Other';
    final bool showOtherField    = preferredLanguage == _kOtherLanguage;
    final bool otherFieldError   =
        showOtherField && submitted && otherLanguageCtrl.text.trim().isEmpty;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 14.w : 20.w,
          vertical:   isMobile ? 12.h : 12.h),
      decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(rad)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Title ──
          Text(title,
              style: StyleText.fontSize22Weight700.copyWith(
                  fontSize:      isMobile ? 16.sp : 16.sp,
                  color:         Colors.black,
                  letterSpacing: 1.2)),
          SizedBox(height: isMobile ? 8.h : 8.h),

          // ─────────────────────────────────────────────────────────
          // Preferred Language
          //   Row 1: standard radios (ar / en …)
          //   Row 2: "Other" radio  +  inline text field (same row)
          // ─────────────────────────────────────────────────────────
          _FormLabel(label: prefLangLabel),
          SizedBox(height: 10.h),

          // Row — all language radios + "Other" radio + inline text field in ONE flat Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (final lang in standardLanguageKeys) ...[
                _radioItem(
                  lang:              lang,
                  displayLabel:      langLabels[lang] ?? lang,
                  preferredLanguage: preferredLanguage,
                  primaryColor:      primaryColor,
                  isMobile:          isMobile,
                  onLanguageChanged: onLanguageChanged,
                ),
                SizedBox(width: isMobile ? 14.w : 20.w),
              ],
              // "Other" radio
              _radioItem(
                lang:              _kOtherLanguage,
                displayLabel:      otherRadioLabel,
                preferredLanguage: preferredLanguage,
                primaryColor:      primaryColor,
                isMobile:          isMobile,
                onLanguageChanged: onLanguageChanged,
              ),
              SizedBox(width: 10.w),
              // Inline text field — only takes remaining space when visible
              Expanded(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve:    Curves.easeInOut,
                  child: showOtherField
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller:    otherLanguageCtrl,
                        textDirection: dir,
                        textAlign:     align,
                        style: StyleText.fontSize13Weight400.copyWith(
                          color:    AppColors.text,
                          fontSize: isMobile ? 12.sp : 13.sp,
                        ),
                        decoration: InputDecoration(
                          hoverColor: Colors.transparent,
                          hintText:  otherLangHint,
                          hintStyle: StyleText.fontSize12Weight400.copyWith(
                            color: Colors.grey.shade400,
                          ),
                          isDense:        true,
                          filled:         true,
                          fillColor:      otherFieldError
                              ? Colors.red.withOpacity(0.04)
                              : const Color(0xFFF1F2ED),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical:   isMobile ? 10 : 9.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.r),
                            borderSide: BorderSide(
                              color: otherFieldError
                                  ? Colors.red
                                  : Colors.transparent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.r),
                            borderSide: BorderSide(
                              color: otherFieldError
                                  ? Colors.red
                                  : Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.r),
                            borderSide: BorderSide(
                              color: otherFieldError
                                  ? Colors.red
                                  : primaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      if (otherFieldError) ...[
                        SizedBox(height: 3.h),
                        Text(
                          otherLangRequired,
                          style: StyleText.fontSize12Weight400.copyWith(
                            color:    Colors.red,
                            fontSize: isMobile ? 11.sp : 11.sp,
                          ),
                        ),
                      ],
                    ],
                  )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),



          SizedBox(height: isMobile ? 8.h : 10.h),

          // ── First Name / Last Name (side by side) ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomValidatedTextFieldMaster(
                  label:         firstNameLabel,
                  hint:          hint,
                  controller:    firstNameCtrl,
                  submitted:     submitted,
                  height:        32,
                  primaryColor:  primaryColor,
                  textDirection: dir,
                  textAlign:     align,
                ),
              ),
              SizedBox(width: isMobile ? 8.w : 12.w),
              Expanded(
                child: CustomValidatedTextFieldMaster(
                  label:         lastNameLabel,
                  hint:          hint,
                  controller:    lastNameCtrl,
                  submitted:     submitted,
                  height:        32,
                  primaryColor:  primaryColor,
                  textDirection: dir,
                  textAlign:     align,
                ),
              ),
            ],
          ),

          // ── Email / Phone (side by side) ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomValidatedTextFieldMaster(
                  label:        emailLabel,
                  primaryColor: primaryColor,
                  hint: _t(context,
                      en: 'Enter your email',
                      ar: 'أدخل البريد الإلكتروني'),
                  controller:    emailCtrl,
                  submitted:     submitted,
                  height:        32,
                  textDirection: dir,
                  textAlign:     align,
                ),
              ),
              SizedBox(width: isMobile ? 8.w : 12.w),
              Expanded(
                child: _PhoneField(
                  label:         phoneLabel,
                  controller:    phoneCtrl,
                  submitted:     submitted,
                  isMobile:      isMobile,
                  selectedCode:  phoneCode,
                  onCodeChanged: onCodeChanged,
                  isRtl:         isRtl,
                  primaryColor:  primaryColor,
                ),
              ),
            ],
          ),

          // ── Location / Entity Name (side by side) ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DropdownField(
                  label:        locationLabel,
                  hint:         selectLocation,
                  value:        selectedLocation,
                  items:        countryItems,
                  onChanged:    onLocationChanged,
                  submitted:    submitted,
                  isRtl:        isRtl,
                  isMobile:     isMobile,
                  primaryColor: primaryColor,
                  isSearchable: true,
                ),
              ),
              SizedBox(width: isMobile ? 8.w : 12.w),
              Expanded(
                child: CustomValidatedTextFieldMaster(
                  label:         entityNameLabel,
                  hint:          hint,
                  controller:    entityNameCtrl,
                  submitted:     false, // optional
                  height:        32,
                  primaryColor:  primaryColor,
                  textDirection: dir,
                  textAlign:     align,
                ),
              ),
            ],
          ),

          // ── Entity Type / Entity Size (side by side) ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DropdownField(
                  label:        entityTypeLabel,
                  hint:         selectType,
                  value:        selectedEntityType,
                  items:        entityTypeItems,
                  onChanged:    onEntityTypeChanged,
                  submitted:    false,
                  isRtl:        isRtl,
                  isMobile:     isMobile,
                  primaryColor: primaryColor,
                ),
              ),
              SizedBox(width: isMobile ? 8.w : 12.w),
              Expanded(
                child: _DropdownField(
                  label:        entitySizeLabel,
                  hint:         selectSize,
                  value:        selectedEntitySize,
                  items:        entitySizeItems,
                  onChanged:    onEntitySizeChanged,
                  submitted:    false,
                  isRtl:        isRtl,
                  isMobile:     isMobile,
                  primaryColor: primaryColor,
                ),
              ),
            ],
          ),

          SizedBox(height: 15.h),

          // ── Subject (full width) ──
          CustomValidatedTextFieldMaster(
              primaryColor:  primaryColor,
              label:         subjectLabel,
              hint:          hint,
              controller:    subjectCtrl,
              submitted:     submitted,
              height:        32,
              minLength:     10,
              textDirection: dir,
              textAlign:     align),

          // ── Message (full width) ──
          CustomValidatedTextFieldMaster(
              primaryColor:  primaryColor,
              label:         msgLabel,
              hint:          hint,
              controller:    messageCtrl,
              submitted:     submitted,
              height:        72,
              maxLines:      3,
              minLength:     30,
              textDirection: dir,
              textAlign:     align),

          SizedBox(height: 4.h),

          // ── Send Button ──
          SizedBox(
            width:  double.infinity,
            height: isMobile ? 40.h : 36.h,
            child: ElevatedButton(
              onPressed: onSend,
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                  elevation: 0),
              child: Text(sendLabel,
                  style: StyleText.fontSize16Weight600
                      .copyWith(color: Colors.white, fontSize: 14.sp)),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// FORM HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

/// Simple label widget for form fields
