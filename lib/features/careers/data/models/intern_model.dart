// ******************* FILE INFO *******************
// File Name: intern_model.dart

import '../../../../core/widgets/format_helper.dart';

class InternModel {
  final String id;
  final String photoUrl;
  final String firstName;
  final String lastName;
  final String position;
  final String degrees;
  final DateTime? joinedDate;
  final String whatHaveILearned;
  final List<String> tags;

  const InternModel({
    required this.id,
    this.photoUrl = '',
    required this.firstName,
    required this.lastName,
    this.position = '',
    this.degrees = '',
    this.joinedDate,
    required this.whatHaveILearned,
    this.tags = const [],
  });

  String get fullName => '$firstName $lastName'.trim();

  /// Bilingual join date — localized month name AND numerals.
  /// EN → "12 Mar 2026", AR → "١٢ مارس ٢٠٢٦".
  String joinDateLabelFor(bool isRtl) {
    if (joinedDate == null) return '';
    return FormDateTimeHelper.formatDayMonthYear(joinedDate!, arabic: isRtl);
  }

  /// English-only variant, kept for any caller without a language context.
  String get joinDateLabel => joinDateLabelFor(false);

  InternModel copyWith({
    String? id,
    String? photoUrl,
    String? firstName,
    String? lastName,
    String? position,
    String? degrees,
    DateTime? joinedDate,
    String? whatHaveILearned,
    List<String>? tags,
  }) {
    return InternModel(
      id:               id               ?? this.id,
      photoUrl:         photoUrl         ?? this.photoUrl,
      firstName:        firstName        ?? this.firstName,
      lastName:         lastName         ?? this.lastName,
      position:         position         ?? this.position,
      degrees:          degrees          ?? this.degrees,
      joinedDate:       joinedDate       ?? this.joinedDate,
      whatHaveILearned: whatHaveILearned ?? this.whatHaveILearned,
      tags:             tags             ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() => {
    'id':               id,
    'photoUrl':         photoUrl,
    'firstName':        firstName,
    'lastName':         lastName,
    'position':         position,
    'degrees':          degrees,
    'joinedDate':       joinedDate?.toIso8601String(),
    'whatHaveILearned': whatHaveILearned,
    'tags':             tags,
  };

  /// Nested template for [FlatCodec.decode]. `tags` is a string list, so it
  /// flattens to Tags_Count + Tags_0, Tags_1, … MUST match the admin app.
  static Map<String, dynamic> get flatTemplate => {
        'id': '',
        'photoUrl': '',
        'firstName': '',
        'lastName': '',
        'position': '',
        'degrees': '',
        'joinedDate': '',
        'whatHaveILearned': '',
        'tags': [''],
      };

  factory InternModel.fromMap(Map<String, dynamic> map) => InternModel(
    id:               map['id']               as String? ?? '',
    photoUrl:         map['photoUrl']         as String? ?? '',
    firstName:        map['firstName']        as String? ?? '',
    lastName:         map['lastName']         as String? ?? '',
    position:         map['position']         as String? ?? '',
    degrees:          map['degrees']          as String? ?? '',
    joinedDate:       map['joinedDate'] != null
        ? DateTime.tryParse(map['joinedDate'] as String)
        : null,
    whatHaveILearned: map['whatHaveILearned'] as String? ?? '',
    tags:             (map['tags'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList() ?? [],
  );

  factory InternModel.empty() => InternModel(
    id:               '',
    firstName:        '',
    lastName:         '',
    whatHaveILearned: '',
  );
}