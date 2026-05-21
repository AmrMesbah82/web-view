part of '../pages/contact_us_page.dart';

class _FormLabel extends StatelessWidget {
  final String label;
  const _FormLabel({required this.label});
  @override
  Widget build(BuildContext context) => Text(
    label,
    style: StyleText.fontSize14Weight400
        .copyWith(color: AppColors.text, fontSize: 14.sp),
  );
}
