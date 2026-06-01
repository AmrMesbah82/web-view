part of '../pages/contact_us_page.dart';

class _MobileBody extends StatelessWidget {
  final TextEditingController firstNameCtrl, lastNameCtrl, emailCtrl,
      phoneCtrl, entityNameCtrl, subjectCtrl, messageCtrl,
      otherLanguageCtrl; // ← NEW
  final bool   submitted, isRtl;
  final String phoneCode, preferredLanguage;
  final String? selectedLocation, selectedEntityType, selectedEntitySize;
  final Color  primaryColor;
  final ValueChanged<String?>  onCodeChanged;
  final ValueChanged<String>   onLanguageChanged;
  final ValueChanged<String?>  onLocationChanged;
  final ValueChanged<String?>  onEntityTypeChanged;
  final ValueChanged<String?>  onEntitySizeChanged;
  final VoidCallback           onSend;
  final ContactUsCmsModel?     cmsData;

  const _MobileBody({
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
    required this.primaryColor,     this.cmsData,
  });

  @override
  Widget build(BuildContext context) {
    final String pageTitle   = _t(context, en: 'Contact Us',       ar: 'تواصل معنا');
    final String officeTitle = _t(context, en: 'Office Locations', ar: 'مواقع المكاتب');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(pageTitle,
              style: StyleText.fontSize45Weight600.copyWith(
                  fontSize:   26.sp,
                  color:      primaryColor,
                  fontWeight: FontWeight.w700)),
          SizedBox(height: 16.h),
          _Reveal(
            delay:     const Duration(milliseconds: 100),
            direction: _SlideDirection.fromLeft,
            child: _MobileInfoCard(
                cmsData:      cmsData,
                isRtl:        isRtl,
                primaryColor: primaryColor),
          ),
          SizedBox(height: 16.h),
          _Reveal(
            delay:     const Duration(milliseconds: 150),
            direction: _SlideDirection.fromBottom,
            child: _FormCard(
              firstNameCtrl:       firstNameCtrl,
              lastNameCtrl:        lastNameCtrl,
              emailCtrl:           emailCtrl,
              phoneCtrl:           phoneCtrl,
              entityNameCtrl:      entityNameCtrl,
              subjectCtrl:         subjectCtrl,
              messageCtrl:         messageCtrl,
              otherLanguageCtrl:   otherLanguageCtrl, // ← NEW
              submitted:           submitted,
              phoneCode:           phoneCode,
              preferredLanguage:   preferredLanguage,
              selectedLocation:    selectedLocation,
              selectedEntityType:  selectedEntityType,
              selectedEntitySize:  selectedEntitySize,
              onCodeChanged:       onCodeChanged,
              onLanguageChanged:   onLanguageChanged,
              onLocationChanged:   onLocationChanged,
              onEntityTypeChanged: onEntityTypeChanged,
              onEntitySizeChanged: onEntitySizeChanged,
              onSend:              onSend,
              isMobile:            true,
              isRtl:               isRtl,
              primaryColor:        primaryColor,
            ),
          ),
          SizedBox(height: 24.h),
          _Reveal(
            delay:     const Duration(milliseconds: 80),
            direction: _SlideDirection.fromLeft,
            child: Text(officeTitle,
                style: StyleText.fontSize22Weight700
                    .copyWith(color: primaryColor, fontSize: 18.sp)),
          ),
          SizedBox(height: 12.h),
          if (cmsData != null && cmsData!.officeLocations.isNotEmpty)
            ...cmsData!.officeLocations.asMap().entries.map((e) =>
                _Reveal(
                  delay:     Duration(milliseconds: 100 + e.key * 80),
                  direction: _SlideDirection.fromBottom,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _OfficeCardMobile(
                        office:       e.value,
                        isRtl:        isRtl,
                        primaryColor: primaryColor),
                  ),
                )),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// INFO CARDS
// ═══════════════════════════════════════════════════════════════════════════════
