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
          Text(
            _t(
              'Join a Team That Drives Innovation and Values You',
              'انضم إلى فريق يقود الابتكار ويُقدّرك',
              isRtl,
            ),
            style: StyleText.fontSize14Weight600.copyWith(
              fontSize: 13.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _t(
                  'Join Bayanatz—where your future begins',
                  'انضم إلى بيانات—حيث يبدأ مستقبلك',
                  isRtl,
                ),
                style: StyleText.fontSize12Weight400.copyWith(
                  fontSize: 10.sp,
                  color: Colors.black54,
                ),
              ),
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
