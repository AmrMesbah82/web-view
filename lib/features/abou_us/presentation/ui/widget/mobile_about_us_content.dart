part of '../pages/about_us_page.dart';

class _MobileAboutUsContent extends StatefulWidget {
  final AboutPageModel model;
  final bool isRtl;
  final Color primaryColor, secondaryColor;
  final int? initialExpanded;
  const _MobileAboutUsContent({
    required this.model,
    required this.isRtl,
    required this.primaryColor,
    required this.secondaryColor,
    this.initialExpanded,
  });
  @override
  State<_MobileAboutUsContent> createState() => _MobileAboutUsContentState();
}

class _MobileAboutUsContentState extends State<_MobileAboutUsContent> {
  late int _expanded;
  @override
  void initState() {
    super.initState();
    _expanded = widget.initialExpanded ?? 0;
  }

  String _tabLabel(int i) => switch (i) {
    0 => widget.isRtl ? 'الرؤية' : 'Vision',
    1 => widget.isRtl ? 'الرسالة' : 'Mission',
    _ => widget.isRtl ? 'القيم' : 'Values',
  };
  String _tabIconUrl(int i) => switch (i) {
    0 => widget.model.vision.iconUrl,
    1 => widget.model.mission.iconUrl,
    _ => widget.model.values.isNotEmpty ? widget.model.values.first.iconUrl : '',
  };

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _MobileTabData(
        label: _tabLabel(0),
        iconUrl: _tabIconUrl(0),
        svgUrl: widget.model.vision.svgUrl,
        fullText: _ab(widget.model.vision.description, widget.isRtl),
        tabIndex: 0,
      ),
      _MobileTabData(
        label: _tabLabel(1),
        iconUrl: _tabIconUrl(1),
        svgUrl: widget.model.mission.svgUrl,
        fullText: _ab(widget.model.mission.description, widget.isRtl),
        tabIndex: 1,
      ),
      _MobileTabData(
        label: _tabLabel(2),
        iconUrl: _tabIconUrl(2),
        svgUrl: '',
        fullText: '',
        tabIndex: 2,
      ),
    ];
    return Column(
      children: tabs.map((tab) {
        final bool isOpen = _expanded == tab.tabIndex;
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _MobileAccordionItem(
            tab: tab,
            values: widget.model.values,
            isExpanded: isOpen,
            isRtl: widget.isRtl,
            primaryColor: widget.primaryColor,
            secondaryColor: widget.secondaryColor,
            onTap: () => setState(() => _expanded = isOpen ? -1 : tab.tabIndex),
          ),
        );
      }).toList(),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Mobile Doc Panel
// ══════════════════════════════════════════════════════════════════════════════
