[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$programs = @(
    @{
        Title = "Daftar Shopee Merchant"
        Slug = "daftar-shopee-merchant"
        File = "thumbnail_daftar_shopee_merchant.png"
        Alt = "Thumbnail panduan daftar Shopee Merchant"
    },
    @{
        Title = "Administrasi Kas Sampah"
        Slug = "administrasi-kas-sampah"
        File = "thumbnail_administrasi_kas_sampah.jpg"
        Alt = "Thumbnail administrasi kas sampah"
    },
    @{
        Title = "Roadmap Ekonomi TOGA"
        Slug = "roadmap-ekonomi-toga"
        File = "thumbnail_roadmap_ekonomi_toga.jpg"
        Alt = "Thumbnail roadmap ekonomi TOGA"
    },
    @{
        Title = "Struktur Kepengurusan dan Monografi"
        Slug = "struktur-monografi"
        File = "thumbnail_struktur_monografi.jpg"
        Alt = "Thumbnail struktur kepengurusan dan monografi"
    },
    @{
        Title = "Peta Wilayah RW 13"
        Slug = "peta-wilayah-rw-13"
        File = "thumbnail_peta_rw_13.png"
        Alt = "Thumbnail peta wilayah RW 13"
    },
    @{
        Title = "Peta Wilayah RW 16"
        Slug = "peta-wilayah-rw-16"
        File = "thumbnail_peta_rw_16.png"
        Alt = "Thumbnail peta wilayah RW 16"
    },
    @{
        Title = "Aquaponik Galon Bekas"
        Slug = "aquaponik-galon-bekas"
        File = "thumbnail_aquaponik_galon_bekas.png"
        Alt = "Thumbnail aquaponik galon bekas"
    },
    @{
        Title = "Video Edukasi TOGA"
        Slug = "video-edukasi-toga"
        File = "thumbnail_video_edukasi_toga.png"
        Alt = "Thumbnail video edukasi TOGA"
    },
    @{
        Title = "Bijak Kelola Sampah UMKM"
        Slug = "bijak-kelola-sampah-umkm"
        File = "thumbnail_bijak_kelola_sampah_umkm.jpg"
        Alt = "Thumbnail materi bijak kelola sampah UMKM"
    },
    @{
        Title = "Panduan UMKM Berkembang"
        Slug = "panduan-umkm-berkembang"
        File = "thumbnail_panduan_umkm_berkembang.png"
        Alt = "Thumbnail panduan UMKM berkembang"
    },
    @{
        Title = "Sistem Akuaponik Lele"
        Slug = "sistem-akuaponik-lele"
        File = "thumbnail_sistem_akuaponik_lele.png"
        Alt = "Thumbnail sistem akuaponik lele"
    },
    @{
        Title = "Gizi Seimbang pada Anak"
        Slug = "gizi-seimbang-anak"
        File = "thumbnail_gizi_seimbang_anak.png"
        Alt = "Thumbnail panduan gizi seimbang pada anak"
    },
    @{
        Title = "Pupuk Organik Cair (POC)"
        Slug = "pupuk-organik-cair"
        File = "thumbnail_pupuk_organik_cair.png"
        Alt = "Thumbnail pembuatan pupuk organik cair"
    }
)

$umkm = @(
    @{
        Name = "WARUNG IJO &ldquo;BU YATI&rdquo;"
        File = "umkm_1.png"
        Alt = "Poster WARUNG IJO BU YATI"
    },
    @{
        Name = "WARUNG IJO &ldquo;BU SRI&rdquo;"
        File = "umkm_2.png"
        Alt = "Poster WARUNG IJO BU SRI"
    },
    @{
        Name = "SEGO PECEL GOBYOS"
        File = "umkm_3.png"
        Alt = "Poster SEGO PECEL GOBYOS"
    },
    @{
        Name = "NASI RAMES &ldquo;BU IIM&rdquo;"
        File = "umkm_4.png"
        Alt = "Poster NASI RAMES BU IIM"
    },
    @{
        Name = "WARUNG MAKAN PAWON IJO BY DUE LAUK"
        File = "umkm_5.png"
        Alt = "Poster WARUNG MAKAN PAWON IJO BY DUE LAUK"
    },
    @{
        Name = "NASI PEDAS BAKMI JAWA KLITREN"
        File = "umkm_6.png"
        Alt = "Informasi NASI PEDAS BAKMI JAWA KLITREN"
    }
)

function Set-FirstImage {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Html,

        [Parameter(Mandatory = $true)]
        [string] $Source,

        [Parameter(Mandatory = $true)]
        [string] $Alt
    )

    $imageMatch = [regex]::Match($Html, "<img\b[^>]*>", "IgnoreCase")
    if (-not $imageMatch.Success) {
        throw "No image was found in the selected HTML block."
    }

    $imageTag = $imageMatch.Value
    $imageTag = [regex]::Replace(
        $imageTag,
        "\s+(?:data-alt|alt)=""[^""]*""",
        "",
        "IgnoreCase"
    )
    $imageTag = [regex]::Replace(
        $imageTag,
        "\s+src=""[^""]*""",
        " src=""$Source""",
        "IgnoreCase"
    )
    $imageTag = $imageTag.Replace("object-cover", "object-contain")
    $encodedAlt = [System.Net.WebUtility]::HtmlEncode($Alt)
    $imageTag = $imageTag.Insert(4, " alt=""$encodedAlt""")

    return (
        $Html.Substring(0, $imageMatch.Index) +
        $imageTag +
        $Html.Substring($imageMatch.Index + $imageMatch.Length)
    )
}

function Replace-Match {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Html,

        [Parameter(Mandatory = $true)]
        [System.Text.RegularExpressions.Match] $Match,

        [Parameter(Mandatory = $true)]
        [string] $Replacement
    )

    return (
        $Html.Substring(0, $Match.Index) +
        $Replacement +
        $Html.Substring($Match.Index + $Match.Length)
    )
}

$catalogPath = Join-Path $projectRoot "pages\programs.html"
$catalogHtml = [System.IO.File]::ReadAllText($catalogPath)

foreach ($program in $programs) {
    $escapedTitle = [regex]::Escape($program.Title)
    $articlePattern =
        "(?is)<article\b(?=[^>]*\bdata-title=""$escapedTitle"")[^>]*>.*?</article>"
    $articleMatch = [regex]::Match($catalogHtml, $articlePattern)

    if (-not $articleMatch.Success) {
        throw "Could not find the catalog card for $($program.Title)."
    }

    $articleHtml = Set-FirstImage `
        -Html $articleMatch.Value `
        -Source "../thumbnail/program/$($program.File)" `
        -Alt $program.Alt

    $catalogHtml = Replace-Match `
        -Html $catalogHtml `
        -Match $articleMatch `
        -Replacement $articleHtml
}

[System.IO.File]::WriteAllText($catalogPath, $catalogHtml, $utf8NoBom)

$specialDetailPages = @(
    "administrasi-kas-sampah",
    "peta-wilayah-rw-13"
)

foreach ($program in $programs) {
    if ($specialDetailPages -contains $program.Slug) {
        continue
    }

    $detailPath = Join-Path $projectRoot "pages\programs\$($program.Slug).html"
    if (-not (Test-Path -LiteralPath $detailPath -PathType Leaf)) {
        throw "Missing program detail page: $detailPath"
    }

    $detailHtml = [System.IO.File]::ReadAllText($detailPath)
    $detailHtml = Set-FirstImage `
        -Html $detailHtml `
        -Source "../../thumbnail/program/$($program.File)" `
        -Alt $program.Alt

    [System.IO.File]::WriteAllText($detailPath, $detailHtml, $utf8NoBom)
}

$umkmPath = Join-Path $projectRoot "pages\activities\rw-13-umkm.html"
$umkmHtml = [System.IO.File]::ReadAllText($umkmPath)
$umkmCards = [regex]::Matches(
    $umkmHtml,
    "(?is)<article\b[^>]*>.*?</article>"
)

if ($umkmCards.Count -ne $umkm.Count) {
    throw "Expected $($umkm.Count) UMKM cards, found $($umkmCards.Count)."
}

for ($index = $umkm.Count - 1; $index -ge 0; $index--) {
    $business = $umkm[$index]
    $cardMatch = $umkmCards[$index]
    $cardHtml = Set-FirstImage `
        -Html $cardMatch.Value `
        -Source "../../thumbnail/UMKM_RW_13/$($business.File)" `
        -Alt $business.Alt

    $headingMatch = [regex]::Match(
        $cardHtml,
        "(?is)(?<open><h2\b[^>]*>).*?</h2>"
    )
    if (-not $headingMatch.Success) {
        throw "Missing heading in UMKM card $($index + 1)."
    }

    $newHeading = $headingMatch.Groups["open"].Value + $business.Name + "</h2>"
    $cardHtml = Replace-Match `
        -Html $cardHtml `
        -Match $headingMatch `
        -Replacement $newHeading

    $umkmHtml = Replace-Match `
        -Html $umkmHtml `
        -Match $cardMatch `
        -Replacement $cardHtml
}

$umkmHtml = $umkmHtml.Replace(
    '<div class="h-48 relative overflow-hidden">',
    '<div class="h-64 relative overflow-hidden bg-surface-container-low p-2">'
)

[System.IO.File]::WriteAllText($umkmPath, $umkmHtml, $utf8NoBom)

Write-Output "Synchronized 13 program thumbnails and 6 UMKM thumbnails/names."
