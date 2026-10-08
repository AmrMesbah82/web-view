// ******************* FILE INFO *******************
// File Name: not_found_page.dart
// Purpose: BUG-56 — branded, bilingual "Page not found" (replaces the raw
//          "GoException: no routes for location: …" developer page).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/controller/home_cubit.dart';
import '../../features/home/presentation/controller/home_state.dart';
import '../../features/home/presentation/controller/lang_state.dart';
import 'app_navbar.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  static Color _hex(String hex, Color fallback) {
    final h = hex.replaceAll('#', '');
    if (h.length == 6) {
      final v = int.tryParse('FF$h', radix: 16);
      if (v != null) return Color(v);
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCmsCubit, HomeCmsState>(
      builder: (context, homeState) {
        final branding = switch (homeState) {
          HomeCmsLoaded(:final data) => data.branding,
          HomeCmsSaved(:final data)  => data.branding,
          _ => context.read<HomeCmsCubit>().current.branding,
        };
        final Color primary = _hex(branding.primaryColor, const Color(0xFF008037));
        final Color bg = _hex(branding.backgroundColor, const Color(0xFFF1F2ED));

        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, lang) {
            final bool ar = lang.isArabic;
            return Directionality(
              textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
              child: Scaffold(
                backgroundColor: bg,
                body: Column(
                  children: [
                    const AppNavbar(currentRoute: ''),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '404',
                                style: TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.w800,
                                  color: primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ar ? 'الصفحة غير موجودة' : 'Page not found',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                ar
                                    ? 'الرابط الذي فتحته غير موجود أو تم نقله.'
                                    : 'The link you opened does not exist or has moved.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 28),
                              ElevatedButton(
                                onPressed: () => context.go('/'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Text(ar ? 'العودة إلى الرئيسية' : 'Back to Home'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
