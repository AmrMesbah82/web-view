// ═══════════════════════════════════════════════════════════════════
// FILE 1: inquiry_model.dart
// Path: lib/model/inquiry_model.dart
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/animation.dart';

class InquiryModel {
  final String id;
  final String preferredLanguage;
  final String firstName;
  final String lastName;
  final String email;
  final String countryCode;
  final String phone;
  final String location;
  final String entityName;
  final String entityType;
  final String entitySize;
  final String subject;
  final String message;
  final String note;
  final InquiryStatus status;
  final DateTime? submissionDate;

  const InquiryModel({
    required this.id,
    this.preferredLanguage = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.countryCode = '+234',
    this.phone = '',
    this.location = '',
    this.entityName = '',
    this.entityType = '',
    this.entitySize = '',
    this.subject = '',
    this.message = '',
    this.note = '',
    this.status = InquiryStatus.newInquiry,
    this.submissionDate,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory InquiryModel.fromMap(String id, Map<String, dynamic> map) {
    return InquiryModel(
      id: id,
      preferredLanguage: map['preferredLanguage'] as String? ?? '',
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      countryCode: map['countryCode'] as String? ?? '+234',
      phone: map['phone'] as String? ?? '',
      location: map['location'] as String? ?? '',
      entityName: map['entityName'] as String? ?? '',
      entityType: map['entityType'] as String? ?? '',
      entitySize: map['entitySize'] as String? ?? '',
      subject: map['subject'] as String? ?? '',
      message: map['message'] as String? ?? '',
      note: map['note'] as String? ?? '',
      status: InquiryStatusExt.fromString(map['status'] as String? ?? 'New'),
      submissionDate: map['submissionDate'] != null
          ? DateTime.tryParse(map['submissionDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'preferredLanguage': preferredLanguage,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'countryCode': countryCode,
    'phone': phone,
    'location': location,
    'entityName': entityName,
    'entityType': entityType,
    'entitySize': entitySize,
    'subject': subject,
    'message': message,
    'note': note,
    'status': status.label,
    'submissionDate': (submissionDate ?? DateTime.now()).toIso8601String(),
  };

  InquiryModel copyWith({
    String? id,
    String? preferredLanguage,
    String? firstName,
    String? lastName,
    String? email,
    String? countryCode,
    String? phone,
    String? location,
    String? entityName,
    String? entityType,
    String? entitySize,
    String? subject,
    String? message,
    String? note,
    InquiryStatus? status,
    DateTime? submissionDate,
  }) =>
      InquiryModel(
        id: id ?? this.id,
        preferredLanguage: preferredLanguage ?? this.preferredLanguage,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        countryCode: countryCode ?? this.countryCode,
        phone: phone ?? this.phone,
        location: location ?? this.location,
        entityName: entityName ?? this.entityName,
        entityType: entityType ?? this.entityType,
        entitySize: entitySize ?? this.entitySize,
        subject: subject ?? this.subject,
        message: message ?? this.message,
        note: note ?? this.note,
        status: status ?? this.status,
        submissionDate: submissionDate ?? this.submissionDate,
      );
}

enum InquiryStatus { newInquiry, replied, closed }

extension InquiryStatusExt on InquiryStatus {
  String get label {
    switch (this) {
      case InquiryStatus.newInquiry: return 'New';
      case InquiryStatus.replied:    return 'Replied';
      case InquiryStatus.closed:     return 'Closed';
    }
  }

  Color get color {
    switch (this) {
      case InquiryStatus.newInquiry: return const Color(0xFF008037);
      case InquiryStatus.replied:    return const Color(0xFFFF9800);
      case InquiryStatus.closed:     return const Color(0xFFE53935);
    }
  }

  static InquiryStatus fromString(String s) {
    switch (s.toLowerCase()) {
      case 'new':     return InquiryStatus.newInquiry;
      case 'replied': return InquiryStatus.replied;
      case 'closed':  return InquiryStatus.closed;
      default:        return InquiryStatus.newInquiry;
    }
  }
}