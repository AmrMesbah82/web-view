part of '../pages/job_apply_page.dart';

class _UrlValidatedTextField extends StatefulWidget {
  final String label, hint;
  final TextEditingController controller;
  final bool submitted, isRtl;
  final Color primaryColor;

  const _UrlValidatedTextField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.submitted,
    required this.isRtl,
    required this.primaryColor,
  });

  @override
  State<_UrlValidatedTextField> createState() => _UrlValidatedTextFieldState();
}

class _UrlValidatedTextFieldState extends State<_UrlValidatedTextField> {
  bool _hasError = false;

  bool _isValidUrl(String url) {
    if (url.isEmpty) return true;

    String testUrl = url.trim();
    if (!testUrl.startsWith('http://') && !testUrl.startsWith('https://')) {
      testUrl = 'https://$testUrl';
    }

    final uri = Uri.tryParse(testUrl);
    if (uri == null) return false;

    return uri.hasScheme && uri.hasAuthority && uri.host.contains('.');
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final text = widget.controller.text.trim();
    if (text.isEmpty) {
      setState(() => _hasError = false);
      return;
    }

    final isValid = _isValidUrl(text);
    if (_hasError != !isValid) {
      setState(() => _hasError = !isValid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showError = _hasError && widget.controller.text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: StyleText.fontSize14Weight400.copyWith(
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          height: 36.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: showError ? Colors.red : Colors.transparent,
              width: 1,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            style: StyleText.fontSize12Weight400.copyWith(
              color: AppColors.text,
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: StyleText.fontSize12Weight400.copyWith(
                color: AppColors.secondaryBlack,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 14.h,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: showError ? Colors.red : widget.primaryColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        if (showError) ...[
          SizedBox(height: 4.h),
          Text(
            _t(
              'Please enter a valid URL (e.g., https://example.com)',
              'يرجى إدخال رابط صالح (مثال: https://example.com)',
              widget.isRtl,
            ),
            style: StyleText.fontSize12Weight400.copyWith(
              color: Colors.red,
              fontSize: 11.sp,
            ),
          ),
        ],
        SizedBox(height: 2.h),
      ],
    );
  }
}
