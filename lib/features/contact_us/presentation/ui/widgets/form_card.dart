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

  // ── Helper: two fields side-by-side on desktop, stacked on mobile ──
  Widget _pair(Widget a, Widget b) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [a, SizedBox(height: 15.sp), b],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: a),
        SizedBox(width: 12.w),
        Expanded(child: b),
      ],
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
                      CustomValidatedTextFieldMaster(
                        hint:          otherLangHint,
                        controller:    otherLanguageCtrl,
                        submitted:     otherFieldError,
                        height:        36,
                        primaryColor:  primaryColor,
                        textDirection: dir,
                        textAlign:     align,
                        fillColor:     Colors.white,
                      ),
                    ],
                  )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 15.sp : 18.h),

          // ── First Name / Last Name (mobile: stacked) ──
          _pair(
            CustomValidatedTextFieldMaster(
              label:         firstNameLabel,
              hint:          hint,
              controller:    firstNameCtrl,
              submitted:     submitted,
              height:        36,
              primaryColor:  primaryColor,
              textDirection: dir,
              textAlign:     align,
            ),
            CustomValidatedTextFieldMaster(
              label:         lastNameLabel,
              hint:          hint,
              controller:    lastNameCtrl,
              submitted:     submitted,
              height:        36,
              primaryColor:  primaryColor,
              textDirection: dir,
              textAlign:     align,
            ),
          ),
          if (isMobile) SizedBox(height: 15.sp),

          // ── Email / Phone (mobile: stacked; phone keeps code+number row) ──
          _pair(
            CustomValidatedTextFieldMaster(
              label:        emailLabel,
              primaryColor: primaryColor,
              hint: _t(context,
                  en: 'Enter your email',
                  ar: 'أدخل البريد الإلكتروني'),
              controller:    emailCtrl,
              submitted:     submitted,
              height:        36,
              textDirection: dir,
              textAlign:     align,
            ),
            _PhoneField(
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
          if (isMobile) SizedBox(height: 15.sp),

          // ── Location / Entity Name (mobile: stacked) ──
          _pair(
            _DropdownField(
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
            CustomValidatedTextFieldMaster(
              label:         entityNameLabel,
              hint:          hint,
              controller:    entityNameCtrl,
              submitted:     false, // optional
              height:        36,
              primaryColor:  primaryColor,
              textDirection: dir,
              textAlign:     align,
            ),
          ),
          if (isMobile) SizedBox(height: 15.sp),

          // ── Entity Type / Entity Size (mobile: stacked) ──
          _pair(
            _DropdownField(
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
            _DropdownField(
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

          SizedBox(height: isMobile ? 15.sp : 15.h),

          // ── Subject (full width) ──
          CustomValidatedTextFieldMaster(
              primaryColor:  primaryColor,
              label:         subjectLabel,
              hint:          hint,
              controller:    subjectCtrl,
              submitted:     submitted,
              height:        36,
              minLength:     10,
              textDirection: dir,
              textAlign:     align),

          if (isMobile) SizedBox(height: 15.sp),

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

          SizedBox(height: 13.h),

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
          SizedBox(height: 7.h),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// FORM HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

/// Simple label widget for form fields
