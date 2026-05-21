part of '../pages/careers_page.dart';

class _SvgPulseLoader extends StatefulWidget {
  final String? logoUrl;
  final Color backgroundColor;
  const _SvgPulseLoader({this.logoUrl, required this.backgroundColor});

  @override
  State<_SvgPulseLoader> createState() => _SvgPulseLoaderState();
}

class _SvgPulseLoaderState extends State<_SvgPulseLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  String? _resolvedUrl;

  @override
  void initState() {
    super.initState();
    _resolvedUrl = (widget.logoUrl?.isNotEmpty == true) ? widget.logoUrl : null;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _opacity = Tween<double>(
      begin: 0.25,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_SvgPulseLoader old) {
    super.didUpdateWidget(old);
    if (widget.logoUrl != null &&
        widget.logoUrl!.isNotEmpty &&
        _resolvedUrl == null) {
      setState(() => _resolvedUrl = widget.logoUrl);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_resolvedUrl == null) {
      return Scaffold(
        backgroundColor: widget.backgroundColor,
        body: const Center(child: SizedBox.shrink()),
      );
    }
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _opacity,
          child: SvgPicture.network(
            _resolvedUrl!,
            width: 88.w,
            height: 88.w,
            fit: BoxFit.contain,
            placeholderBuilder: (_) => SizedBox(width: 88.w, height: 88.w),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PAGE
// ═══════════════════════════════════════════════════════════════════════════════
