part of '../pages/careers_page.dart';

class _MobileInternsTab extends StatelessWidget {
  final Color primary;
  final bool isRtl;
  final List<InternModel> interns;
  const _MobileInternsTab(
      {required this.primary, required this.isRtl, required this.interns});

  @override
  Widget build(BuildContext context) {
    if (interns.isEmpty) return const SizedBox.shrink();
    return Column(
      children: List.generate(interns.length, (i) {
        return _Reveal(
          delay: Duration(milliseconds: 60 + i * 70),
          direction: _SlideDirection.fromBottom,
          duration: const Duration(milliseconds: 650),
          child: Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _MobileInternCard(
              data: interns[i],
              primary: primary,
              isRtl: isRtl,
            ),
          ),
        );
      }),
    );
  }
}
