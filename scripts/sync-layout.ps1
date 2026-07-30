[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$htmlFiles = Get-ChildItem -LiteralPath $projectRoot -Recurse -Filter "*.html"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$inactiveNavClass = "text-on-surface-variant dark:text-on-surface-variant font-label-md text-label-md hover:text-primary dark:hover:text-primary-fixed transition-colors"
$activeNavClass = "text-primary dark:text-primary-fixed font-bold border-b-2 border-primary font-label-md text-label-md"
$footerLinkClass = "text-on-surface-variant dark:text-on-surface-variant font-label-sm text-label-sm hover:underline hover:text-secondary transition-all duration-200"

$topLayoutPattern = New-Object System.Text.RegularExpressions.Regex(
    "(?is)(?<prefix><body\b[^>]*>\s*(?:<!--.*?-->\s*)*)(?<layout><(?<tag>header|nav)\b.*?</\k<tag>>)"
)
$footerPattern = New-Object System.Text.RegularExpressions.Regex(
    "(?is)<footer\b.*?</footer>"
)
$bodyClassPattern = New-Object System.Text.RegularExpressions.Regex(
    "(?is)(?<start><body\b[^>]*\bclass="")(?<classes>[^""]*)(?<end>"")"
)

function Get-PageContext {
    param(
        [Parameter(Mandatory = $true)]
        [string] $RelativePath
    )

    $normalized = $RelativePath.Replace("\", "/")
    $isRoot = $normalized -eq "index.html"
    $isNested =
        $normalized.StartsWith("pages/activities/") -or
        $normalized.StartsWith("pages/programs/")

    if ($isRoot) {
        $links = @{
            Home = "index.html"
            Rw13 = "pages/rw-13.html"
            Rw16 = "pages/rw-16.html"
            Programs = "pages/programs.html"
        }
    }
    elseif ($isNested) {
        $links = @{
            Home = "../../index.html"
            Rw13 = "../rw-13.html"
            Rw16 = "../rw-16.html"
            Programs = "../programs.html"
        }
    }
    else {
        $links = @{
            Home = "../index.html"
            Rw13 = "rw-13.html"
            Rw16 = "rw-16.html"
            Programs = "programs.html"
        }
    }

    if ($normalized -eq "index.html") {
        $activePage = "Home"
    }
    elseif (
        $normalized -eq "pages/rw-13.html" -or
        $normalized.StartsWith("pages/activities/rw-13-")
    ) {
        $activePage = "Rw13"
    }
    elseif (
        $normalized -eq "pages/rw-16.html" -or
        $normalized.StartsWith("pages/activities/rw-16-")
    ) {
        $activePage = "Rw16"
    }
    else {
        $activePage = "Programs"
    }

    return @{
        ActivePage = $activePage
        Links = $links
    }
}

function Get-NavClass {
    param(
        [Parameter(Mandatory = $true)]
        [string] $PageName,

        [Parameter(Mandatory = $true)]
        [string] $ActivePage
    )

    if ($PageName -eq $ActivePage) {
        return $activeNavClass
    }

    return $inactiveNavClass
}

function Add-BodyLayoutClasses {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Html
    )

    $match = $bodyClassPattern.Match($Html)
    if (-not $match.Success) {
        throw "The page does not have a body class attribute."
    }

    $classes = @($match.Groups["classes"].Value -split "\s+" | Where-Object { $_ })
    foreach ($requiredClass in @("min-h-screen", "flex", "flex-col")) {
        if ($classes -notcontains $requiredClass) {
            $classes += $requiredClass
        }
    }

    $replacement =
        $match.Groups["start"].Value +
        ($classes -join " ") +
        $match.Groups["end"].Value

    return (
        $Html.Substring(0, $match.Index) +
        $replacement +
        $Html.Substring($match.Index + $match.Length)
    )
}

$changedFiles = 0

foreach ($file in $htmlFiles) {
    $relativePath = $file.FullName.Substring($projectRoot.Length + 1)
    $context = Get-PageContext -RelativePath $relativePath
    $links = $context.Links
    $activePage = $context.ActivePage

    $homeClass = Get-NavClass -PageName "Home" -ActivePage $activePage
    $rw13Class = Get-NavClass -PageName "Rw13" -ActivePage $activePage
    $rw16Class = Get-NavClass -PageName "Rw16" -ActivePage $activePage
    $programsClass = Get-NavClass -PageName "Programs" -ActivePage $activePage

    $header = @"
<header class="bg-surface dark:bg-surface-container-high docked full-width top-0 shadow-sm sticky z-50" data-site-header>
<div class="flex justify-between items-center px-margin-mobile md:px-xl py-base w-full max-w-container-max mx-auto">
<a class="font-headline-md text-headline-md font-extrabold text-primary dark:text-primary-fixed" href="$($links.Home)">GO Klitren</a>
<nav class="hidden md:flex gap-gutter" aria-label="Navigasi utama">
<a class="$homeClass" href="$($links.Home)">Beranda</a>
<a class="$rw13Class" href="$($links.Rw13)">RW 13</a>
<a class="$rw16Class" href="$($links.Rw16)">RW 16</a>
<a class="$programsClass" href="$($links.Programs)">Program dan Materi</a>
</nav>
<button class="bg-primary hover:bg-primary-container text-on-primary font-label-md text-label-md py-2 px-4 rounded-lg transition-colors hidden md:block" type="button">
                Hubungi Kami
            </button>
<button aria-label="Menu" class="md:hidden text-primary" type="button">
<span class="material-symbols-outlined" aria-hidden="true">menu</span>
</button>
</div>
</header>
"@

    $footer = @"
<footer class="bg-surface-container-lowest dark:bg-surface-container-low border-t border-outline-variant full-width mt-auto" data-site-footer>
<div class="flex flex-col items-center text-center py-xl px-margin-mobile md:px-xl w-full">
<a class="font-headline-md text-headline-md font-bold text-primary dark:text-primary-fixed mb-4" href="$($links.Home)">GO Klitren</a>
<nav class="flex flex-wrap justify-center gap-gutter mb-6" aria-label="Navigasi footer">
<a class="$footerLinkClass" href="$($links.Home)">Beranda</a>
<a class="$footerLinkClass" href="$($links.Rw13)">RW 13</a>
<a class="$footerLinkClass" href="$($links.Rw16)">RW 16</a>
<a class="$footerLinkClass" href="$($links.Programs)">Program dan Materi</a>
</nav>
<div class="font-body-md text-body-md text-on-surface-variant">&copy; 2026 GO Klitren</div>
</div>
</footer>
"@

    $html = [System.IO.File]::ReadAllText($file.FullName)
    $originalH1Count = ([regex]::Matches($html, "<h1\b", "IgnoreCase")).Count
    $originalMainCount = ([regex]::Matches($html, "<main\b", "IgnoreCase")).Count

    $topMatch = $topLayoutPattern.Match($html)
    if (-not $topMatch.Success) {
        throw "Could not identify the top-level header/navigation in $relativePath"
    }

    $layoutGroup = $topMatch.Groups["layout"]
    $html =
        $html.Substring(0, $layoutGroup.Index) +
        $header +
        $html.Substring($layoutGroup.Index + $layoutGroup.Length)

    $footerMatches = $footerPattern.Matches($html)
    if ($footerMatches.Count -ne 1) {
        throw "Expected one footer in $relativePath, found $($footerMatches.Count)"
    }

    $footerMatch = $footerMatches[0]
    $html =
        $html.Substring(0, $footerMatch.Index) +
        $footer +
        $html.Substring($footerMatch.Index + $footerMatch.Length)

    $html = Add-BodyLayoutClasses -Html $html

    $newH1Count = ([regex]::Matches($html, "<h1\b", "IgnoreCase")).Count
    $newMainCount = ([regex]::Matches($html, "<main\b", "IgnoreCase")).Count
    $siteHeaderCount = ([regex]::Matches($html, "data-site-header")).Count
    $siteFooterCount = ([regex]::Matches($html, "data-site-footer")).Count

    if ($originalH1Count -ne $newH1Count -or $originalMainCount -ne $newMainCount) {
        throw "Content boundary validation failed for $relativePath"
    }

    if ($siteHeaderCount -ne 1 -or $siteFooterCount -ne 1) {
        throw "Shared layout validation failed for $relativePath"
    }

    [System.IO.File]::WriteAllText($file.FullName, $html, $utf8NoBom)
    $changedFiles++
}

Write-Output "Synchronized the canonical header and footer across $changedFiles pages."
