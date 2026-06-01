part of '../pages/contact_us_page.dart';

class _OfficeCard extends StatelessWidget {
  final ContactOfficeLocation office;
  final bool  isRtl;
  final Color primaryColor;
  const _OfficeCard(
      {required this.office,
        required this.isRtl,
        required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final String name = isRtl && office.locationName.ar.isNotEmpty
        ? office.locationName.ar
        : office.locationName.en;
    final String text = isRtl && office.text1.ar.isNotEmpty
        ? office.text1.ar
        : office.text1.en;

    final bool hasLink = office.mapLink.isNotEmpty;

    return GestureDetector(
      onTap: hasLink ? () => _launchMapLink(office.mapLink) : null,
      child: MouseRegion(
        cursor:
        hasLink ? SystemMouseCursors.click : MouseCursor.defer,
        child: Container(
          width:  double.infinity,
          padding: EdgeInsets.symmetric(
              vertical: 12.h),
          decoration: BoxDecoration(
              color:        const Color(0xFFF1F2ED),
              borderRadius: BorderRadius.circular(14.r)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (office.iconUrl.isNotEmpty)
                _officeIcon(
                    office.iconUrl, 80.w, 80.h, primaryColor)
              else
                Icon(Icons.location_on,
                    size: 80.w, color: primaryColor),
              SizedBox(height: 12.h),
              Text(name,
                  textAlign: TextAlign.center,
                  style: StyleText.fontSize16Weight700.copyWith(
                      color: primaryColor, fontSize: 13.sp)),
              SizedBox(height: 4.h),
              Text(text,
                  textAlign: TextAlign.center,
                  style: StyleText.fontSize13Weight400.copyWith(
                      color: Colors.black45, fontSize: 12.sp)),
            ],
          ),
        ),
      ),
    );
  }
}
