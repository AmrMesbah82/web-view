part of '../pages/job_page.dart';

class _L {
  final bool isAr;
  const _L(this.isAr);

  String get heroTitle        => isAr ? 'أطلق إمكاناتك في العالم الرقمي'               : 'Unlock Your Potential in the Digital World';
  String get sectionTitle     => isAr ? 'الوظائف المتاحة في بياناتز'                   : 'Job Listings at Bayanatz';
  String get allLabel         => isAr ? 'الكل'                                         : 'All';
  String get noJobsAll        => isAr ? 'لا توجد وظائف متاحة حالياً.'                  : 'No job openings available at the moment.';
  String noJobsDept(String d) => isAr ? 'لا توجد وظائف في "$d"'                       : 'No jobs found for "$d"';
  String get errorMsg         => isAr ? 'فشل تحميل الوظائف. يتم عرض البيانات المحفوظة.' : 'Failed to load jobs. Showing cached data.';
  String get retry            => isAr ? 'إعادة المحاولة'                               : 'Retry';
  String get linkCopied       => isAr ? 'تم نسخ الرابط!'                              : 'Link Copied!';
  String get hireDate         => isAr ? 'تاريخ التعيين المتوقع'                        : 'Expected Hire Date';
  String get experience       => isAr ? 'سنوات الخبرة'                                : 'Year Of Experience';
  String get employmentType   => isAr ? 'نوع التوظيف'                                 : 'Employment Type';
  String get compensation     => isAr ? 'نطاق الراتب'                                 : 'Compensation Range';
  String get qualification    => isAr ? 'المؤهل المطلوب'                              : 'Required Qualification';
  String get skillsLabel      => isAr ? 'المهارات:'                                   : 'Skills:';
  String get locationLabel    => isAr ? 'القاهرة، مصر'                                : 'Cairo, Egypt';
  String get viewJob          => isAr ? 'عرض الوظيفة'                                : 'VIEW JOB';
  String get untitled         => isAr ? 'بدون عنوان'                                 : 'Untitled';
  TextDirection get dir       => isAr ? TextDirection.rtl : TextDirection.ltr;
}

// ─── Department display record ────────────────────────────────────────────────

typedef _DeptItem = ({String display, String key});

// ─── Job Listings Page ────────────────────────────────────────────────────────
