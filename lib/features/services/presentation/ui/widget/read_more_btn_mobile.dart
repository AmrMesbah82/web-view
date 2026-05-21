part of '../pages/services_page.dart';

class _ReadMoreBtnMobile extends StatelessWidget {
  final VoidCallback onTap;
  final String       label;
  final Color        primaryColor;
  const _ReadMoreBtnMobile({
    required this.onTap,
    this.label = 'Read More',
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
            color:        primaryColor,
            borderRadius: BorderRadius.circular(7.r)),
        child: Text(label,
            style: TextStyle(
                fontFamily: 'Cairo',
                fontSize:   12.sp,
                fontWeight: FontWeight.w600,
                color:      Colors.white)),
      ),
    );
  }
}
