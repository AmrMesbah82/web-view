part of '../pages/job_apply_page.dart';

class _DocFieldState {
  final String name;     // e.g. "Resume", "Cover Letter", "Portfolio"
  final String docType;  // "PDF" or "Link"

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
  }) : linkController = TextEditingController();

  void dispose() {
    linkController.dispose();
  }
}
