part of '../pages/about_us_page.dart';

class _RevealCoordinator extends InheritedWidget {
  final _RevealCoordinatorState state;
  const _RevealCoordinator({required this.state, required super.child});
  static _RevealCoordinatorState? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_RevealCoordinator>()?.state;
  @override
  bool updateShouldNotify(_RevealCoordinator old) => false;
}
