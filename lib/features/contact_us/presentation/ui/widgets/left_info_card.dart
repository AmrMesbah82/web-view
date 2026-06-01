part of '../pages/contact_us_page.dart';

class _LeftInfoCard extends StatelessWidget {
  final ContactUsCmsModel? cmsData;
  final bool  isRtl;
  final Color primaryColor;
  const _LeftInfoCard(
      {this.cmsData, required this.isRtl, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final String emailLabel  = _t(context, en: 'Email',     ar: 'البريد الإلكتروني');
    final String followLabel = _t(context, en: 'Follow Us', ar: 'تابعنا');
    final String desc = cmsData != null
        ? _bi(context, cmsData!.subDescription)
        : _t(context,
        en: 'Achieve Your Goals Efficiently And Without Disruption Through Seamless, Uninterrupted Workflows',
        ar: 'حقق أهدافك بكفاءة ودون انقطاع من خلال سير عمل سلس ومتواصل');

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(14.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(desc,
              style: StyleText.fontSize18Weight500.copyWith(
                  height: 1.6, color: Colors.black87, fontSize: 14.sp)),
          SizedBox(height: 24.h),
          Text(emailLabel,
              style: StyleText.fontSize16Weight600.copyWith(
                  color: primaryColor, fontSize: 13.sp)),
          SizedBox(height: 5.h),
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
          SizedBox(height: 20.h),
          Text(followLabel,
              style: StyleText.fontSize16Weight600.copyWith(
                  color: primaryColor, fontSize: 13.sp)),
          SizedBox(height: 10.h),
          _SocialRow(
              cmsData: cmsData, scaled: true, primaryColor: primaryColor),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// FORM CARD — UPDATED WITH "OTHER" LANGUAGE OPTION + CUSTOM TEXT FIELD
// ═══════════════════════════════════════════════════════════════════════════════
