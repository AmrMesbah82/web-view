part of '../pages/home_page.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// ANIMATION
// ═══════════════════════════════════════════════════════════════════════════════

enum _SlideDirection { fromBottom, fromLeft, fromRight, fromTop }

class _RevealCoordinator extends InheritedWidget {
  final _RevealCoordinatorState state;
  const _RevealCoordinator({required this.state, required super.child});

  static _RevealCoordinatorState? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_RevealCoordinator>()?.state;

  @override
  bool updateShouldNotify(_RevealCoordinator old) => false;
}

class _RevealCoordinatorWidget extends StatefulWidget {
  final Widget child;
  const _RevealCoordinatorWidget({required this.child});

  @override
  State<_RevealCoordinatorWidget> createState() => _RevealCoordinatorState();
}

class _RevealCoordinatorState extends State<_RevealCoordinatorWidget> {
  final List<_RevealState> _items = [];

  void register(_RevealState item)   => _items.add(item);
  void unregister(_RevealState item) => _items.remove(item);

  void notifyScroll() {
    for (final item in List.of(_items)) {
      item.onScroll();
    }
  }

  @override
  Widget build(BuildContext context) => _RevealCoordinator(
    state: this,
    child: NotificationListener<ScrollNotification>(
      onNotification: (_) {
        notifyScroll();
        return false;
      },
      child: widget.child,
    ),
  );
}

class _Reveal extends StatefulWidget {
  final Widget          child;
  final Duration        delay;
  final Duration        duration;
  final _SlideDirection direction;

  const _Reveal({
    required this.child,
    this.delay     = Duration.zero,
    this.duration  = const Duration(milliseconds: 700),
    this.direction = _SlideDirection.fromBottom,
  });

  @override
  State<_Reveal> createState() => _RevealState();
}

class _RevealState extends State<_Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _opacity;
  late final Animation<Offset>   _slide;
  bool _triggered = false;
  _RevealCoordinatorState? _coordinator;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);

    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut)
        .drive(Tween(begin: 0.0, end: 1.0));

    final Offset begin = switch (widget.direction) {
      _SlideDirection.fromBottom => const Offset(0, 0.18),
      _SlideDirection.fromTop    => const Offset(0, -0.18),
      _SlideDirection.fromLeft   => const Offset(-0.18, 0),
      _SlideDirection.fromRight  => const Offset(0.18, 0),
    };
    _slide = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic)
        .drive(Tween(begin: begin, end: Offset.zero));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(widget.delay, () => _checkAndTrigger());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newCoordinator = _RevealCoordinator.of(context);
    if (newCoordinator != _coordinator) {
      _coordinator?.unregister(this);
      _coordinator = newCoordinator;
      _coordinator?.register(this);
    }
  }

  @override
  void dispose() {
    _coordinator?.unregister(this);
    _coordinator = null;
    _ctrl.dispose();
    super.dispose();
  }

  void onScroll() => _checkAndTrigger();

  void _checkAndTrigger() {
    if (_triggered || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final pos     = box.localToGlobal(Offset.zero);
    final screenH = MediaQuery.of(context).size.height;
    if (pos.dy < screenH - 40.h) {
      _triggered = true;
      _ctrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _opacity,
    child: SlideTransition(position: _slide, child: widget.child),
  );
}
