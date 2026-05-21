part of '../pages/about_us_page.dart';

class _RevealCoordinatorWidget extends StatefulWidget {
  final Widget child;
  const _RevealCoordinatorWidget({required this.child});
  @override
  State<_RevealCoordinatorWidget> createState() => _RevealCoordinatorState();
}

class _RevealCoordinatorState extends State<_RevealCoordinatorWidget> {
  final List<_RevealState> _items = [];
  void register(_RevealState item) {
    _items.add(item);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 80), () {
        if (mounted) item.onScroll();
      });
    });
  }

  void unregister(_RevealState item) => _items.remove(item);
  void notifyScroll() {
    for (final item in List.of(_items)) item.onScroll();
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
