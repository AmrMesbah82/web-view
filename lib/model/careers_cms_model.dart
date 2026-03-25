// ******************* FILE INFO *******************
// File Name: careers_cms_model.dart
// Created by: Amr Mesbah
// Purpose: Model for Careers CMS — Overview + Statistics + Dashboard Charts

// ── Bilingual text ────────────────────────────────────────────────────────────

class BilingualText {
  final String en;
  final String ar;

  const BilingualText({this.en = '', this.ar = ''});

  factory BilingualText.fromMap(Map<String, dynamic> map) => BilingualText(
    en: map['en'] as String? ?? '',
    ar: map['ar'] as String? ?? '',
  );

  Map<String, dynamic> toMap() => {'en': en, 'ar': ar};

  BilingualText copyWith({String? en, String? ar}) =>
      BilingualText(en: en ?? this.en, ar: ar ?? this.ar);

  bool get isEmpty => en.isEmpty && ar.isEmpty;
}

// ── Career Statistic Item ─────────────────────────────────────────────────────

class CareerStatItem {
  final String id;
  final BilingualText title;
  final BilingualText shortDescription;
  final String summaryValue;

  const CareerStatItem({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.summaryValue,
  });

  factory CareerStatItem.empty() => CareerStatItem(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    title: const BilingualText(),
    shortDescription: const BilingualText(),
    summaryValue: '',
  );

  factory CareerStatItem.fromMap(String id, Map<String, dynamic> map) =>
      CareerStatItem(
        id: id,
        title: BilingualText.fromMap(
            (map['title'] as Map<String, dynamic>?) ?? {}),
        shortDescription: BilingualText.fromMap(
            (map['shortDescription'] as Map<String, dynamic>?) ?? {}),
        summaryValue: map['summaryValue'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
    'title': title.toMap(),
    'shortDescription': shortDescription.toMap(),
    'summaryValue': summaryValue,
  };

  CareerStatItem copyWith({
    String? id,
    BilingualText? title,
    BilingualText? shortDescription,
    String? summaryValue,
  }) =>
      CareerStatItem(
        id: id ?? this.id,
        title: title ?? this.title,
        shortDescription: shortDescription ?? this.shortDescription,
        summaryValue: summaryValue ?? this.summaryValue,
      );
}

// ── Careers Overview ─────────────────────────────────────────────────────────

class CareersOverview {
  final BilingualText description;
  final BilingualText actionButtonLabel;

  const CareersOverview({
    required this.description,
    required this.actionButtonLabel,
  });

  factory CareersOverview.empty() => const CareersOverview(
    description: BilingualText(),
    actionButtonLabel: BilingualText(),
  );

  factory CareersOverview.fromMap(Map<String, dynamic> map) => CareersOverview(
    description: BilingualText.fromMap(
        (map['description'] as Map<String, dynamic>?) ?? {}),
    actionButtonLabel: BilingualText.fromMap(
        (map['actionButtonLabel'] as Map<String, dynamic>?) ?? {}),
  );

  Map<String, dynamic> toMap() => {
    'description': description.toMap(),
    'actionButtonLabel': actionButtonLabel.toMap(),
  };

  CareersOverview copyWith({
    BilingualText? description,
    BilingualText? actionButtonLabel,
  }) =>
      CareersOverview(
        description: description ?? this.description,
        actionButtonLabel: actionButtonLabel ?? this.actionButtonLabel,
      );
}

// ── Dashboard Stat Card ──────────────────────────────────────────────────────

class DashboardStatCard {
  final String label;
  final int value;
  final String iconAsset; // e.g. 'assets/icons/ic_all_jobs.svg'

  const DashboardStatCard({
    required this.label,
    required this.value,
    this.iconAsset = '',
  });

  factory DashboardStatCard.fromMap(Map<String, dynamic> map) =>
      DashboardStatCard(
        label: map['label'] as String? ?? '',
        value: map['value'] as int? ?? 0,
        iconAsset: map['iconAsset'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
    'label': label,
    'value': value,
    'iconAsset': iconAsset,
  };
}

// ── Hiring Stage Item (for funnel chart) ─────────────────────────────────────

class HiringStageItem {
  final String label;
  final int value;

  const HiringStageItem({required this.label, required this.value});

  factory HiringStageItem.fromMap(Map<String, dynamic> map) => HiringStageItem(
    label: map['label'] as String? ?? '',
    value: map['value'] as int? ?? 0,
  );

  Map<String, dynamic> toMap() => {'label': label, 'value': value};
}

// ── Score Distribution Item ──────────────────────────────────────────────────

class ScoreDistributionItem {
  final String label;
  final int value;
  final String colorHex;

  const ScoreDistributionItem({
    required this.label,
    required this.value,
    required this.colorHex,
  });

  factory ScoreDistributionItem.fromMap(Map<String, dynamic> map) =>
      ScoreDistributionItem(
        label: map['label'] as String? ?? '',
        value: map['value'] as int? ?? 0,
        colorHex: map['colorHex'] as String? ?? '#CCCCCC',
      );

  Map<String, dynamic> toMap() => {
    'label': label,
    'value': value,
    'colorHex': colorHex,
  };
}

// ── Careers Dashboard Data ───────────────────────────────────────────────────

class CareersDashboardData {
  // Stat cards
  final List<DashboardStatCard> statCards;

  // Applications Received — monthly bar chart
  final List<String> appReceivedLabels;
  final List<double> appReceivedValues;

  // Job Posting Status — grouped bar chart
  final List<String> jobPostingLabels;
  final List<double> jobPostingActive;
  final List<double> jobPostingClosed;
  final List<double> jobPostingScheduled;
  final List<double> jobPostingDraft;

  // Hiring Stage — funnel
  final List<HiringStageItem> hiringStages;

  // Job Status — pie chart
  final Map<String, double> jobStatus; // e.g. {'Active': 30, 'Scheduled': 20, ...}
  final int jobStatusTotal;

  // Candidate Quality — pie chart
  final double qualifiedPercent;
  final double unqualifiedPercent;
  final int totalApplications;

  // Jobs Performance — grouped bar per role
  final List<String> performanceRoles;
  final List<double> performanceApplications;
  final List<double> performanceInterviews;
  final List<double> performanceHires;

  // Job Offer — pie chart
  final int jobOfferApproved;
  final int jobOfferPending;
  final int jobOfferRejected;

  // Candidate Score Distribution — segmented bar
  final List<ScoreDistributionItem> scoreDistribution;

  // Employment Types — horizontal bar + pie
  final Map<String, double> employmentTypes; // e.g. {'Intern': 40, 'Junior': 30, ...}

  // Candidate Gender — pie chart
  final double malePercent;
  final double femalePercent;

  const CareersDashboardData({
    required this.statCards,
    required this.appReceivedLabels,
    required this.appReceivedValues,
    required this.jobPostingLabels,
    required this.jobPostingActive,
    required this.jobPostingClosed,
    required this.jobPostingScheduled,
    required this.jobPostingDraft,
    required this.hiringStages,
    required this.jobStatus,
    required this.jobStatusTotal,
    required this.qualifiedPercent,
    required this.unqualifiedPercent,
    required this.totalApplications,
    required this.performanceRoles,
    required this.performanceApplications,
    required this.performanceInterviews,
    required this.performanceHires,
    required this.jobOfferApproved,
    required this.jobOfferPending,
    required this.jobOfferRejected,
    required this.scoreDistribution,
    required this.employmentTypes,
    required this.malePercent,
    required this.femalePercent,
  });

  /// Static hardcoded data matching the Figma design
  factory CareersDashboardData.demo() => CareersDashboardData(
    statCards: const [
      DashboardStatCard(label: 'All Jobs',          value: 1000, iconAsset: 'assets/images/job_list/all_job.svg'),
      DashboardStatCard(label: 'Office Jobs',       value: 3,    iconAsset: 'assets/images/job_list/office_job.svg'),
      DashboardStatCard(label: 'Remote Jobs',       value: 3,    iconAsset: 'assets/images/job_list/remote_job.svg'),
      DashboardStatCard(label: 'Active Job',        value: 3,    iconAsset: 'assets/images/job_list/active_job.svg'),
      DashboardStatCard(label: 'Recruitment Ended', value: 3,    iconAsset: 'assets/images/job_list/requiement_end.svg'),
      DashboardStatCard(label: 'Drafted',           value: 3,    iconAsset: 'assets/images/job_list/dradt.svg'),
    ],
    appReceivedLabels: const [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ],
    appReceivedValues: const [
      320, 280, 350, 300, 420, 380,
      450, 400, 360, 300, 340, 390,
    ],
    jobPostingLabels: const ['Active', 'Closed', 'Scheduled', 'Draft'],
    jobPostingActive:    const [400, 100, 200, 50],
    jobPostingClosed:    const [300, 80, 150, 30],
    jobPostingScheduled: const [200, 60, 100, 20],
    jobPostingDraft:     const [100, 40, 50, 10],
    hiringStages: const [
      HiringStageItem(label: 'Shortlist', value: 500),
      HiringStageItem(label: 'Interview', value: 350),
      HiringStageItem(label: 'Offer Sent', value: 200),
      HiringStageItem(label: 'Hired', value: 120),
      HiringStageItem(label: 'Joined', value: 80),
    ],
    jobStatus: const {
      'Active': 35,
      'Scheduled': 25,
      'Closed': 20,
      'Draft': 20,
    },
    jobStatusTotal: 9,
    qualifiedPercent: 72,
    unqualifiedPercent: 28,
    totalApplications: 114765,
    performanceRoles: const [
      'Frontend Developer',
      'Backend Developer',
      'UI/UX Designer',
      'Backend Developer',
    ],
    performanceApplications: const [90, 75, 60, 80],
    performanceInterviews:   const [50, 40, 35, 45],
    performanceHires:        const [20, 15, 12, 18],
    jobOfferApproved: 59091,
    jobOfferPending:  31760,
    jobOfferRejected: 23510,
    scoreDistribution: const [
      ScoreDistributionItem(label: 'Poor',      value: 18,   colorHex: '#D32F2F'),
      ScoreDistributionItem(label: 'Weak',      value: 45,   colorHex: '#F44336'),
      ScoreDistributionItem(label: 'Good',      value: 2113, colorHex: '#FF9800'),
      ScoreDistributionItem(label: 'Very Good', value: 2113, colorHex: '#E91E63'),
      ScoreDistributionItem(label: 'Excellent', value: 45,   colorHex: '#2E7D32'),
    ],
    employmentTypes: const {
      'Intern': 40,
      'Junior': 30,
      'Senior': 20,
      'Leadership': 10,
    },
    malePercent:   72,
    femalePercent:  28,
  );
}

// ── Root model ────────────────────────────────────────────────────────────────

class CareersCmsModel {
  final CareersOverview overview;
  final List<CareerStatItem> statistics;
  final CareersDashboardData dashboard;
  final DateTime? lastUpdated;

  const CareersCmsModel({
    required this.overview,
    required this.statistics,
    required this.dashboard,
    this.lastUpdated,
  });

  factory CareersCmsModel.empty() => CareersCmsModel(
    overview: CareersOverview.empty(),
    statistics: [],
    dashboard: CareersDashboardData.demo(),
  );

  factory CareersCmsModel.fromMap(Map<String, dynamic> map) {
    final rawStats = (map['statistics'] as List<dynamic>?) ?? <dynamic>[];
    final stats = rawStats
        .whereType<Map<String, dynamic>>()
        .map((s) => CareerStatItem.fromMap(
      s['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      s,
    ))
        .toList();

    DateTime? lastUpdated;
    if (map['lastUpdated'] != null) {
      try {
        lastUpdated = DateTime.parse(map['lastUpdated'] as String);
      } catch (_) {}
    }

    return CareersCmsModel(
      overview: CareersOverview.fromMap(
          (map['overview'] as Map<String, dynamic>?) ?? {}),
      statistics: stats,
      dashboard: CareersDashboardData.demo(), // TODO: parse from Firestore
      lastUpdated: lastUpdated,
    );
  }

  Map<String, dynamic> toMap() => {
    'overview': overview.toMap(),
    'statistics':
    statistics.map((s) => {'id': s.id, ...s.toMap()}).toList(),
    'lastUpdated': DateTime.now().toIso8601String(),
  };

  CareersCmsModel copyWith({
    CareersOverview? overview,
    List<CareerStatItem>? statistics,
    CareersDashboardData? dashboard,
    DateTime? lastUpdated,
  }) =>
      CareersCmsModel(
        overview: overview ?? this.overview,
        statistics: statistics ?? this.statistics,
        dashboard: dashboard ?? this.dashboard,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
}