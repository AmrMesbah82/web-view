part of '../pages/contact_us_page.dart';

class _ContactPageView extends StatefulWidget {
  const _ContactPageView();
  @override
  State<_ContactPageView> createState() => _ContactPageViewState();
}

class _ContactPageViewState extends State<_ContactPageView> {
  // ── Name / contact controllers ──
  final _firstNameCtrl        = TextEditingController();
  final _lastNameCtrl         = TextEditingController();
  final _emailCtrl            = TextEditingController();
  final _phoneCtrl            = TextEditingController();
  final _entityNameCtrl       = TextEditingController();
  final _subjectCtrl          = TextEditingController();
  final _messageCtrl          = TextEditingController();
  // ── NEW: "Other" language free-text controller ──
  final _otherLanguageCtrl    = TextEditingController();

  String _phoneCode          = '+20';
  String _preferredLanguage  = 'ar';     // Default: Arabic (matches Figma)
  String? _selectedLocation;              // Country name
  String? _selectedEntityType;
  String? _selectedEntitySize;

  bool   _submitted      = false;
  bool   _showLoader     = true;
  bool   _preloadStarted = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 12), () {
      if (mounted && _showLoader) setState(() => _showLoader = false);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCmsCubit>().load();
    });
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _entityNameCtrl.dispose();
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    _otherLanguageCtrl.dispose(); // ← NEW
    super.dispose();
  }

  Future<void> _preloadAndReveal({
    required String logoUrl,
    required ContactUsCmsModel? cmsData,
  }) async {
    if (_preloadStarted) return;
    _preloadStarted = true;

    // NOTE: do NOT clear svg.cache here — it wiped the cached SVGs for every
    // other page too, forcing a full re-download on the next navigation. The
    // preload below already fetches any icons that aren't cached yet.

    final List<String> allUrls = [
      if (logoUrl.isNotEmpty) logoUrl,
      if (cmsData != null)
        for (final icon in cmsData.socialIcons)
          if (icon.iconUrl.isNotEmpty) icon.iconUrl,
      if (cmsData != null)
        for (final office in cmsData.officeLocations)
          if (office.iconUrl.isNotEmpty) office.iconUrl,
      if (cmsData != null && cmsData.confirmMessage.svgUrl.isNotEmpty)
        cmsData.confirmMessage.svgUrl,
    ];

    await _preloadSvgImages(allUrls)
        .timeout(const Duration(milliseconds: 700), onTimeout: () {});
    if (mounted) setState(() => _showLoader = false);
  }

  void _onSend() {
    setState(() => _submitted = true);

    // ── Validate required fields ──
    final requiredTextFilled = [
      _firstNameCtrl, _lastNameCtrl, _emailCtrl, _phoneCtrl,
      _subjectCtrl, _messageCtrl,
    ].every((c) => c.text.trim().isNotEmpty);

    // If "Other" is selected, the custom language field is also required
    final otherLangFilled = _preferredLanguage != _kOtherLanguage ||
        _otherLanguageCtrl.text.trim().isNotEmpty;

    final dropdownsFilled = _selectedLocation != null &&
        _selectedEntityType != null &&
        _selectedEntitySize != null;

    if (!requiredTextFilled || !dropdownsFilled || !otherLangFilled) return;

    String phoneNumber = _phoneCtrl.text.trim();
    if (phoneNumber.startsWith('0')) phoneNumber = phoneNumber.substring(1);

    final fullPhone = '$_phoneCode$phoneNumber';

    // Resolve actual locale string: use custom text when "Other" selected
    final locale = _preferredLanguage == _kOtherLanguage
        ? _otherLanguageCtrl.text.trim()
        : _preferredLanguage == 'ar'
        ? 'ar'
        : 'en';

    context.read<ContactOtpCubit>().sendOtp(
      phoneNumber: fullPhone,
      locale:      locale,
    );
  }

  void _submitContactForm() async {






    // Resolve the final preferredLanguage value saved to Firestore
    final resolvedLanguage = _preferredLanguage == _kOtherLanguage
        ? _otherLanguageCtrl.text.trim()
        : _preferredLanguage;

    final submission = ContactSubmission(
      id:                '',
      firstName:         _firstNameCtrl.text.trim(),
      lastName:          _lastNameCtrl.text.trim(),
      email:             _emailCtrl.text.trim(),
      countryCode:       _phoneCode,
      phoneNumber:       _phoneCtrl.text.trim(),
      preferredLanguage: resolvedLanguage,
      location:          _selectedLocation ?? '',
      entityName:        _entityNameCtrl.text.trim(),
      entityType:        _selectedEntityType ?? '',
      entitySize:        _selectedEntitySize ?? '',
      subject:           _subjectCtrl.text.trim(),
      message:           _messageCtrl.text.trim(),
      submissionDate:    DateTime.now(),
    );
    context.read<ContactCubit>().submitContact(submission);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCmsCubit, HomeCmsState>(
      builder: (context, homeState) {
        final String logoUrl = switch (homeState) {
          HomeCmsLoaded(:final data) => data.branding.logoUrl,
          HomeCmsSaved(:final data)  => data.branding.logoUrl,
          _ => context.read<HomeCmsCubit>().current.branding.logoUrl,
        };

        final Color primaryColor = switch (homeState) {
          HomeCmsLoaded(:final data) => _parseColor(
              data.branding.primaryColor,
              fallback: _kDefaultGreen),
          HomeCmsSaved(:final data) => _parseColor(
              data.branding.primaryColor,
              fallback: _kDefaultGreen),
          _ => _kDefaultGreen,
        };

        final Color backgroundColor = switch (homeState) {
          HomeCmsLoaded(:final data) => _parseColor(
              data.branding.backgroundColor,
              fallback: AppColors.background),
          HomeCmsSaved(:final data) => _parseColor(
              data.branding.backgroundColor,
              fallback: AppColors.background),
          _ => AppColors.background,
        };

        final Color loaderBg = switch (homeState) {
          HomeCmsLoaded(:final data) => _parseColor(
              data.branding.backgroundColor,
              fallback: AppColors.background),
          HomeCmsSaved(:final data) => _parseColor(
              data.branding.backgroundColor,
              fallback: AppColors.background),
          _ => _kLoaderNeutral,
        };

        final bool homeReady =
            homeState is HomeCmsLoaded || homeState is HomeCmsSaved;

        if (homeState is HomeCmsError &&
            homeState.lastData == null &&
            _showLoader &&
            !_preloadStarted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _showLoader = false);
          });
        }

        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, langState) {
            final isRtl = langState.isArabic;

            return Directionality(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: MultiBlocListener(
                listeners: [
                  BlocListener<ContactOtpCubit, ContactOtpState>(
                    listener: (context, otpState) {
                      if (otpState is OtpSent) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => BlocProvider.value(
                            value: context.read<ContactOtpCubit>(),
                            child: _OtpDialog(
                              phoneNumber:  otpState.phoneNumber,
                              isRtl:        isRtl,
                              primaryColor: primaryColor,
                              onVerified: () {
                                Navigator.of(context).pop();
                                _submitContactForm();
                              },
                            ),
                          ),
                        );
                      }
                      if (otpState is OtpError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:         Text('OTP Error: ${otpState.message}'),
                            backgroundColor: Colors.red,
                            duration:        const Duration(seconds: 5),
                          ),
                        );
                      }
                    },
                  ),
                  BlocListener<ContactCubit, ContactState>(
                    listener: (context, state) {
                      if (state is ContactSubmitted) {
                        _firstNameCtrl.clear();
                        _lastNameCtrl.clear();
                        _emailCtrl.clear();
                        _phoneCtrl.clear();
                        _entityNameCtrl.clear();
                        _subjectCtrl.clear();
                        _messageCtrl.clear();
                        _otherLanguageCtrl.clear(); // ← NEW: clear on success
                        setState(() {
                          _submitted          = false;
                          _preferredLanguage   = 'ar';
                          _selectedLocation    = null;
                          _selectedEntityType  = null;
                          _selectedEntitySize  = null;
                        });

                        final cmsState =
                            context.read<ContactUsCmsCubit>().state;
                        ContactUsCmsModel? cmsData;
                        if (cmsState is ContactUsCmsLoaded) {
                          cmsData = cmsState.data;
                        }

                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => _SuccessDialog(
                            cmsData:      cmsData,
                            isRtl:        isRtl,
                            primaryColor: primaryColor,
                          ),
                        );
                      }
                      if (state is ContactError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:         Text('Error: ${state.message}'),
                            backgroundColor: Colors.red,
                            duration:        const Duration(seconds: 5),
                          ),
                        );
                      }
                    },
                  ),
                ],
                child: BlocBuilder<ContactUsCmsCubit, ContactUsCmsState>(
                  builder: (context, cmsState) {
                    final bool cmsReady = cmsState is ContactUsCmsLoaded ||
                        cmsState is ContactUsCmsError;

                    ContactUsCmsModel? cmsData;
                    if (cmsState is ContactUsCmsLoaded) {
                      cmsData = cmsState.data;
                    }

                    if (homeReady && cmsReady && !_preloadStarted) {
                      _preloadAndReveal(
                          logoUrl: logoUrl, cmsData: cmsData);
                    }

                    if (_showLoader || !cmsReady || !homeReady) {
                      return _SvgPulseLoader(
                        logoUrl:         logoUrl.isEmpty ? null : logoUrl,
                        backgroundColor: loaderBg,
                      );
                    }

                    return BlocBuilder<ContactCubit, ContactState>(
                      builder: (context, contactState) {
                        final isSending =
                        contactState is ContactSubmitting;
                        final isMobile = MediaQuery.of(context).size.width <
                            _BP.mobile;

                        return Scaffold(
                          backgroundColor: backgroundColor,
                          body: Stack(
                            children: [
                              _RevealCoordinatorWidget(
                                child: Column(
                                  children: [
                                    // ✅ Navbar — always visible at top
                                    Material(
                                      color: backgroundColor,
                                      elevation: 0,
                                      child: AppNavbar(currentRoute: '/contact'),
                                    ),

                                    // ✅ Middle content — scrolls, takes all remaining space
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            _Reveal(
                                              delay: const Duration(milliseconds: 80),
                                              direction: _SlideDirection.fromLeft,
                                              duration: const Duration(milliseconds: 650),
                                              child: isMobile
                                                  ? _MobileBody(
                                                firstNameCtrl:       _firstNameCtrl,
                                                lastNameCtrl:        _lastNameCtrl,
                                                emailCtrl:           _emailCtrl,
                                                phoneCtrl:           _phoneCtrl,
                                                entityNameCtrl:      _entityNameCtrl,
                                                subjectCtrl:         _subjectCtrl,
                                                messageCtrl:         _messageCtrl,
                                                otherLanguageCtrl:   _otherLanguageCtrl,
                                                submitted:           _submitted,
                                                phoneCode:           _phoneCode,
                                                preferredLanguage:   _preferredLanguage,
                                                selectedLocation:    _selectedLocation,
                                                selectedEntityType:  _selectedEntityType,
                                                selectedEntitySize:  _selectedEntitySize,
                                                isRtl:               isRtl,
                                                primaryColor:        primaryColor,
                                                onCodeChanged:       (v) => setState(() => _phoneCode = v ?? _phoneCode),
                                                onLanguageChanged:   (v) => setState(() => _preferredLanguage = v),
                                                onLocationChanged:   (v) => setState(() => _selectedLocation = v),
                                                onEntityTypeChanged: (v) => setState(() => _selectedEntityType = v),
                                                onEntitySizeChanged: (v) => setState(() => _selectedEntitySize = v),
                                                onSend:              _onSend,
                                                cmsData:             cmsData,
                                              )
                                                  : _DesktopBody(
                                                firstNameCtrl:       _firstNameCtrl,
                                                lastNameCtrl:        _lastNameCtrl,
                                                emailCtrl:           _emailCtrl,
                                                phoneCtrl:           _phoneCtrl,
                                                entityNameCtrl:      _entityNameCtrl,
                                                subjectCtrl:         _subjectCtrl,
                                                messageCtrl:         _messageCtrl,
                                                otherLanguageCtrl:   _otherLanguageCtrl,
                                                submitted:           _submitted,
                                                phoneCode:           _phoneCode,
                                                preferredLanguage:   _preferredLanguage,
                                                selectedLocation:    _selectedLocation,
                                                selectedEntityType:  _selectedEntityType,
                                                selectedEntitySize:  _selectedEntitySize,
                                                isRtl:               isRtl,
                                                primaryColor:        primaryColor,
                                                onCodeChanged:       (v) => setState(() => _phoneCode = v ?? _phoneCode),
                                                onLanguageChanged:   (v) => setState(() => _preferredLanguage = v),
                                                onLocationChanged:   (v) => setState(() => _selectedLocation = v),
                                                onEntityTypeChanged: (v) => setState(() => _selectedEntityType = v),
                                                onEntitySizeChanged: (v) => setState(() => _selectedEntitySize = v),
                                                onSend:              _onSend,
                                                cmsData:             cmsData,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // ✅ Footer — always visible at bottom
                                    _Reveal(
                                      delay: const Duration(milliseconds: 100),
                                      direction: _SlideDirection.fromBottom,
                                      duration: const Duration(milliseconds: 600),
                                      child: const AppFooter(),
                                    ),
                                  ],
                                ),
                              ),

                              // ✅ Loading overlay
                              if (isSending)
                                Container(
                                  color: Colors.black45,
                                  child: Center(
                                    child: Container(
                                      width: isMobile ? double.infinity : 600.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircleProgressMaster(),
                                          SizedBox(height: 8.h),
                                          Text(
                                            isRtl
                                                ? 'جاري ارسال البيانات التي قد ملتها وسيتم الرد عليك بعد اتمما العملية...'
                                                : 'The information you have filled out is being sent, and you will be answered after you complete the process…',
                                            style: StyleText.fontSize13Weight400,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// OTP VERIFICATION DIALOG — Figma-accurate design
// ═══════════════════════════════════════════════════════════════════════════════
