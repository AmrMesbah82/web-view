part of '../pages/careers_page.dart';

class _BulletText extends StatelessWidget {
  final String text;
  final double fontSize;
  const _BulletText(this.text, {this.fontSize = 13});

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(top: 5.h, right: 7.w),
        child: Container(
          width: 5.w,
          height: 5.w,
          decoration: const BoxDecoration(
            color: Colors.black87,
            shape: BoxShape.circle,
          ),
        ),
      ),
      Expanded(child: _PlainText(text, fontSize: fontSize)),
    ],
  );
}
