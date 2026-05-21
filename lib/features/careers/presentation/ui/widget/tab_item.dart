part of '../pages/careers_page.dart';

class _TabItem {
  final String labelEn;
  final String labelAr;
  final String icon;
  const _TabItem({
    required this.labelEn,
    required this.labelAr,
    required this.icon,
  });
  String label(bool isRtl) => isRtl ? labelAr : labelEn;
}

const List<_TabItem> _tabs = [
  _TabItem(
    labelEn: 'Why Join Our Team',
    labelAr: 'لماذا تنضم إلى فريقنا',
    icon: 'assets/images/careers/Why Join Our Team.svg',
  ),
  _TabItem(
    labelEn: 'Our Interns',
    labelAr: 'متدربونا',
    icon: 'assets/images/careers/Our Interns.svg',
  ),
  _TabItem(
    labelEn: 'Our Team',
    labelAr: 'فريقنا',
    icon: 'assets/images/careers/Our Team.svg',
  ),
];

// ═══════════════════════════════════════════════════════════════════════════════
// SVG PULSE LOADER  (unchanged)
// ═══════════════════════════════════════════════════════════════════════════════
