part of '../pages/job_apply_page.dart';

class _DocFieldState {
  final String name;       // e.g. "Resume", "Cover Letter", "Portfolio"
  final String docType;    // "PDF" or "Link"
  final bool isRequired;   // admin's Required/Optional switch

  // ── For PDF type ──
  String? fileName;
  Uint8List? fileBytes;
  String? uploadedUrl;
  String? error;

  // ── For Link type ──
  final TextEditingController linkController;

  _DocFieldState({
    required this.name,
    required this.docType,
    this.isRequired = true,
  }) : linkController = TextEditingController();

  void dispose() {
    linkController.dispose();
  }
}
