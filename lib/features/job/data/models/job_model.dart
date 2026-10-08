// ******************* FILE INFO *******************
// File Name: job_model.dart
// Created by: Amr Mesbah
// Purpose: Model for Job Listing CMS — full job post data

// ── Bilingual text ────────────────────────────────────────────────────────────

class BilingualTextJob {
  final String en;
  final String ar;

  const BilingualTextJob({this.en = '', this.ar = ''});

  factory BilingualTextJob.fromMap(Map<String, dynamic> map) =>
      BilingualTextJob(
        en: map['en'] as String? ?? '',
        ar: map['ar'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {'en': en, 'ar': ar};

  BilingualTextJob copyWith({String? en, String? ar}) =>
      BilingualTextJob(en: en ?? this.en, ar: ar ?? this.ar);

  bool get isEmpty => en.isEmpty && ar.isEmpty;
}

// ── Enums ─────────────────────────────────────────────────────────────────────

enum JobStatus { active, inactive, ended, scheduled, drafted, removed }

extension JobStatusExt on JobStatus {
  String get label {
    switch (this) {
      case JobStatus.active:    return 'Active';
      case JobStatus.inactive:  return 'Inactive';
      case JobStatus.ended:     return 'Ended';
      case JobStatus.scheduled: return 'Scheduled';
      case JobStatus.drafted:   return 'Drafted';
      case JobStatus.removed:   return 'Removed';
    }
  }

  static JobStatus fromString(String s) {
    switch (s.toLowerCase()) {
      case 'active':    return JobStatus.active;
      case 'inactive':  return JobStatus.inactive;
      case 'ended':     return JobStatus.ended;
      case 'scheduled': return JobStatus.scheduled;
      case 'drafted':   return JobStatus.drafted;
      case 'removed':   return JobStatus.removed;
      default:          return JobStatus.drafted;
    }
  }
}

enum WorkType { onSite, remote, hybrid }

extension WorkTypeExt on WorkType {
  String get label {
    switch (this) {
      case WorkType.onSite: return 'On Site';
      case WorkType.remote: return 'Remotely'; // Figma job page: "Work Type: Remotely"
      case WorkType.hybrid: return 'Hybrid';
    }
  }

  String get labelAr {
    switch (this) {
      case WorkType.onSite: return 'في الموقع';
      case WorkType.remote: return 'عن بُعد';
      case WorkType.hybrid: return 'هجين';
    }
  }

  String localized(bool isAr) => isAr ? labelAr : label;

  static WorkType fromString(String s) {
    switch (s.toLowerCase()) {
      case 'on site':  return WorkType.onSite;
      case 'onsite':   return WorkType.onSite;
      case 'remotely': return WorkType.remote;
      case 'remote':   return WorkType.remote;
      case 'hybrid':   return WorkType.hybrid;
      default:         return WorkType.onSite;
    }
  }
}

enum EmploymentType { fullTime, partTime }

extension EmploymentTypeExt on EmploymentType {
  String get label {
    switch (this) {
      case EmploymentType.fullTime: return 'Full Time';
      case EmploymentType.partTime: return 'Part Time';
    }
  }

  String get labelAr {
    switch (this) {
      case EmploymentType.fullTime: return 'دوام كامل';
      case EmploymentType.partTime: return 'دوام جزئي';
    }
  }

  String localized(bool isAr) => isAr ? labelAr : label;

  static EmploymentType fromString(String s) {
    switch (s.toLowerCase()) {
      case 'full time': return EmploymentType.fullTime;
      case 'fulltime':  return EmploymentType.fullTime;
      case 'part time': return EmploymentType.partTime;
      case 'parttime':  return EmploymentType.partTime;
      default:          return EmploymentType.fullTime;
    }
  }
}

enum ExperienceLevel { intern, junior, senior, leadership }

extension ExperienceLevelExt on ExperienceLevel {
  String get label {
    switch (this) {
      case ExperienceLevel.intern:     return 'Intern';
      case ExperienceLevel.junior:     return 'Junior';
      case ExperienceLevel.senior:     return 'Senior';
      case ExperienceLevel.leadership: return 'Leadership';
    }
  }

  String get labelAr {
    switch (this) {
      case ExperienceLevel.intern:     return 'متدرب';
      case ExperienceLevel.junior:     return 'مبتدئ';
      case ExperienceLevel.senior:     return 'خبير';
      case ExperienceLevel.leadership: return 'قيادي';
    }
  }

  String localized(bool isAr) => isAr ? labelAr : label;

  static ExperienceLevel fromString(String s) {
    switch (s.toLowerCase()) {
      case 'intern':     return ExperienceLevel.intern;
      case 'junior':     return ExperienceLevel.junior;
      case 'senior':     return ExperienceLevel.senior;
      case 'leadership': return ExperienceLevel.leadership;
      default:           return ExperienceLevel.junior;
    }
  }
}

enum EmploymentDuration { open, month, week, year }

extension EmploymentDurationExt on EmploymentDuration {
  String get label {
    switch (this) {
      case EmploymentDuration.open:  return 'Open';
      case EmploymentDuration.month: return 'Month';
      case EmploymentDuration.week:  return 'Week';
      case EmploymentDuration.year:  return 'Year'; // admin BUG-47 added "Year"
    }
  }

  String get labelAr {
    switch (this) {
      case EmploymentDuration.open:  return 'مفتوح';
      case EmploymentDuration.month: return 'شهر';
      case EmploymentDuration.week:  return 'أسبوع';
      case EmploymentDuration.year:  return 'سنة';
    }
  }

  String localized(bool isAr) => isAr ? labelAr : label;

  static EmploymentDuration fromString(String s) {
    switch (s.toLowerCase()) {
      case 'open':  return EmploymentDuration.open;
      case 'month': return EmploymentDuration.month;
      case 'week':  return EmploymentDuration.week;
      case 'year':  return EmploymentDuration.year;
      default:      return EmploymentDuration.open;
    }
  }
}

enum DocType { pdf, link }

extension DocTypeExt on DocType {
  String get label {
    switch (this) {
      case DocType.pdf:  return 'PDF';
      case DocType.link: return 'Link';
    }
  }

  static DocType fromString(String s) {
    switch (s.toLowerCase()) {
      case 'pdf':  return DocType.pdf;
      case 'link': return DocType.link;
      default:     return DocType.pdf;
    }
  }
}

// ── Benefit Item ──────────────────────────────────────────────────────────────

class BenefitItem {
  final String id;
  final BilingualTextJob title;
  final BilingualTextJob shortDescription;

  const BenefitItem({
    required this.id,
    required this.title,
    required this.shortDescription,
  });

  factory BenefitItem.empty() => BenefitItem(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    title: const BilingualTextJob(),
    shortDescription: const BilingualTextJob(),
  );

  factory BenefitItem.fromMap(Map<String, dynamic> map) => BenefitItem(
    id: map['id'] as String? ??
        DateTime.now().millisecondsSinceEpoch.toString(),
    title: BilingualTextJob.fromMap(
        (map['title'] as Map<String, dynamic>?) ?? {}),
    shortDescription: BilingualTextJob.fromMap(
        (map['shortDescription'] as Map<String, dynamic>?) ?? {}),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title.toMap(),
    'shortDescription': shortDescription.toMap(),
  };

  BenefitItem copyWith({
    String? id,
    BilingualTextJob? title,
    BilingualTextJob? shortDescription,
  }) =>
      BenefitItem(
        id: id ?? this.id,
        title: title ?? this.title,
        shortDescription: shortDescription ?? this.shortDescription,
      );
}

// ── Required Document ─────────────────────────────────────────────────────────

class RequiredDocument {
  final String id;
  final String name;
  final DocType docType;

  const RequiredDocument({
    required this.id,
    required this.name,
    required this.docType,
  });

  factory RequiredDocument.empty({String name = 'Resume'}) => RequiredDocument(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    name: name,
    docType: DocType.pdf,
  );

  factory RequiredDocument.fromMap(Map<String, dynamic> map) =>
      RequiredDocument(
        id: map['id'] as String? ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: map['name'] as String? ?? '',
        docType: DocTypeExt.fromString(map['docType'] as String? ?? 'pdf'),
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'docType': docType.label,
  };

  RequiredDocument copyWith({String? id, String? name, DocType? docType}) =>
      RequiredDocument(
        id: id ?? this.id,
        name: name ?? this.name,
        docType: docType ?? this.docType,
      );
}

// ── Skill Item ────────────────────────────────────────────────────────────────

class SkillItem {
  final String id;
  final BilingualTextJob name;

  const SkillItem({required this.id, required this.name});

  factory SkillItem.empty() => SkillItem(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    name: const BilingualTextJob(),
  );

  factory SkillItem.fromMap(Map<String, dynamic> map) => SkillItem(
    id: map['id'] as String? ??
        DateTime.now().millisecondsSinceEpoch.toString(),
    name: BilingualTextJob.fromMap(
        (map['name'] as Map<String, dynamic>?) ?? {}),
  );

  Map<String, dynamic> toMap() => {'id': id, 'name': name.toMap()};

  SkillItem copyWith({String? id, BilingualTextJob? name}) =>
      SkillItem(id: id ?? this.id, name: name ?? this.name);
}

// ── Job Post Model ────────────────────────────────────────────────────────────

class JobPostModel {
  final String id;

  // Job Information
  final BilingualTextJob title;
  final String department;

  /// Office location chosen in admin (On Site / Hybrid jobs).
  final String location;
  final WorkType workType;
  final EmploymentType employmentType;
  final String employmentDurationText; // e.g. "3 Weeks"
  final EmploymentDuration employmentDurationType;
  final ExperienceLevel experienceLevel;
  final double salaryMin;
  final double salaryMax;
  final String salaryCurrency;
  final BilingualTextJob requiredQualification;
  final List<SkillItem> requiredSkills;

  // Job Details
  final BilingualTextJob aboutThisPosition;
  final BilingualTextJob requirements;
  final BilingualTextJob preferredSkills;

  // Benefits
  final List<BenefitItem> benefits;

  // Application Details
  final DateTime? hiringStartDate;
  final DateTime? hiringEndDate;
  final int maxApplications;
  final List<RequiredDocument> requiredDocuments;

  // Meta
  final JobStatus status;
  final DateTime? postedDate;
  final DateTime? endedDate;
  final int totalApplications;
  final String publishStatus; // 'published', 'draft'

  const JobPostModel({
    required this.id,
    required this.title,
    this.department = '',
    this.location = '',
    this.workType = WorkType.onSite,
    this.employmentType = EmploymentType.fullTime,
    this.employmentDurationText = '',
    this.employmentDurationType = EmploymentDuration.open,
    this.experienceLevel = ExperienceLevel.junior,
    this.salaryMin = 0,
    this.salaryMax = 0,
    this.salaryCurrency = 'SAR',
    this.requiredQualification = const BilingualTextJob(),
    this.requiredSkills = const [],
    this.aboutThisPosition = const BilingualTextJob(),
    this.requirements = const BilingualTextJob(),
    this.preferredSkills = const BilingualTextJob(),
    this.benefits = const [],
    this.hiringStartDate,
    this.hiringEndDate,
    this.maxApplications = 0,
    this.requiredDocuments = const [],
    this.status = JobStatus.drafted,
    this.postedDate,
    this.endedDate,
    this.totalApplications = 0,
    this.publishStatus = 'draft',
  });

  factory JobPostModel.empty() => JobPostModel(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    title: const BilingualTextJob(),
    requiredDocuments: [
      RequiredDocument.empty(name: 'Resume'),
      RequiredDocument.empty(name: 'Cover Letter'),
    ],
  );

  // BUG-13: tolerant readers. One job saved with a blank number ("" — see
  // BUG-28) or a Timestamp date used to throw inside fromMap, which failed the
  // WHOLE list, so the public Careers / Jobs pages showed no jobs at all.
  static int _asInt(dynamic v) {
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v.trim()) ?? 0;
    return 0;
  }

  static double _asDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v.trim()) ?? 0;
    return 0;
  }

  static DateTime? _asDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String) return v.trim().isEmpty ? null : DateTime.tryParse(v);
    if (v is num) return DateTime.fromMillisecondsSinceEpoch(v.toInt());
    try {
      return (v as dynamic).toDate() as DateTime; // Firestore Timestamp
    } catch (_) {
      return null;
    }
  }

  factory JobPostModel.fromMap(String id, Map<String, dynamic> map) {
    return JobPostModel(
      id: id,
      title: BilingualTextJob.fromMap(
          (map['title'] as Map<String, dynamic>?) ?? {}),
      department: map['department'] as String? ?? '',
      location: map['location'] as String? ?? '',
      workType:
      WorkTypeExt.fromString(map['workType'] as String? ?? 'On Site'),
      employmentType: EmploymentTypeExt.fromString(
          map['employmentType'] as String? ?? 'Full Time'),
      employmentDurationText:
      map['employmentDurationText'] as String? ?? '',
      employmentDurationType: EmploymentDurationExt.fromString(
          map['employmentDurationType'] as String? ?? 'open'),
      experienceLevel: ExperienceLevelExt.fromString(
          map['experienceLevel'] as String? ?? 'junior'),
      salaryMin: _asDouble(map['salaryMin']),
      salaryMax: _asDouble(map['salaryMax']),
      salaryCurrency: map['salaryCurrency'] as String? ?? 'SAR',
      requiredQualification: BilingualTextJob.fromMap(
          (map['requiredQualification'] as Map<String, dynamic>?) ?? {}),
      requiredSkills: ((map['requiredSkills'] as List<dynamic>?) ?? [])
          .whereType<Map<String, dynamic>>()
          .map((s) => SkillItem.fromMap(s))
          .toList(),
      aboutThisPosition: BilingualTextJob.fromMap(
          (map['aboutThisPosition'] as Map<String, dynamic>?) ?? {}),
      requirements: BilingualTextJob.fromMap(
          (map['requirements'] as Map<String, dynamic>?) ?? {}),
      preferredSkills: BilingualTextJob.fromMap(
          (map['preferredSkills'] as Map<String, dynamic>?) ?? {}),
      benefits: ((map['benefits'] as List<dynamic>?) ?? [])
          .whereType<Map<String, dynamic>>()
          .map((b) => BenefitItem.fromMap(b))
          .toList(),
      hiringStartDate: map['hiringStartDate'] != null
          ? _asDate(map['hiringStartDate'])
          : null,
      hiringEndDate: map['hiringEndDate'] != null
          ? _asDate(map['hiringEndDate'])
          : null,
      maxApplications: _asInt(map['maxApplications']),
      requiredDocuments:
      ((map['requiredDocuments'] as List<dynamic>?) ?? [])
          .whereType<Map<String, dynamic>>()
          .map((d) => RequiredDocument.fromMap(d))
          .toList(),
      status: JobStatusExt.fromString(
          map['status'] as String? ?? 'drafted'),
      postedDate: map['postedDate'] != null
          ? _asDate(map['postedDate'])
          : null,
      endedDate: map['endedDate'] != null
          ? _asDate(map['endedDate'])
          : null,
      totalApplications: _asInt(map['totalApplications']),
      publishStatus: map['publishStatus'] as String? ?? 'draft',
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title.toMap(),
    'department': department,
    'workType': workType.label,
    'employmentType': employmentType.label,
    'employmentDurationText': employmentDurationText,
    'employmentDurationType': employmentDurationType.label,
    'experienceLevel': experienceLevel.label,
    'salaryMin': salaryMin,
    'salaryMax': salaryMax,
    'salaryCurrency': salaryCurrency,
    'requiredQualification': requiredQualification.toMap(),
    'requiredSkills': requiredSkills.map((s) => s.toMap()).toList(),
    'aboutThisPosition': aboutThisPosition.toMap(),
    'requirements': requirements.toMap(),
    'preferredSkills': preferredSkills.toMap(),
    'benefits': benefits.map((b) => b.toMap()).toList(),
    'hiringStartDate': hiringStartDate?.toIso8601String(),
    'hiringEndDate': hiringEndDate?.toIso8601String(),
    'maxApplications': maxApplications,
    'requiredDocuments':
    requiredDocuments.map((d) => d.toMap()).toList(),
    'status': status.label,
    'postedDate': postedDate?.toIso8601String(),
    'endedDate': endedDate?.toIso8601String(),
    'totalApplications': totalApplications,
    'publishStatus': publishStatus,
  };

  /// Nested template for [FlatCodec.decode] — MUST mirror the admin app's
  /// JobPostModel.flatTemplate so the FLAT VERSIONED docs written by the admin
  /// (jobListings collection) decode correctly here. One populated sample per
  /// list so the codec knows each element's sub-keys.
  static Map<String, dynamic> get flatTemplate => {
        'title': {'en': '', 'ar': ''},
        'department': '',
        'location': '',
        'workType': '',
        'employmentType': '',
        'employmentDurationText': '',
        'employmentDurationType': '',
        'experienceLevel': '',
        'salaryMin': 0,
        'salaryMax': 0,
        'salaryCurrency': '',
        'requiredQualification': {'en': '', 'ar': ''},
        'requiredSkills': [
          {
            'id': '',
            'name': {'en': '', 'ar': ''}
          }
        ],
        'aboutThisPosition': {'en': '', 'ar': ''},
        'requirements': {'en': '', 'ar': ''},
        'preferredSkills': {'en': '', 'ar': ''},
        'benefits': [
          {
            'id': '',
            'title': {'en': '', 'ar': ''},
            'shortDescription': {'en': '', 'ar': ''},
          }
        ],
        'hiringStartDate': '',
        'hiringEndDate': '',
        'maxApplications': 0,
        'requiredDocuments': [
          {'id': '', 'name': '', 'nameAr': '', 'docType': '', 'isRequired': true}
        ],
        'status': '',
        'postedDate': '',
        'endedDate': '',
        'totalApplications': 0,
        'publishStatus': '',
      };

  JobPostModel copyWith({
    String? id,
    BilingualTextJob? title,
    String? department,
    WorkType? workType,
    EmploymentType? employmentType,
    String? employmentDurationText,
    EmploymentDuration? employmentDurationType,
    ExperienceLevel? experienceLevel,
    double? salaryMin,
    double? salaryMax,
    String? salaryCurrency,
    BilingualTextJob? requiredQualification,
    List<SkillItem>? requiredSkills,
    BilingualTextJob? aboutThisPosition,
    BilingualTextJob? requirements,
    BilingualTextJob? preferredSkills,
    List<BenefitItem>? benefits,
    DateTime? hiringStartDate,
    DateTime? hiringEndDate,
    int? maxApplications,
    List<RequiredDocument>? requiredDocuments,
    JobStatus? status,
    DateTime? postedDate,
    DateTime? endedDate,
    int? totalApplications,
    String? publishStatus,
  }) =>
      JobPostModel(
        id: id ?? this.id,
        title: title ?? this.title,
        department: department ?? this.department,
        workType: workType ?? this.workType,
        employmentType: employmentType ?? this.employmentType,
        employmentDurationText:
        employmentDurationText ?? this.employmentDurationText,
        employmentDurationType:
        employmentDurationType ?? this.employmentDurationType,
        experienceLevel: experienceLevel ?? this.experienceLevel,
        salaryMin: salaryMin ?? this.salaryMin,
        salaryMax: salaryMax ?? this.salaryMax,
        salaryCurrency: salaryCurrency ?? this.salaryCurrency,
        requiredQualification:
        requiredQualification ?? this.requiredQualification,
        requiredSkills: requiredSkills ?? this.requiredSkills,
        aboutThisPosition: aboutThisPosition ?? this.aboutThisPosition,
        requirements: requirements ?? this.requirements,
        preferredSkills: preferredSkills ?? this.preferredSkills,
        benefits: benefits ?? this.benefits,
        hiringStartDate: hiringStartDate ?? this.hiringStartDate,
        hiringEndDate: hiringEndDate ?? this.hiringEndDate,
        maxApplications: maxApplications ?? this.maxApplications,
        requiredDocuments: requiredDocuments ?? this.requiredDocuments,
        status: status ?? this.status,
        postedDate: postedDate ?? this.postedDate,
        endedDate: endedDate ?? this.endedDate,
        totalApplications: totalApplications ?? this.totalApplications,
        publishStatus: publishStatus ?? this.publishStatus,
      );

  /// Generate demo jobs matching the Figma grid
  static List<JobPostModel> demoJobs() => [
    JobPostModel(
      id: '1',
      title: const BilingualTextJob(en: 'Sr. UX Designer', ar: 'مصمم UX أول'),
      department: 'Design',
      workType: WorkType.onSite,
      employmentType: EmploymentType.fullTime,
      employmentDurationText: '3 Years Exp',
      experienceLevel: ExperienceLevel.senior,
      salaryMin: 10000, salaryMax: 50000, salaryCurrency: 'SAR',
      requiredQualification: const BilingualTextJob(en: 'Have a degree related with Design'),
      requiredSkills: [SkillItem(id: '1', name: const BilingualTextJob(en: 'Compensation'))],
      aboutThisPosition: const BilingualTextJob(en: 'Collaborate with the Marketing Director and Lead Product Designer to define Pawlicy\'s brand identity and build comprehensive brand guidelines'),
      requirements: const BilingualTextJob(en: '3+ years of experience in marketing, brand, or graphic design'),
      preferredSkills: const BilingualTextJob(en: '3+ years of experience in marketing, brand, or graphic design'),
      benefits: [
        BenefitItem(id: '1', title: const BilingualTextJob(en: 'Competitive Compensation'), shortDescription: const BilingualTextJob(en: 'We offer competitive salary packages to reward your skills, experience, and dedication to the company.')),
        BenefitItem(id: '2', title: const BilingualTextJob(en: 'Paid Time Off'), shortDescription: const BilingualTextJob(en: 'Vacation Leave: Generous vacation days to relax and recharge.')),
        BenefitItem(id: '3', title: const BilingualTextJob(en: 'Professional Development'), shortDescription: const BilingualTextJob(en: 'Training Opportunities: Access to workshops, courses, and resources.')),
        BenefitItem(id: '4', title: const BilingualTextJob(en: 'Flexible Work Arrangements'), shortDescription: const BilingualTextJob(en: 'Remote Work: We support flexible work arrangements.')),
      ],
      hiringStartDate: DateTime(2026, 8, 28),
      hiringEndDate: DateTime(2026, 8, 28),
      maxApplications: 100,
      requiredDocuments: [RequiredDocument(id: '1', name: 'Resume', docType: DocType.pdf), RequiredDocument(id: '2', name: 'Cover Letter', docType: DocType.pdf)],
      status: JobStatus.active,
      postedDate: DateTime.now().subtract(const Duration(days: 2)),
      totalApplications: 100,
      publishStatus: 'published',
    ),
    JobPostModel(
      id: '2',
      title: const BilingualTextJob(en: 'Sr. UX Designer', ar: 'مصمم UX أول'),
      department: 'Design', workType: WorkType.remote,
      employmentType: EmploymentType.fullTime,
      employmentDurationText: '3 Years Exp',
      experienceLevel: ExperienceLevel.senior,
      salaryMin: 10000, salaryMax: 50000, salaryCurrency: 'SAR',
      status: JobStatus.ended,
      endedDate: DateTime(2026, 7, 12),
      totalApplications: 100,
      publishStatus: 'published',
    ),
    JobPostModel(
      id: '3',
      title: const BilingualTextJob(en: 'Sr. UX Designer', ar: 'مصمم UX أول'),
      department: 'Design', workType: WorkType.onSite,
      employmentType: EmploymentType.fullTime,
      employmentDurationText: '3 Years Exp',
      experienceLevel: ExperienceLevel.senior,
      salaryMin: 10000, salaryMax: 50000, salaryCurrency: 'SAR',
      status: JobStatus.removed,
      endedDate: DateTime(2026, 7, 12),
      totalApplications: 0,
      publishStatus: 'published',
    ),
    JobPostModel(
      id: '4',
      title: const BilingualTextJob(en: 'Sr. UX Designer'),
      department: 'Design', workType: WorkType.onSite,
      employmentType: EmploymentType.fullTime,
      employmentDurationText: '3 Years Exp',
      experienceLevel: ExperienceLevel.senior,
      salaryMin: 10000, salaryMax: 50000, salaryCurrency: 'SAR',
      status: JobStatus.scheduled,
      postedDate: DateTime(2026, 7, 12),
      publishStatus: 'published',
    ),
    JobPostModel(
      id: '5',
      title: const BilingualTextJob(en: 'Sr. UX Designer'),
      department: 'Design', workType: WorkType.onSite,
      employmentType: EmploymentType.fullTime,
      employmentDurationText: '3 Years Exp',
      experienceLevel: ExperienceLevel.senior,
      salaryMin: 10000, salaryMax: 50000, salaryCurrency: 'SAR',
      status: JobStatus.drafted,
      publishStatus: 'draft',
    ),
    JobPostModel(
      id: '6',
      title: const BilingualTextJob(en: 'Sr. UX Designer'),
      department: 'Design', workType: WorkType.onSite,
      employmentType: EmploymentType.fullTime,
      employmentDurationText: '3 Years Exp',
      experienceLevel: ExperienceLevel.senior,
      salaryMin: 10000, salaryMax: 50000, salaryCurrency: 'SAR',
      status: JobStatus.inactive,
      endedDate: DateTime(2026, 7, 12),
      publishStatus: 'published',
    ),
  ];
}
// ═══════════════════════════════════════════════════════════════════════════
// BUG-99 / BUG-103: can a visitor see / apply to this job?
// The admin derives "Scheduled" / "Ended" from the hiring dates while the
// stored status can still say "Active" (older jobs), so the public site uses
// the SAME rule: stored status + hiring window + max applications.
// ═══════════════════════════════════════════════════════════════════════════
enum JobOpenState { open, notStarted, closed }

JobOpenState jobOpenStateOf({
  required String status,
  DateTime? start,
  DateTime? end,
  int maxApplications = 0,
  int totalApplications = 0,
  DateTime? now,
}) {
  final s = status.trim().toLowerCase();
  if (s != 'active' && s != 'scheduled') return JobOpenState.closed;
  final n = now ?? DateTime.now();
  if (end != null &&
      n.isAfter(DateTime(end.year, end.month, end.day, 23, 59, 59))) {
    return JobOpenState.closed;
  }
  if (maxApplications > 0 && totalApplications >= maxApplications) {
    return JobOpenState.closed;
  }
  if (start != null && n.isBefore(DateTime(start.year, start.month, start.day))) {
    return JobOpenState.notStarted;
  }
  return JobOpenState.open;
}

/// Same check on the decoded (nested) map the job / apply pages read.
JobOpenState jobOpenStateOfMap(Map<String, dynamic> job) {
  DateTime? date(dynamic v) =>
      v is String && v.trim().isNotEmpty ? DateTime.tryParse(v) : null;
  int asInt(dynamic v) => v is num ? v.toInt() : int.tryParse('$v') ?? 0;
  return jobOpenStateOf(
    status: job['status'] as String? ?? '',
    start: date(job['hiringStartDate']),
    end: date(job['hiringEndDate']),
    maxApplications: asInt(job['maxApplications']),
    totalApplications: asInt(job['totalApplications']),
  );
}

extension JobPostOpenState on JobPostModel {
  JobOpenState get openState => jobOpenStateOf(
        status: status.label,
        start: hiringStartDate,
        end: hiringEndDate,
        maxApplications: maxApplications,
        totalApplications: totalApplications,
      );
}
