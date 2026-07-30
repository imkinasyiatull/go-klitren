# GO Klitren

GO Klitren is a static, multi-page community information website for RW 13
and RW 16 in Kelurahan Klitren. The original design exports have been
reorganized and connected so each page has a descriptive filename and can be
opened from the rest of the website.

## Preview locally

Run a simple web server from this directory:

```powershell
python -m http.server 8000
```

Then open <http://localhost:8000>.

If Python is not installed, use the **Live Server** extension in Visual Studio
Code and choose **Open with Live Server** on `index.html`.

The pages also use relative links, so most navigation works when `index.html`
is opened directly. A local server is still recommended because it behaves
more like real hosting.

## Project structure

```text
.
|-- index.html                   # Homepage
|-- pages/
|   |-- rw-13.html               # RW 13 landing page
|   |-- rw-16.html               # RW 16 landing page
|   |-- programs.html            # Program and material catalog
|   |-- activities/              # RW activity detail pages
|   `-- programs/                # Program and material detail pages
|-- assets/
|   |-- data/
|   |   |-- activities/          # Blank activity-information worksheets
|   |   `-- program-links/       # URL worksheets for all program resources
|   `-- js/site.js               # Shared mobile menu and placeholder behavior
|-- scripts/
|   `-- sync-layout.ps1          # Synchronizes the shared header and footer
|   `-- sync-thumbnails.ps1      # Maps local program and UMKM thumbnails
|-- thumbnail/
|   |-- program/                 # Thumbnails for the 13 programs
|   `-- UMKM_RW_13/              # Flyers for the six RW 13 businesses
|-- docs/
|   `-- design-system.md         # Canonical visual design guide
|-- references/
|   `-- screens/                 # Original page screenshots
`-- archive/
    `-- duplicate-design-docs/   # Preserved duplicate design guides
```

## Naming rules

- Use lowercase names.
- Separate words with hyphens.
- Include the RW number in activity filenames.
- Keep program filenames short but descriptive.
- Put published HTML in `pages`; keep screenshots only in `references`.

Examples:

```text
pages/activities/rw-13-bank-sampah.html
pages/activities/rw-16-kelompok-tani.html
pages/programs/gizi-seimbang-anak.html
```

## What is connected

- The global navigation on all 29 pages.
- Homepage links to RW 13, RW 16, and the program catalog.
- All 12 activity cards link to their detail pages.
- All 13 program cards link to their detail pages.
- Back links and breadcrumbs return to the appropriate landing page.
- Existing mobile menu buttons now open a shared navigation menu.
- All supplied homepage, RW, activity, and program-documentation images.
- All supplied Google Drive, Google Sheets, and YouTube program resources.

## Content still needed

Some destinations were not included in the supplied content. These include:

- the official WhatsApp number or email for "Hubungi Kami";
- official Instagram, Facebook, and LinkedIn URLs;
- privacy, terms, FAQ, news, and about pages.

Program resource URLs are recorded in `assets/data/program-links/` and are
connected to their matching program pages.

The current typography and Tailwind CSS are loaded from remote services, so an
internet connection is needed for the intended design.

## Synchronize the shared layout

Every page uses the header and footer design from the RW 16 Kelompok Tani
page. If the canonical markup in `scripts/sync-layout.ps1` is changed, apply
it to all pages with:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-layout.ps1
```

The script preserves page content, assigns the correct active navigation item,
and calculates relative links for root, main, activity, and program pages.

## Synchronize thumbnails

Program and UMKM thumbnail mappings are maintained in
`scripts/sync-thumbnails.ps1`. Reapply them after changing a thumbnail with:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-thumbnails.ps1
```

The script updates the program catalog, program-detail previews, UMKM flyers,
accessible image descriptions, and the six UMKM business names.
