// ═══════════════════════════════════════════════════════════════════
// FILE 2: about_company_repo.dart
// ═══════════════════════════════════════════════════════════════════

import 'package:website_app/model/about_company_model.dart';

abstract class AboutCompanyRepo {
  Future<AboutCompanyModel?> fetchAboutCompany();
  Future<void> saveAboutCompany(AboutCompanyModel data);
}