part of '../pages/careers_page.dart';

class _MobileTeamCard extends StatelessWidget {
  final OurTeamItem data;
  final Color primary;
  final Color secondary;
  final bool isRtl;
  final bool isExpanded;
  final VoidCallback onTap;
  const _MobileTeamCard({
    required this.data,
    required this.primary,
    required this.secondary,
    required this.isRtl,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String name = isRtl ? data.title.ar : data.title.en;
    final String desc = isRtl ? data.description.ar : data.description.en;
    final List<String> deliverables = data.deliverableItems
        .map((d) => isRtl ? d.label.ar : d.label.en)
        .where((s) => s.isNotEmpty)
        .toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Icon: network SVG if available ─────────────────────────────
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: secondary,
            ),
            child: Center(
              child: data.iconUrl.isNotEmpty
                  ? SvgPicture.network(
                data.iconUrl,
                width: 32.w,
                height: 32.w,
                fit: BoxFit.contain,
                colorFilter:
                ColorFilter.mode(primary, BlendMode.srcIn),
                placeholderBuilder: (_) =>
                    SizedBox(width: 32.w, height: 32.w),
              )
                  : SizedBox(width: 32.w, height: 32.w),
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: StyleText.fontSize12Weight600.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: StyleText.fontSize12Weight600.copyWith(
              fontSize: 10.sp,
              height: 1.6,
              color: AppColors.secondaryText.withOpacity(.7),
            ),
          ),
          SizedBox(height: 10.h),
          _DeliverableButtons(
            deliverables: deliverables,
            primary: primary,
            isRtl: isRtl,
            isExpanded: isExpanded,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
