part of '../pages/careers_page.dart';

class _DesktopOurTeamTab extends StatelessWidget {
  final Color primary;
  final Color secondary;
  final bool isTablet;
  final bool isRtl;
  final List<OurTeamItem> teams;
  const _DesktopOurTeamTab({
    required this.primary,
    required this.secondary,
    this.isTablet = false,
    required this.isRtl,
    required this.teams,
  });

  @override
  Widget build(BuildContext context) {
    if (teams.isEmpty) return const SizedBox.shrink();

    final double screenW = MediaQuery.of(context).size.width;
    final double hPad =
    isTablet ? _tabletHPad() : _desktopHPad(screenW);
    final double totalW = screenW - hPad * 2;
    final double cardW = (totalW - 14.w * 2) / 3;
    final double meetFz = isTablet ? 16.sp : 20.sp;

    final List<Widget> rows = [];
    for (int i = 0; i < teams.length; i += 3) {
      final int rowIndex = i ~/ 3;
      final List<Widget> rowChildren = [];
      for (int j = i; j < i + 3; j++) {
        if (j < teams.length) {
          rowChildren.add(
            _DesktopTeamCard(
              data: teams[j],
              width: cardW,
              primary: primary,
              secondary: secondary,
              isTablet: isTablet,
              isRtl: isRtl,
            ),
          );
        } else {
          rowChildren.add(SizedBox(width: cardW));
        }
        if (j < i + 2) rowChildren.add(SizedBox(width: 14.w));
      }
      rows.add(
        _Reveal(
          delay: Duration(milliseconds: 80 + rowIndex * 80),
          direction: _SlideDirection.fromBottom,
          duration: const Duration(milliseconds: 650),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rowChildren,
            ),
          ),
        ),
      );
      if (i + 3 < teams.length) rows.add(SizedBox(height: 14.h));
    }

    return Column(
      children: [
        _Reveal(
          delay: const Duration(milliseconds: 60),
          direction: _SlideDirection.fromLeft,
          duration: const Duration(milliseconds: 600),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _t(
                          'Meet Our Teams', 'تعرّف على فرقنا', isRtl),
                      style: StyleText.fontSize24Weight600.copyWith(
                        fontSize: meetFz,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 18.h),
        ...rows,
      ],
    );
  }
}
