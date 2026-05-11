// ═══════════════════════════════════════════════════════════════════
// FILE 2: department_repo.dart
// Path: lib/repo/department/department_repo.dart
// ═══════════════════════════════════════════════════════════════════

import 'package:website_app/model/department_model.dart';

abstract class DepartmentRepo {
  Future<List<DepartmentModel>> fetchAllDepartments();
  Future<DepartmentModel> createDepartment(DepartmentModel dept);
  Future<DepartmentModel> updateDepartment(DepartmentModel dept);
  Future<void> deleteDepartment(String id);
}