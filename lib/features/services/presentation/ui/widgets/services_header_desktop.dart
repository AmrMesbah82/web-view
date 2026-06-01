part of '../pages/services_page.dart';

class _ServicesHeaderDesktop extends StatelessWidget {
  final ServicePageModel model;
  final bool isRtl;
  final Color primaryColor;
  const _ServicesHeaderDesktop(
      {required this.model,
        required this.isRtl,
        required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final double screenW  = MediaQuery.of(context).size.width;
    final double contentW = _desktopContentWidth(context);
    final double hPad =
    ((screenW - contentW) / 2).clamp(16.0, double.infinity);

    final String title = _t(model.title, isRtl).isNotEmpty
        ? _t(model.title, isRtl)
        : (isRtl ? 'الخدمات' : 'Services');
    final String desc = _t(model.shortDescription, isRtl).isNotEmpty
        ? _t(model.shortDescription, isRtl)
        : (isRtl
        ? 'تقدم بيانتز مجموعة من الخدمات المصممة لدعم مبادرات التحول الرقمي في مؤسستك.'
        : 'Bayanatz offers a range of services designed to support digital transformation initiatives within your organization.');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 36.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyles.font28BlackSemiBoldCairo.copyWith(
                  fontSize:   48.sp,
                  fontWeight: FontWeight.w900,
                  color:      primaryColor)),
          SizedBox(height: 12.h),
          Text(desc,
              style: AppTextStyles.font14BlackRegularCairo.copyWith(
                  fontSize:   16.sp,
                  height:     1.7,
                  fontWeight: FontWeight.w500,
                  color:      AppColors.secondaryBlack)),
        ],
      ),
    );
  }
}

// ─── Header Mobile ────────────────────────────────────────────────────────────
