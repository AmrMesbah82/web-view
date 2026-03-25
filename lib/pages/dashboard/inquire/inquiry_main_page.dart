// ═══════════════════════════════════════════════════════════════════
// FILE 6: inquiry_main_page.dart (View Page)
// Path: lib/pages/dashboard/inquiry/inquiry_main_page.dart
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:website_app/controller/inquire/inquiry_cubit.dart';
import 'package:website_app/controller/inquire/inquiry_state.dart';

import 'package:website_app/core/widget/button.dart';
import 'package:website_app/core/widget/navigator.dart';
import 'package:website_app/core/widget/search.dart';
import 'package:website_app/model/inquiry_model.dart';
import 'package:website_app/pages/careers_main_dashboard.dart';
import 'package:website_app/pages/dashboard/inquire/inquiry_detail_page.dart';
import 'package:website_app/pages/dashboard/main_page/home_main_page.dart';
import 'package:website_app/pages/dashboard/job_list/job_listing_main_page.dart';
import 'package:website_app/theme/appcolors.dart';
import 'package:website_app/theme/new_theme.dart';
import 'package:website_app/widgets/app_admin_navbar.dart';


class _C {
  static const Color primary   = Color(0xFF008037);
  static const Color back      = Color(0xFFF1F2ED);
  static const Color cardBg    = Color(0xFFFFFFFF);
  static const Color labelText = Color(0xFF333333);
  static const Color hintText  = Color(0xFFAAAAAA);
  static const Color border    = Color(0xFFE0E0E0);
}

class InquiryMainPage extends StatefulWidget {
  const InquiryMainPage({super.key});

  @override
  State<InquiryMainPage> createState() => _InquiryMainPageState();
}

class _InquiryMainPageState extends State<InquiryMainPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<InquiryCubit>().loadInquiries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InquiryCubit, InquiryState>(
      listener: (context, state) {
        if (state is InquiryUpdated) {
          context.read<InquiryCubit>().loadInquiries();
        }
      },
      child: BlocBuilder<InquiryCubit, InquiryState>(
        builder: (context, state) {
          if (state is InquiryInitial || state is InquiryLoading) {
            return const Scaffold(
              backgroundColor: _C.back,
              body: Center(child: CircularProgressIndicator(color: _C.primary)),
            );
          }

          final cubit = context.read<InquiryCubit>();
          List<InquiryModel> inquiries = [];
          int totalCount = 0, newCount = 0, repliedCount = 0, closedCount = 0;
          Map<String, int> entityTypeCounts = {};
          Map<String, int> entitySizeCounts = {};
          Map<String, int> locationCounts = {};
          Map<int, int> monthlySubmissions = {};

          if (state is InquiryLoaded) {
            inquiries = state.filtered;
            totalCount = state.totalCount;
            newCount = state.newCount;
            repliedCount = state.repliedCount;
            closedCount = state.closedCount;
            entityTypeCounts = state.entityTypeCounts;
            entitySizeCounts = state.entitySizeCounts;
            locationCounts = state.locationCounts;
            monthlySubmissions = state.monthlySubmissions;
          }

          if (state is InquiryError && state.lastInquiries != null) {
            inquiries = state.lastInquiries!;
          }

          return Scaffold(
            backgroundColor: _C.back,
            body: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    AppAdminNavbar(
                      activeLabel: 'Inquires',
                      homePage: CareersMainPageDashboard(),
                      webPage: HomeMainPage(),
                      jobListingPage: JobListingMainPage(),
                    ),
                    SizedBox(height: 20.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                      child: SizedBox(
                        width: 1000.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Inquires',
                                style: StyleText.fontSize45Weight600.copyWith(
                                    color: _C.primary, fontWeight: FontWeight.w700)),
                            SizedBox(height: 16.h),

                            // ── Search + Filter ──
                            Row(children: [
                              AppSearchTextField(
                                controller: _searchController,
                                onChanged: (v) => cubit.setSearch(v),
                                hintText: 'Search',
                              ),
                              SizedBox(width: 12.w),
                              customButton(
                                title: 'Filter',
                                function: () {},
                                width: 100.w,
                                height: 36.h,
                                radius: 6,
                                color: _C.primary,
                                textColor: Colors.white,
                                textStyle: StyleText.fontSize13Weight600.copyWith(color: Colors.white),
                              ),
                            ]),
                            SizedBox(height: 16.h),

                            // ── Summary Cards ──
                            Row(children: [
                              Expanded(child: _summaryCard('Total Submission', totalCount, Colors.grey)),
                              SizedBox(width: 10.w),
                              Expanded(child: _summaryCard('New', newCount, _C.primary)),
                              SizedBox(width: 10.w),
                              Expanded(child: _summaryCard('Replied', repliedCount, const Color(0xFFFF9800))),
                              SizedBox(width: 10.w),
                              Expanded(child: _summaryCard('Closed', closedCount, const Color(0xFFE53935))),
                            ]),
                            SizedBox(height: 16.h),

                            // ── Filter dropdowns + Export ──
                            Row(children: [
                              _miniDropdown('Status'),
                              SizedBox(width: 8.w),
                              _miniDropdown('Entity Type'),
                              SizedBox(width: 8.w),
                              _miniDropdown('Location'),
                              SizedBox(width: 8.w),
                              _miniDropdown('Calendar'),
                              const Spacer(),
                              customButtonWithImage(
                                title: 'Export',
                                function: () {},
                                textStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.white,),
                                height: 32.h,
                                space: 4.w,
                                radius: 6,
                                color: _C.primary,
                                image: 'assets/images/export.svg',
                                widthImage: 14.sp,
                                heightImage: 14.sp,
                                colorBorder: _C.primary,
                                svgColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                              ),
                            ]),
                            SizedBox(height: 16.h),

                            // ── Table ──
                            _buildTable(inquiries),
                            SizedBox(height: 40.h),

                            // ── Dashboard Charts ──
                            Text('Inquires',
                                style: StyleText.fontSize24Weight600.copyWith(
                                    color: _C.primary, fontWeight: FontWeight.w700)),
                            SizedBox(height: 16.h),

                            // Submission Received + Entity Types
                            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Expanded(child: _chartCard('Submission Received', 'Total: $totalCount',
                                  _buildBarChart(monthlySubmissions))),
                              SizedBox(width: 16.w),
                              Expanded(child: _chartCard('Entity Types', '',
                                  _buildEntityTypeChart(entityTypeCounts))),
                            ]),
                            SizedBox(height: 16.h),

                            // Entity Size Distribution + placeholder
                            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Expanded(child: _chartCard('Entity Size Distribution', '',
                                  _buildSizeChart(entitySizeCounts))),
                              SizedBox(width: 16.w),
                              const Expanded(child: SizedBox()),
                            ]),
                            SizedBox(height: 16.h),

                            // Location Distribution
                            _chartCard('Location Distribution', '',
                                _buildLocationChart(locationCounts)),

                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _summaryCard(String title, int count, Color topColor) {
    return Container(
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(children: [
        Container(
          height: 4.h,
          decoration: BoxDecoration(
            color: topColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.r),
              topRight: Radius.circular(8.r),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: _C.labelText)),
              Text('$count', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: _C.labelText)),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _miniDropdown(String hint) {
    return Container(
      height: 32.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: _C.border),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(hint, style: TextStyle(fontSize: 11.sp, color: _C.hintText)),
        SizedBox(width: 4.w),
        Icon(Icons.keyboard_arrow_down, size: 14.sp, color: _C.hintText),
      ]),
    );
  }

  Widget _buildTable(List<InquiryModel> inquiries) {
    final columns = [
      'Submission Date', 'Preferred Language', 'First Name', 'Last Name',
      'Email', 'Country Code', 'Phone Number', 'Location', 'Entity Name',
      'Entity Type', 'Entity Size', 'Subject', 'Message', 'Note', 'Status',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(_C.primary),
        headingTextStyle: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: Colors.white),
        dataTextStyle: TextStyle(fontSize: 11.sp, color: _C.labelText),
        columns: columns.map((c) => DataColumn(label: Text(c))).toList(),
        rows: inquiries.map((i) {
          final date = i.submissionDate != null
              ? '${i.submissionDate!.day}/${i.submissionDate!.month}/${i.submissionDate!.year}'
              : '';
          return DataRow(
            cells: [
              DataCell(Text(date)),
              DataCell(Text(i.preferredLanguage)),
              DataCell(Text(i.firstName)),
              DataCell(Text(i.lastName)),
              DataCell(Text(i.email)),
              DataCell(Text(i.countryCode)),
              DataCell(Text(i.phone)),
              DataCell(Text(i.location)),
              DataCell(Text(i.entityName)),
              DataCell(Text(i.entityType)),
              DataCell(Text(i.entitySize)),
              DataCell(Text(i.subject)),
              DataCell(Text(i.message, maxLines: 1, overflow: TextOverflow.ellipsis)),
              DataCell(Text(i.note, maxLines: 1, overflow: TextOverflow.ellipsis)),
              DataCell(GestureDetector(
                onTap: () => navigateTo(context, InquiryDetailPage(inquiryId: i.id)),
                child: Text(i.status.label,
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: i.status.color)),
              )),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── Chart helpers (simple placeholder bars) ────────────────────────────────

  Widget _chartCard(String title, String subtitle, Widget chart) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: _C.cardBg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: _C.primary)),
        if (subtitle.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(subtitle, style: TextStyle(fontSize: 11.sp, color: _C.labelText)),
        ],
        SizedBox(height: 12.h),
        chart,
      ]),
    );
  }

  Widget _buildBarChart(Map<int, int> monthly) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final maxVal = monthly.values.fold(1, (a, b) => a > b ? a : b);
    return SizedBox(
      height: 120.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(12, (i) {
          final val = monthly[i + 1] ?? 0;
          final h = maxVal > 0 ? (val / maxVal) * 100.h : 0.0;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text('$val', style: TextStyle(fontSize: 8.sp, color: _C.labelText)),
                SizedBox(height: 2.h),
                Container(
                  height: h,
                  decoration: BoxDecoration(
                    color: _C.primary,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(months[i], style: TextStyle(fontSize: 8.sp, color: _C.hintText)),
              ]),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEntityTypeChart(Map<String, int> counts) {
    final total = counts.values.fold(0, (a, b) => a + b);
    return Column(
      children: counts.entries.map((e) {
        final pct = total > 0 ? (e.value / total * 100).round() : 0;
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(children: [
            SizedBox(width: 100.w, child: Text(e.key, style: TextStyle(fontSize: 10.sp, color: _C.labelText))),
            SizedBox(width: 8.w),
            Expanded(
              child: Container(
                height: 12.h,
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(6.r)),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: pct / 100,
                  child: Container(
                    decoration: BoxDecoration(color: _C.primary, borderRadius: BorderRadius.circular(6.r)),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text('$pct%', style: TextStyle(fontSize: 10.sp, color: _C.labelText)),
          ]),
        );
      }).toList(),
    );
  }

  Widget _buildSizeChart(Map<String, int> counts) {
    return Wrap(
      spacing: 16.w,
      runSpacing: 8.h,
      children: counts.entries.map((e) {
        return Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 10.sp, height: 10.sp, decoration: BoxDecoration(color: _C.primary, shape: BoxShape.circle)),
          SizedBox(width: 4.w),
          Text('${e.key}: ${e.value}', style: TextStyle(fontSize: 11.sp, color: _C.labelText)),
        ]);
      }).toList(),
    );
  }

  Widget _buildLocationChart(Map<String, int> counts) {
    final total = counts.values.fold(0, (a, b) => a + b);
    final maxVal = counts.values.fold(1, (a, b) => a > b ? a : b);
    return SizedBox(
      height: 120.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: counts.entries.map((e) {
          final pct = total > 0 ? (e.value / total * 100).round() : 0;
          final h = maxVal > 0 ? (e.value / maxVal) * 100.h : 0.0;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text('$pct%', style: TextStyle(fontSize: 8.sp, color: _C.labelText)),
                SizedBox(height: 2.h),
                Container(
                  height: h,
                  decoration: BoxDecoration(color: _C.primary, borderRadius: BorderRadius.circular(2.r)),
                ),
                SizedBox(height: 4.h),
                Text(e.key, style: TextStyle(fontSize: 8.sp, color: _C.hintText), overflow: TextOverflow.ellipsis),
              ]),
            ),
          );
        }).toList(),
      ),
    );
  }
}