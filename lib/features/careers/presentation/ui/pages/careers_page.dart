// ******************* FILE INFO *******************
// File Name: careers_page.dart
// Created by: Amr Mesbah
// UPDATED: backgroundColor now dynamic from CMS branding.backgroundColor ✅
// Updated: Full AR/EN bilingual support added to all static data.
//          isRtl passed through entire widget tree.
//          Directionality wrapper applied at Scaffold level.
//          All static strings use _t(en, ar, isRtl) helper.
// FIX: secondaryColor from branding applied to tab icon boxes and team card icon boxes.
// UPDATED: Deep-link support — reads ?tab=<key> from GoRouter query params
//          and auto-selects the correct tab on load.
// UPDATED: Careers overview description + action button label now read from
//          CareersCmsCubit (Firebase) instead of hardcoded strings.
//          Career statistics (title + shortDescription) now read from Firebase.
// UPDATED: Why Join Our Team, Our Interns, Our Teams all read from Firebase.
//          Zero UI changes — only data sources replaced.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:website_app/core/widgets/button.dart';
import 'package:website_app/core/widgets/navigator.dart';

import '../../../../../core/main_widgets/app_footer.dart';
import '../../../../../core/main_widgets/app_navbar.dart';
import '../../../../../core/theme/appcolors.dart';
import '../../../../../core/theme/new_theme.dart';
import '../../../../home/presentation/controller/home_cubit.dart';
import '../../../../home/presentation/controller/home_state.dart';
import '../../../../home/presentation/controller/lang_state.dart';
import '../../../data/models/careers_model.dart';
import '../../../data/models/careers_section_model.dart';
import '../../../data/models/intern_model.dart';
import '../../../data/models/our_teams_model.dart';
import '../../controller/careers_cubit.dart';
import '../../controller/careers_state.dart';
import '../../controller/careers_section_cubit.dart';
import '../../controller/careers_section_state.dart';
import '../../controller/intern_cubit.dart';
import '../../controller/intern_state.dart';
import '../../controller/our_teams_cubit.dart';
import '../../controller/our_teams_state.dart';

part '../widgets/careers_helpers.dart';
part '../widgets/reveal_coordinator.dart';
part '../widgets/reveal_coordinator_widget.dart';
part '../widgets/reveal.dart';
part '../widgets/tab_item.dart';
part '../widgets/svg_pulse_loader.dart';
part '../widgets/mobile_body.dart';
part '../widgets/mobile_header_card.dart';
part '../widgets/mobile_bullet.dart';
part '../widgets/mobile_plain.dart';
part '../widgets/mobile_stats_section.dart';
part '../widgets/mobile_tab_bar.dart';
part '../widgets/mobile_why_join_tab.dart';
part '../widgets/mobile_interns_tab.dart';
part '../widgets/mobile_intern_card.dart';
part '../widgets/mobile_our_team_tab.dart';
part '../widgets/mobile_team_card.dart';
part '../widgets/deliverable_buttons.dart';
part '../widgets/desktop_body.dart';
part '../widgets/desktop_why_join_tab.dart';
part '../widgets/desktop_interns_tab.dart';
part '../widgets/desktop_intern_card.dart';
part '../widgets/desktop_our_team_tab.dart';
part '../widgets/desktop_team_card.dart';
part '../widgets/desktop_deliverable_buttons.dart';
part '../widgets/bullet_text.dart';
part '../widgets/plain_text.dart';
part '../widgets/apply_now_btn_desktop.dart';

// ── Bilingual helper ──────────────────────────────────────────────────────────
String _t(String en, String ar, bool isRtl) => isRtl ? ar : en;

// ── Fallback colors ───────────────────────────────────────────────────────────
const Color _kFallbackPrimary = Color(0xFF2D8C4E);
const Color _kFallbackSecondary = Color(0xFFE8F5EE);
const Color _kDivider = Color(0xFFDDE8DD);

Color _parseColor(String hex, {Color fallback = _kFallbackPrimary}) {
  final h = hex.replaceAll('#', '');
  if (h.length == 6) {
    final value = int.tryParse('FF$h', radix: 16);
    if (value != null) return Color(value);
  }
  return fallback;
}

// ── Breakpoints ───────────────────────────────────────────────────────────────

class CareersPage extends StatefulWidget {
  const CareersPage({super.key});

  @override
  State<CareersPage> createState() => _CareersPageState();
}

class _CareersPageState extends State<CareersPage> {
  bool _showLoader = true;
  int _selectedTab = 0;

  // Dedicated section cubit for the "Our Interns" tab header (icon + title).
  // Kept as an explicit instance (not a global provider) to avoid clashing
  // with the type-based CareersSectionCubit used for 'whyJoinOurTeam'.
  final CareersSectionCubit _internsSection =
      CareersSectionCubit(sectionKey: 'ourInterns');

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 12), () {
      if (mounted && _showLoader) setState(() => _showLoader = false);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCmsCubit>().load();
      context.read<CareersCmsCubit>().load();
      // ── Load Firebase data for all three tab sections ──────────────────
      context
          .read<CareersSectionCubit>()
          .load(); // sectionKey == 'whyJoinOurTeam'
      context.read<InternCubit>().load();
      context.read<OurTeamsCubit>().load();
      _internsSection.load(); // sectionKey == 'ourInterns' (header icon+title)
      _readTabParam();
    });
  }

  @override
  void dispose() {
    _internsSection.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _readTabParam();
  }

  void _readTabParam() {
    if (!mounted) return;
    final uri = GoRouterState.of(context).uri;
    final tabParam = uri.queryParameters['tab'];
    final resolved = (tabParam != null && tabParam.isNotEmpty)
        ? _resolveTabParam(tabParam)
        : 0;
    if (_selectedTab != resolved) {
      setState(() => _selectedTab = resolved);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCmsCubit, HomeCmsState>(
      listener: (context, state) {
        if (state is HomeCmsLoaded || state is HomeCmsSaved) {
          final careersState = context.read<CareersCmsCubit>().state;
          final careersReady = careersState is CareersCmsLoaded ||
              careersState is CareersCmsError;
          if (careersReady) {
            Future.delayed(const Duration(milliseconds: 800), () {
              if (mounted) setState(() => _showLoader = false);
            });
          }
        }
        if (state is HomeCmsError && state.lastData == null) {
          setState(() => _showLoader = false);
        }
      },
      builder: (context, homeState) {
        final String logoUrl = switch (homeState) {
          HomeCmsLoaded(:final data) => data.branding.logoUrl,
          HomeCmsSaved(:final data) => data.branding.logoUrl,
          _ => context.read<HomeCmsCubit>().current.branding.logoUrl,
        };

        final Color primary = switch (homeState) {
          HomeCmsLoaded(:final data) => _parseColor(data.branding.primaryColor),
          HomeCmsSaved(:final data) => _parseColor(data.branding.primaryColor),
          _ => _kFallbackPrimary,
        };

        final Color secondary = switch (homeState) {
          HomeCmsLoaded(:final data) => _parseColor(
            data.branding.secondaryColor,
            fallback: _kFallbackSecondary,
          ),
          HomeCmsSaved(:final data) => _parseColor(
            data.branding.secondaryColor,
            fallback: _kFallbackSecondary,
          ),
          _ => _kFallbackSecondary,
        };

        final Color backgroundColor = switch (homeState) {
          HomeCmsLoaded(:final data) => _parseColor(
            data.branding.backgroundColor,
            fallback: AppColors.background,
          ),
          HomeCmsSaved(:final data) => _parseColor(
            data.branding.backgroundColor,
            fallback: AppColors.background,
          ),
          _ => AppColors.background,
        };

        if (_showLoader) {
          return BlocListener<CareersCmsCubit, CareersCmsState>(
            listener: (context, careersState) {
              final homeReady =
                  context.read<HomeCmsCubit>().state is HomeCmsLoaded ||
                      context.read<HomeCmsCubit>().state is HomeCmsSaved;
              final careersReady = careersState is CareersCmsLoaded ||
                  careersState is CareersCmsError;
              if (homeReady && careersReady) {
                Future.delayed(const Duration(milliseconds: 800), () {
                  if (mounted) setState(() => _showLoader = false);
                });
              }
            },
            child: _SvgPulseLoader(
              logoUrl: logoUrl.isEmpty ? null : logoUrl,
              backgroundColor: _parseColor(
                context.read<HomeCmsCubit>().current.branding.backgroundColor,
                fallback: AppColors.background,
              ),
            ),
          );
        }

        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, langState) {
            final bool isRtl = langState.isArabic;
            final double screenW = MediaQuery.of(context).size.width;
            final bool isMobile = screenW < _BP.mobile;

            return BlocBuilder<CareersCmsCubit, CareersCmsState>(
              builder: (context, careersState) {
                final CareersCmsModel careersData =
                    context.read<CareersCmsCubit>().current;

                // ── Why Join Our Team items from Firebase ──────────────────
                return BlocBuilder<CareersSectionCubit, CareersSectionState>(
                  builder: (context, whyJoinState) {
                    final List<CareersSectionItem> whyJoinItems =
                    switch (whyJoinState) {
                      CareersSectionLoaded(:final data) => data.items,
                      CareersSectionSaved(:final data) => data.items,
                      _ => context.read<CareersSectionCubit>().current.items,
                    };

                    // ── Interns from Firebase ────────────────────────────────
                    return BlocBuilder<InternCubit, InternState>(
                      builder: (context, internState) {
                        final List<InternModel> interns = switch (internState) {
                          InternLoaded(:final interns) => interns,
                          InternCreated(:final interns) => interns,
                          InternUpdated(:final interns) => interns,
                          InternDeleted(:final interns) => interns,
                          _ => context.read<InternCubit>().interns,
                        };

                        // ── Our Teams from Firebase ──────────────────────────
                        return BlocBuilder<OurTeamsCubit, OurTeamsState>(
                          builder: (context, teamsState) {
                            final OurTeamsModel teamsModel =
                            switch (teamsState) {
                              OurTeamsLoaded(:final data) => data,
                              OurTeamsSaved(:final data) => data,
                              _ => context.read<OurTeamsCubit>().current,
                            };
                            final List<OurTeamItem> teams = teamsModel.items;
                            final String teamIconUrl =
                                teamsModel.headerIconUrl;
                            final String teamTitle = isRtl
                                ? teamsModel.headerTitle.ar
                                : teamsModel.headerTitle.en;

                            // ── "Our Interns" header (icon + title) ──────────
                            return BlocBuilder<CareersSectionCubit,
                                CareersSectionState>(
                              bloc: _internsSection,
                              builder: (context, internsSecState) {
                                final List<CareersSectionItem> internsHeader =
                                    switch (internsSecState) {
                                  CareersSectionLoaded(:final data) => data.items,
                                  CareersSectionSaved(:final data) => data.items,
                                  _ => _internsSection.current.items,
                                };
                                final String internsIconUrl =
                                    internsHeader.isNotEmpty
                                        ? internsHeader.first.iconUrl
                                        : '';
                                final String internsTitle =
                                    internsHeader.isNotEmpty
                                        ? (isRtl
                                            ? internsHeader.first.title.ar
                                            : internsHeader.first.title.en)
                                        : '';

                            return Directionality(
                              textDirection: isRtl
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: Scaffold(
                                backgroundColor: backgroundColor,
                                body: _RevealCoordinatorWidget(
                                  child: Column(
                                    children: [
                                      Material(
                                        color: backgroundColor,
                                        elevation: 0,
                                        child: AppNavbar(
                                            currentRoute: '/careers'),
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              isMobile
                                                  ? _MobileBody(
                                                selectedTab: _selectedTab,
                                                onTabChange: (i) =>
                                                    setState(() =>
                                                    _selectedTab = i),
                                                primary: primary,
                                                secondary: secondary,
                                                isRtl: isRtl,
                                                careersData: careersData,
                                                whyJoinItems:
                                                whyJoinItems,
                                                interns: interns,
                                                teams: teams,
                                                internsIconUrl:
                                                internsIconUrl,
                                                internsTitle: internsTitle,
                                                teamIconUrl: teamIconUrl,
                                                teamTitle: teamTitle,
                                              )
                                                  : _DesktopBody(
                                                selectedTab: _selectedTab,
                                                onTabChange: (i) =>
                                                    setState(() =>
                                                    _selectedTab = i),
                                                primary: primary,
                                                secondary: secondary,
                                                isRtl: isRtl,
                                                careersData: careersData,
                                                whyJoinItems:
                                                whyJoinItems,
                                                interns: interns,
                                                teams: teams,
                                                internsIconUrl:
                                                internsIconUrl,
                                                internsTitle: internsTitle,
                                                teamIconUrl: teamIconUrl,
                                                teamTitle: teamTitle,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      _Reveal(
                                        delay:
                                        const Duration(milliseconds: 100),
                                        direction: _SlideDirection.fromBottom,
                                        duration:
                                        const Duration(milliseconds: 600),
                                        child: const AppFooter(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MOBILE BODY
// ═══════════════════════════════════════════════════════════════════════════════
