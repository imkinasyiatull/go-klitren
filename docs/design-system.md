---
name: Lush Community
colors:
  surface: '#f6fbf4'
  surface-dim: '#d6dbd5'
  surface-bright: '#f6fbf4'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f0f5ef'
  surface-container: '#eaefe9'
  surface-container-high: '#e4eae3'
  surface-container-highest: '#dfe4de'
  on-surface: '#171d19'
  on-surface-variant: '#3e4942'
  inverse-surface: '#2c322e'
  inverse-on-surface: '#edf2ec'
  outline: '#6e7a71'
  outline-variant: '#bdcac0'
  surface-tint: '#006c47'
  primary: '#006c46'
  on-primary: '#ffffff'
  primary-container: '#16875b'
  on-primary-container: '#ffffff'
  inverse-primary: '#76daa7'
  secondary: '#00696f'
  on-secondary: '#ffffff'
  secondary-container: '#72f2fb'
  on-secondary-container: '#006e74'
  tertiary: '#9a4143'
  on-tertiary: '#ffffff'
  tertiary-container: '#b9595a'
  on-tertiary-container: '#ffffff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#92f7c2'
  primary-fixed-dim: '#76daa7'
  on-primary-fixed: '#002112'
  on-primary-fixed-variant: '#005234'
  secondary-fixed: '#76f5fe'
  secondary-fixed-dim: '#55d8e1'
  on-secondary-fixed: '#002022'
  on-secondary-fixed-variant: '#004f54'
  tertiary-fixed: '#ffdad8'
  tertiary-fixed-dim: '#ffb3b1'
  on-tertiary-fixed: '#410008'
  on-tertiary-fixed-variant: '#7c2b2e'
  background: '#f6fbf4'
  on-background: '#171d19'
  surface-variant: '#dfe4de'
typography:
  headline-xl:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '800'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 40px
  xl: 64px
  container-max: 1200px
  gutter: 24px
  margin-mobile: 16px
---

## Brand & Style
The design system is built to evoke a sense of optimism, neighborly warmth, and energetic growth. It targets a modern, community-focused audience that values clarity and approachability. 

The aesthetic is **Modern Organic**, blending a clean, systematic layout with a vibrant, nature-inspired color palette. It utilizes generous whitespace to create a "breathable" interface that feels welcoming rather than overwhelming. Visual interest is driven by high-contrast accent blocks and a tactile, layered approach to surfaces, ensuring the UI feels both digital-native and human-centric.

## Colors
The palette is rooted in a warm, "paper-like" cream base to reduce eye strain and feel more inviting than a sterile pure white. 

- **Primary Emerald:** Used for main actions, brand presence, and success states.
- **Secondary Turquoise:** Used for interactive secondary elements and categorized information.
- **Sunny Yellow & Warm Coral:** These are used sparingly as high-energy accents for badges, notifications, and call-to-action highlights.
- **Dark Green Typography:** Replaces pure black to maintain a harmonious, organic connection with the primary brand color while ensuring WCAG AA contrast compliance.

## Typography
This design system utilizes **Inter** for its exceptional legibility and neutral, modern character. 

- **Headlines:** Use tight letter-spacing and heavy weights (Bold/ExtraBold) to create a strong visual anchor.
- **Body Text:** Set with generous line-height to maintain the "airy" feel of the brand.
- **Labels:** Use Medium or SemiBold weights to ensure they stand out even at smaller sizes.
- **Scaling:** On mobile devices, large display headings should scale down by approximately 15-20% to ensure content remains the primary focus.

## Layout & Spacing
The layout follows a **Fluid Grid** philosophy with a clear 8px rhythmic base. 

- **Desktop:** A 12-column grid with 24px gutters. Large sections are separated by `xl` (64px) vertical spacing to maintain the "generous whitespace" brand pillar.
- **Mobile:** A 4-column grid with 16px side margins. Elements often stack vertically to maintain readability.
- **Alignment:** Content should predominantly be left-aligned to reflect a modern, systematic feel, using centered alignments only for hero sections or specific empty states.

## Elevation & Depth
Depth in this design system is created through **Ambient Shadows** and tonal stacking.

- **Level 0 (Background):** The warm cream surface (#FFFDF4).
- **Level 1 (Cards):** Pure white surfaces with a very soft, diffused shadow (Y: 4px, Blur: 20px, Color: 10% opacity of the Dark Green text color).
- **Level 2 (Interactive/Floating):** Higher elevation for modals or active states, using a more pronounced shadow (Y: 8px, Blur: 30px).
- **Accents:** Depth is occasionally reinforced by 2px solid strokes in the Primary Emerald or Dark Green for a "structured" look on smaller components like chips or input fields.

## Shapes
The shape language is friendly and approachable, favoring significant curvature.

- **Standard Elements:** Buttons and small containers use a 0.5rem (8px) radius.
- **Main Containers:** Cards and major content blocks utilize a `rounded-2xl` (1.5rem / 24px) radius to emphasize the soft, community-centric feel.
- **Icons:** Use simple, medium-weight outlines with rounded terminal ends to match the typography and corner radii.

## Components

- **Buttons:** Primary buttons are solid Primary Emerald with White text. Secondary buttons use a Secondary Turquoise background or a 2px Emerald outline. All buttons feature high-contrast states and 8px corner radii.
- **Cards:** Defined by white backgrounds, `rounded-2xl` corners, and soft ambient shadows. Content inside cards should have 24px padding.
- **Chips/Badges:** Use the Sunny Yellow and Warm Coral accents for status indicators. These should be pill-shaped with `label-sm` typography.
- **Input Fields:** Soft white background with a subtle 1px border in muted dark gray-green. On focus, the border thickens to 2px Primary Emerald.
- **Lists:** Clean, borderless rows separated by `sm` (12px) spacing, utilizing simple outline icons as lead elements.
- **Accent Blocks:** Use full-bleed background sections in Sunny Yellow or Secondary Turquoise to break up long pages and highlight key community announcements.