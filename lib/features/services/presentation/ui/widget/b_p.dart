part of '../pages/blog_detail_Page.dart';

class _BP {
  static const double mobile = 600;
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

String _tb(BlogBilingualText b, bool isRtl) {
  final v = isRtl ? b.ar : b.en;
  return v.isNotEmpty ? v : b.en;
}

String _monthName(int m) => const [
  '',
  'January', 'February', 'March',     'April',   'May',      'June',
  'July',    'August',   'September', 'October',  'November', 'December',
][m];

String _monthNameAr(int m) => const [
  '',
  'يناير', 'فبراير', 'مارس',   'أبريل', 'مايو',   'يونيو',
  'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر','نوفمبر', 'ديسمبر',
][m];

String _formatDate(DateTime? dt, bool isRtl) {
  if (dt == null) return '';
  return isRtl
      ? '${_monthNameAr(dt.month)} ${dt.day} ${dt.year}'
      : '${_monthName(dt.month)} ${dt.day}, ${dt.year}';
}

// ═══════════════════════════════════════════════════════════════════════════════
// PAGE
// ═══════════════════════════════════════════════════════════════════════════════
