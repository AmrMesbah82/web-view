# website_app — Schema Alignment Audit

Comparison of the public **website_app** against the current **admin (web_app_admin)** schema
(collections after `cms` removal + the home/main split). Nothing below has been changed yet — this is the audit you asked for before aligning.

## 1. Collection path mismatches

The admin now writes to direct camelCase collections (no `cms` wrapper). The website still reads the old paths:

| Feature | website_app reads (now) | Admin writes (target) | Action |
|---|---|---|---|
| About Us | `cms/about_page` | `aboutPage/about_page` | change collection |
| Our Strategy | `cms/our_strategy` | `ourStrategy/our_strategy` | change collection |
| Terms of Service | `cms/terms_of_service` | `termsOfService/terms_of_service` | change collection |
| Careers page | `cms/careers` | `careersPage/careers` | change collection |
| Services page | `cms/service_page` | `servicesPage/service_page` | change collection |
| Our Teams | `cms/ourTeams` | `ourTeams/ourTeams` | change collection |
| About Company | `cmsPages/about_company` | `aboutCompany/about_company` | change collection |
| Careers Sections | `careers_cms/{key}` | `careersSections/{key}` | change collection |
| Contact Us | `contact_us_cms/main` | `contactUsPage/main` | change collection |
| Home | `cms/home_page` | `homePage/home_page` **+** `mainPage/main` | change path **+ merge two docs** (see §2) |
| Departments | `departments` | `departments` | OK — no change |
| Job Listings | `jobListings` | `jobListings` | OK |
| Applications | `jobListings/{job}/applications` | same | OK |
| Contact Submissions | `contact_submissions` | `contact_submissions` | OK |
| Blog | `blog_posts` | `blog_posts` | OK |

Files to edit (collection constants):
- `home/data/repository/home_repo_impl.dart` (`_collection='cms'`)
- `about_us/data/repository/about_repository_impl.dart` (`_collection='cms'` → split into 3)
- `careers/data/repository/careers_repo_impl.dart` (`_collection='cms'`)
- `careers/data/repository/our_teams_repo_impl.dart` (`collection('cms').doc('ourTeams')`)
- `careers/data/repository/careers_section_repository_impl.dart` (`careers_cms`)
- `services/data/repository/services_repository_impl.dart` (`_collection='cms'`)
- `contact_us/data/repository/contact_us_location_repository_impl.dart` (`contact_us_cms`)
- `about_company` reader (`cmsPages/about_company`)

## 2. Home / Main split — needs a decision

The admin split the old single home document into two collections:

- **`homePage/home_page`** — authoritative for home *content*: `title`, `shortDescription`, `sections`, publish schedule.
- **`mainPage/main`** — authoritative for site *chrome*: `branding`, `navButtons`, `footerColumns`, `socialLinks`, `headerItems`.

The website currently loads the **entire** `HomePageModel` (content **and** chrome) from one document. After the split, one document alone will have stale data for the half it doesn't own.

**Recommended fix:** the website home data source reads **both** documents and merges them —
chrome fields from `mainPage/main`, content fields from `homePage/home_page`.

## 3. Section `position` field

- Admin now stores `Sections_0_Position` = `left | leftCorner | right | rightCorner`.
- Website `SectionCardModel` has **no** `position` field; `home_hero_cards.dart` places the 4 sections **by index** (0=left outer, 1=left inner, 2=right inner, 3=right outer).

**Impact:** rendering still works by index, so this is **not** breaking. Add `position` only if you want the website to honor the stored value instead of the fixed index order (recommended for consistency).

## 4. Field names elsewhere

The website models share the same code lineage as the admin models (identical camelCase keys: `en`/`ar`, `iconUrl`, `imageUrl`, `textBoxColor`, `visibility`, etc.), so no field-name mismatches were found outside the two items above.

---

### Proposed alignment order (after your OK)
1. Update all collection constants in the website repos (§1).
2. Rework the home data source to merge `homePage/home_page` + `mainPage/main` (§2).
3. (Optional) Add `position` to the website `SectionCardModel` and use it in `home_hero_cards.dart` (§3).
