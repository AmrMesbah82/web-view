part of '../pages/contact_us_page.dart';

class _DesktopBody extends StatelessWidget {
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

  const _DesktopBody({
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
    final double screenW  = MediaQuery.of(context).size.width;
    final double contentW = (248.w * 4) + (8.w * 3);
    final double hPad     = ((screenW - contentW) / 2).clamp(16.0, double.infinity);

    final String pageTitle   = _t(context, en: 'Contact Us',       ar: 'تواصل معنا');
    final String officeTitle = _t(context, en: 'Office Locations', ar: 'مواقع المكاتب');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.h),
          _Reveal(
            delay:     const Duration(milliseconds: 80),
            direction: _SlideDirection.fromLeft,
            duration:  const Duration(milliseconds: 650),
            child: Text(pageTitle,
                style: StyleText.fontSize45Weight600.copyWith(
                    fontSize:   36.sp,
                    color:      primaryColor,
                    fontWeight: FontWeight.w900)),
          ),
          SizedBox(height: 24.h),
          _Reveal(
            delay:     const Duration(milliseconds: 130),
            direction: _SlideDirection.fromBottom,
            duration:  const Duration(milliseconds: 650),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      flex: 2,
                      child: _LeftInfoCard(
                          cmsData:      cmsData,
                          isRtl:        isRtl,
                          primaryColor: primaryColor)),
                  SizedBox(width: 20.w),
                  Expanded(
                      flex: 3,
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
                        isRtl:               isRtl,
                        primaryColor:        primaryColor,
                      )),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          _Reveal(
            delay:     const Duration(milliseconds: 180),
            direction: _SlideDirection.fromBottom,
            duration:  const Duration(milliseconds: 650),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(officeTitle,
                    style: StyleText.fontSize45Weight600.copyWith(
                        fontSize:   24.sp,
                        color:      primaryColor,
                        fontWeight: FontWeight.w900)),
                if (cmsData != null &&
                    cmsData!.officeLocations.isNotEmpty) ...[
                  SizedBox(height: 14.h),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: AppColors.card),
                    child: Row(
                      children: cmsData!.officeLocations
                          .map((o) => Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius:
                              BorderRadius.circular(16.r)),
                          padding: EdgeInsets.all(18.sp),
                          child: _OfficeCard(
                              office:       o,
                              isRtl:        isRtl,
                              primaryColor: primaryColor),
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 48.h),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MOBILE BODY
// ═══════════════════════════════════════════════════════════════════════════════
