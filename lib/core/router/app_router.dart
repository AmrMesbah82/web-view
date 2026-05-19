import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



import '../../features/abou_us/presentation/ui/pages/about_us_page.dart';
import '../../features/careers/presentation/ui/pages/careers_page.dart';
import '../../features/contact_us/presentation/ui/pages/contact_us_page.dart';
import '../../features/home/presentation/ui/pages/home_page.dart';
import '../../features/job/presentation/ui/pages/job_apply_page.dart';
import '../../features/job/presentation/ui/pages/job_detail_page.dart';
import '../../features/job/presentation/ui/pages/job_page.dart';
import '../../features/services/presentation/ui/pages/blog_detail_Page.dart';
import '../../features/services/presentation/ui/pages/services_page.dart';




// ═══════════════════════════════════════════════════════════════════════════════
// SLIDE + ANGLE + FADE PAGE TRANSITION
// ═══════════════════════════════════════════════════════════════════════════════

enum SlideDirection { fromRight, fromLeft, fromBottom }

CustomTransitionPage<T> animatedPage<T>({
  required LocalKey key,
  required Widget child,
  SlideDirection slideDirection = SlideDirection.fromRight,
  Duration duration = const Duration(milliseconds: 650),
  Curve curve = Curves.easeOutCubic,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, pageChild) {
      final Offset beginOffset = switch (slideDirection) {
        SlideDirection.fromRight  => const Offset(0.12, 0.0),
        SlideDirection.fromLeft   => const Offset(-0.12, 0.0),
        SlideDirection.fromBottom => const Offset(0.0, 0.08),
      };

      final slideAnim = Tween<Offset>(begin: beginOffset, end: Offset.zero)
          .animate(CurvedAnimation(parent: animation, curve: curve));

      final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.55, curve: Curves.easeIn),
        ),
      );

      final skewSign = slideDirection == SlideDirection.fromLeft ? 1.0 : -1.0;
      final skewAnim = Tween<double>(begin: skewSign * 0.05, end: 0.0)
          .animate(CurvedAnimation(parent: animation, curve: curve));

      final scaleAnim = Tween<double>(begin: 0.97, end: 1.0)
          .animate(CurvedAnimation(parent: animation, curve: curve));

      final exitFade = Tween<double>(begin: 1.0, end: 0.92).animate(
        CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeIn),
      );

      return FadeTransition(
        opacity: exitFade,
        child: FadeTransition(
          opacity: fadeAnim,
          child: SlideTransition(
            position: slideAnim,
            child: AnimatedBuilder(
              animation: animation,
              builder: (_, child) => Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0008)
                  ..rotateY(skewAnim.value)
                  ..scale(scaleAnim.value),
                alignment: Alignment.center,
                child: child,
              ),
              child: pageChild,
            ),
          ),
        ),
      );
    },
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// ROUTER
// ═══════════════════════════════════════════════════════════════════════════════

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [

      // ── Public pages ───────────────────────────────────────────────────────

      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => animatedPage(
          key:   state.pageKey,
          child: const HomePage(),
        ),
      ),

      GoRoute(
        path: '/services',
        name: 'services',
        pageBuilder: (context, state) {
          final String? section = state.uri.queryParameters['section'];
          return animatedPage(
            key:   state.pageKey,
            child: ServicesPage(scrollTo: section),
          );
        },
      ),

      GoRoute(
        path: '/about',
        name: 'about',
        pageBuilder: (context, state) => animatedPage(
          key:   state.pageKey,
          child: const AboutPage(),
        ),
      ),

      GoRoute(
        path: '/contact',
        name: 'contact',
        pageBuilder: (context, state) => animatedPage(
          key:   state.pageKey,
          child: const ContactPage(),
        ),
      ),

      GoRoute(
        path: '/careers',
        name: 'careers',
        pageBuilder: (context, state) => animatedPage(
          key:   state.pageKey,
          child: const CareersPage(),
        ),
      ),

      GoRoute(
        path: '/jobs',
        name: 'jobs',
        pageBuilder: (context, state) => animatedPage(
          key:   state.pageKey,
          child: const JobListingsPage(),
        ),
      ),

      GoRoute(
        path: '/blog/:index',
        name: 'blog',
        pageBuilder: (context, state) {
          final index =
              int.tryParse(state.pathParameters['index'] ?? '0') ?? 0;
          return animatedPage(
            key:   state.pageKey,
            child: BlogDetailPage(),
          );
        },
      ),


      // Add these routes in your website_app's GoRouter:

      GoRoute(
        path: '/jobs/:jobId',
        name: 'job-detail',
        pageBuilder: (context, state) {
          final jobId = state.pathParameters['jobId'] ?? '';
          return animatedPage(
            key: state.pageKey,
            child: JobDetailPage(jobId: jobId),
          );
        },
      ),

      GoRoute(
        path: '/jobs/:jobId/apply',
        name: 'job-apply',
        pageBuilder: (context, state) {
          final jobId = state.pathParameters['jobId'] ?? '';
          return animatedPage(
            key: state.pageKey,
            child: JobApplyPage(jobId: jobId),
          );
        },
      ),



    ],
  );
}