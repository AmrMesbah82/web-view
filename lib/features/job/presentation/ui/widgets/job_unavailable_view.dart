// ******************* FILE INFO *******************
// File Name: job_unavailable_view.dart
// Purpose: BUG-99 / BUG-109 — one branded, bilingual page for a job that
//          cannot be shown:
//            • unknown id                    → "Job not found"
//            • removed / ended / draft / full → "This job is no longer available"
//            • scheduled (hiring starts later)→ "Applications open on <date>"
//          Site header + footer and a link back to the job list (like the 404).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/main_widgets/app_footer.dart';
import '../../../../../core/main_widgets/app_navbar.dart';
import '../../../../../core/widgets/format_helper.dart';
import '../../../../../core/widgets/scroll_with_footer.dart';
import '../../../../home/presentation/controller/home_cubit.dart';
import '../../../../home/presentation/controller/home_state.dart';
import '../../../../home/presentation/controller/lang_state.dart';

enum JobUnavailableReason { notFound, closed, notStarted }

class JobUnavailableView extends StatelessWidget {
  const JobUnavailableView({
    super.key,
    required this.reason,
    this.opensOn,
  });

  final JobUnavailableReason reason;

  /// Hiring start date, for [JobUnavailableReason.notStarted].
  final DateTime? opensOn;

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
          HomeCmsSaved(:final data) => data.branding,
          _ => context.read<HomeCmsCubit>().current.branding,
        };
        final Color primary =
            _hex(branding.primaryColor, const Color(0xFF008037));
        final Color bg = _hex(branding.backgroundColor, const Color(0xFFF1F2ED));

        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, lang) {
            final bool ar = lang.isArabic;
            final String title = switch (reason) {
              JobUnavailableReason.notFound =>
                ar ? 'الوظيفة غير موجودة' : 'Job not found',
              JobUnavailableReason.closed => ar
                  ? 'هذه الوظيفة لم تعد متاحة'
                  : 'This job is no longer available',
              JobUnavailableReason.notStarted => ar
                  ? 'التقديم على هذه الوظيفة لم يبدأ بعد'
                  : 'Applications for this job have not opened yet',
            };
            final String body = switch (reason) {
              JobUnavailableReason.notFound => ar
                  ? 'الرابط الذي فتحته غير صحيح أو تم حذف الوظيفة.'
                  : 'The link you opened is wrong or the job was deleted.',
              JobUnavailableReason.closed => ar
                  ? 'تم إغلاق التقديم على هذه الوظيفة. اطّلع على الوظائف المتاحة حالياً.'
                  : 'Applications for this position are closed. Have a look at our current openings.',
              JobUnavailableReason.notStarted => opensOn == null
                  ? (ar ? 'تابعنا قريباً.' : 'Please check back soon.')
                  : (ar
                      ? 'يبدأ التقديم في ${FormDateTimeHelper.formatDayMonthYear(opensOn!, arabic: true)}.'
                      : 'Applications open on ${FormDateTimeHelper.formatDayMonthYear(opensOn!, arabic: false)}.'),
            };

            return Directionality(
              textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
              child: Scaffold(
                backgroundColor: bg,
                body: Column(
                  children: [
                    const AppNavbar(currentRoute: '/careers'),
                    Expanded(
                      child: ScrollWithFooter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 80),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 560),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.work_off_outlined,
                                      size: 64, color: primary),
                                  const SizedBox(height: 16),
                                  Text(
                                    title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    body,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      height: 1.5,
                                      color: Color(0xFF555555),
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  ElevatedButton(
                                    onPressed: () => context.go('/jobs'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 28, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    child: Text(ar
                                        ? 'عرض الوظائف المتاحة'
                                        : 'See open positions'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        footer: const AppFooter(),
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
