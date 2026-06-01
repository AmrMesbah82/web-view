part of '../pages/careers_page.dart';

class _MobileBullet extends StatelessWidget {
  final String text;
  const _MobileBullet(this.text);
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(top: 5.h, right: 5.w),
        child: CircleAvatar(radius: 3.r, backgroundColor: Colors.black87),
      ),
      Expanded(child: _MobilePlain(text)),
    ],
  );
}
