// ******************* FILE INFO *******************
// File Name: scroll_with_footer.dart
// Purpose: BUG-65 / BUG-33 / BUG-37 — the site footer (~330 px) was pinned to
//          the bottom of the window on every page, so content scrolled in the
//          remaining ~60% and parts of it (Home "Careers" button, the Contact
//          form's Message / Send, form fields on phones) sat behind it.
//
//          This scroll view puts the footer INSIDE the scrolling content: it
//          follows the page's last section, and on a short page it is still
//          pushed to the bottom of the window (never floating mid-screen).

import 'package:flutter/material.dart';

class ScrollWithFooter extends StatelessWidget {
  const ScrollWithFooter({
    super.key,
    required this.child,
    this.footer,
    this.controller,
    this.padding,
    this.physics,
  });

  /// The page content (what used to be the SingleChildScrollView's child).
  final Widget child;

  /// The site footer; null hides it (e.g. inside admin previews).
  final Widget? footer;

  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double minH =
            constraints.hasBoundedHeight ? constraints.maxHeight : 0;
        return SingleChildScrollView(
          controller: controller,
          physics: physics,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minH),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                padding == null ? child : Padding(padding: padding!, child: child),
                if (footer != null) footer!,
              ],
            ),
          ),
        );
      },
    );
  }
}
