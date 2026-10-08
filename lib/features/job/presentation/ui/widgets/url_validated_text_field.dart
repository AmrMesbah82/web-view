part of '../pages/job_apply_page.dart';

class _UrlValidatedTextField extends StatefulWidget {
  final String label, hint;
  final TextEditingController controller;
  final bool submitted, isRtl;
  final bool isRequired;
  final Color primaryColor;

  const _UrlValidatedTextField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.submitted,
    required this.isRtl,
    required this.primaryColor,
    this.isRequired = true,
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

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: CustomTextField(
        label: widget.label,
        hint: widget.hint,
        controller: widget.controller,
        height: 36,
        fillColor: Colors.white,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.start,
        // Empty-field "required" error only when the admin flagged it required
        submitted: widget.submitted && widget.isRequired,
        errorText: showError
            ? _t(
                'Please enter a valid URL (e.g., https://example.com)',
                'يرجى إدخال رابط صالح (مثال: https://example.com)',
                widget.isRtl,
              )
            : null,
      ),
    );
  }
}
