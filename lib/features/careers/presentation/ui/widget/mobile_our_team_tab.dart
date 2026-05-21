part of '../pages/careers_page.dart';

class _MobileOurTeamTab extends StatefulWidget {
  final Color primary;
  final Color secondary;
  final bool isRtl;
  final List<OurTeamItem> teams;
  const _MobileOurTeamTab({
    required this.primary,
    required this.secondary,
    required this.isRtl,
    required this.teams,
  });

  @override
  State<_MobileOurTeamTab> createState() => _MobileOurTeamTabState();
}

class _MobileOurTeamTabState extends State<_MobileOurTeamTab> {
  int? _selectedTeamIndex;
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final bool hasMore = widget.teams.length > 4;
    final List<OurTeamItem> displayed =
    (_showAll || !hasMore) ? widget.teams : widget.teams.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Reveal(
          delay: const Duration(milliseconds: 60),
          direction: _SlideDirection.fromLeft,
          duration: const Duration(milliseconds: 600),
          child: Row(
            children: [
              Expanded(child: Container()),
              SizedBox(width: 20.sp),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: _t(
                              'Meet Our Teams',
                              'تعرّف على فرقنا',
                              widget.isRtl,
                            ),
                            style: StyleText.fontSize18Weight500.copyWith(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (hasMore)
                      GestureDetector(
                        onTap: () =>
                            setState(() => _showAll = !_showAll),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: widget.primary,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Text(
                                _showAll
                                    ? _t('Show Less', 'عرض أقل',
                                    widget.isRtl)
                                    : _t('See All', 'عرض الكل',
                                    widget.isRtl),
                                style:
                                StyleText.fontSize12Weight600.copyWith(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              AnimatedRotation(
                                turns: _showAll ? 0.5 : 0.0,
                                duration:
                                const Duration(milliseconds: 250),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        ...displayed.asMap().entries.map(
              (e) => _Reveal(
            delay: Duration(milliseconds: 80 + e.key * 70),
            direction: _SlideDirection.fromBottom,
            duration: const Duration(milliseconds: 650),
            child: Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _MobileTeamCard(
                data: e.value,
                primary: widget.primary,
                secondary: widget.secondary,
                isRtl: widget.isRtl,
                isExpanded: _selectedTeamIndex == e.key,
                onTap: () => setState(() {
                  _selectedTeamIndex =
                  _selectedTeamIndex == e.key ? null : e.key;
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
