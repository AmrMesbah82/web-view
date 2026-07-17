part of '../pages/careers_page.dart';

class _MobileHeaderCard extends StatelessWidget {
  final Color primary;
  final bool isRtl;
  final String description;
  final String btnLabel;
  const _MobileHeaderCard({
    required this.primary,
    required this.isRtl,
    required this.description,
    required this.btnLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (description.isNotEmpty)
            Text(
              description,
              style: StyleText.fontSize13Weight400.copyWith(
                fontSize: 11.sp,
                height: 1.65,
                color: Colors.black87,
              ),
            ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              if (btnLabel.isNotEmpty)
                GestureDetector(
                  onTap: () => context.go('/jobs'),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      btnLabel,
                      style: StyleText.fontSize12Weight600.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
