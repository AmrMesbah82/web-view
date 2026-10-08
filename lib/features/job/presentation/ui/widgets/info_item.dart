part of '../pages/job_page.dart';

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  /// Branding primary color from CMS model data (falls back to _kGreen).
  final Color? primary;
  const _InfoItem({required this.label, required this.value, this.primary});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: StyleText.fontSize14Weight500.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          TextSpan(
            text: FormatHelper.capitalize(value),
            style: StyleText.fontSize14Weight600.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: primary ?? _kGreen,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── View Job Button ──────────────────────────────────────────────────────────
