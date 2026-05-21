part of '../pages/contact_us_page.dart';

class _MobileInfoCard extends StatelessWidget {
  final ContactUsCmsModel? cmsData;
  final bool  isRtl;
  final Color primaryColor;
  const _MobileInfoCard(
      {this.cmsData, required this.isRtl, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final String emailLabel  = _t(context, en: 'Email',     ar: 'البريد الإلكتروني');
    final String followLabel = _t(context, en: 'Follow Us', ar: 'تابعنا');
    final String desc = cmsData != null
        ? _bi(context, cmsData!.subDescription)
        : _t(context,
        en: 'Achieve Your Goals Efficiently And Without Disruption',
        ar: 'حقق أهدافك بكفاءة ودون انقطاع من خلال سير عمل سلس ومتواصل');

    return Container(
      width:   double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(desc,
              style: StyleText.fontSize12Weight600.copyWith(
                  height: 1.6, color: Colors.black87, fontSize: 12.sp)),
          SizedBox(height: 18.h),
          Text(emailLabel,
              style: StyleText.fontSize15Weight600.copyWith(
                  color: primaryColor, fontSize: 13.sp)),
          SizedBox(height: 4.h),
          GestureDetector(
            onTap: () async {
              final email = cmsData?.email ?? 'info@bayanatz.com';
              final uri   = Uri(scheme: 'mailto', path: email);
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                cmsData?.email ?? 'info@bayanatz.com',
                style: StyleText.fontSize13Weight400.copyWith(
                  color:           primaryColor,
                  fontSize:        12.sp,
                  decoration:      TextDecoration.underline,
                  decorationColor: primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(followLabel,
              style: StyleText.fontSize15Weight600.copyWith(
                  color: primaryColor, fontSize: 13.sp)),
          SizedBox(height: 8.h),
          _SocialRow(
              cmsData: cmsData, scaled: false, primaryColor: primaryColor),
        ],
      ),
    );
  }
}
