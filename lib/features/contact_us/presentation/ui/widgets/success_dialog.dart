part of '../pages/contact_us_page.dart';

class _SuccessDialog extends StatelessWidget {
  final ContactUsCmsModel? cmsData;
  final bool  isRtl;
  final Color primaryColor;
  const _SuccessDialog(
      {this.cmsData,
        required this.isRtl,
        required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final bool   isMobile = MediaQuery.of(context).size.width < _BP.mobile;
    final String title    = cmsData != null
        ? _bi(context, cmsData!.confirmMessage.title)
        : _t(context,
        en: "WE'VE RECEIVED YOUR MESSAGE — AND WE'RE ON IT!",
        ar: 'لقد استلمنا رسالتك وسنرد عليك في أقرب وقت!');
    final String desc = cmsData != null
        ? _bi(context, cmsData!.confirmMessage.description)
        : _t(context,
        en: "Thanks For Getting In Touch. We're Already Reviewing Your Message And Will Connect With You Soon.",
        ar: 'شكرًا للتواصل معنا — رسالتك في طريقها إلى فريقنا. سنتواصل معك قريبًا.');

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(isMobile ? 14 : 16.r)),
        insetPadding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 36.w,
            vertical:   isMobile ? 56 : 36.h),
        child: SizedBox(
          width: isMobile ? double.infinity : 640.w,
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 20 : 32.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (cmsData?.confirmMessage.svgUrl.isNotEmpty ?? false)
                  SvgPicture.network(
                    cmsData!.confirmMessage.svgUrl,
                    width:  isMobile ? double.infinity : 260.w,
                    height: isMobile ? 140 : 160.h,
                    fit:    BoxFit.contain,
                  )
                else
                  SvgPicture.asset(
                    'assets/images/contact_us/contact_send.svg',
                    width:  isMobile ? 120 : 140.w,
                    height: isMobile ? 100 : 120.h,
                    fit:    BoxFit.contain,
                  ),
                SizedBox(height: isMobile ? 16.0 : 22.h),
                Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: StyleText.fontSize22Weight700.copyWith(
                      fontSize: isMobile ? 14.0 : 20.sp,
                      color:    Colors.black),
                ),
                SizedBox(height: isMobile ? 10.0 : 14.h),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: StyleText.fontSize13Weight400.copyWith(
                      fontSize: isMobile ? 12.0 : 14.sp,
                      height:   1.7,
                      color:    Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
