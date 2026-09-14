---
name: Warm Minimal Tactile
colors:
  surface: '#f9f9f7'
  surface-dim: '#dadad8'
  surface-bright: '#f9f9f7'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f4f4f2'
  surface-container: '#eeeeec'
  surface-container-high: '#e8e8e6'
  surface-container-highest: '#e2e3e1'
  on-surface: '#1a1c1b'
  on-surface-variant: '#594238'
  inverse-surface: '#2f3130'
  inverse-on-surface: '#f1f1ef'
  outline: '#8c7166'
  outline-variant: '#e0c0b2'
  surface-tint: '#a23f00'
  primary: '#a23f00'
  on-primary: '#ffffff'
  primary-container: '#f36c21'
  on-primary-container: '#521c00'
  inverse-primary: '#ffb695'
  secondary: '#5f5e5e'
  on-secondary: '#ffffff'
  secondary-container: '#e2dfde'
  on-secondary-container: '#636262'
  tertiary: '#5d5f5b'
  on-tertiary: '#ffffff'
  tertiary-container: '#949591'
  on-tertiary-container: '#2c2e2b'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdbcc'
  primary-fixed-dim: '#ffb695'
  on-primary-fixed: '#351000'
  on-primary-fixed-variant: '#7c2e00'
  secondary-fixed: '#e5e2e1'
  secondary-fixed-dim: '#c8c6c5'
  on-secondary-fixed: '#1b1b1c'
  on-secondary-fixed-variant: '#474746'
  tertiary-fixed: '#e3e3de'
  tertiary-fixed-dim: '#c6c7c2'
  on-tertiary-fixed: '#1a1c19'
  on-tertiary-fixed-variant: '#464744'
  background: '#f9f9f7'
  on-background: '#1a1c1b'
  surface-variant: '#e2e3e1'
typography:
  display-hero:
    fontFamily: Plus Jakarta Sans
    fontSize: 44px
    fontWeight: '700'
    lineHeight: 52px
    letterSpacing: -0.03em
  display-hero-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 42px
    letterSpacing: -0.03em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.015em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 18px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 10px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.03em
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.875rem
  space-lg: 1.25rem
  space-xl: 1.75rem
---

## Brand & Style

This design system expresses a refined, tactile, soft-minimal aesthetic tailored for modern connected lifestyle and smart home interfaces. It bridges digital utility with physical warmth, evoking calm precision, effortless comfort, and architectural serenity. The visual language moves away from cold, hyper-glossy tech tropes toward an organic living room feel: warm ambient canvas tones, pure white floating planes, humanely rounded geometries, and purposeful bursts of energetic warmth.

Interactions evoke a quiet confidence. Surfaces feel soft to the touch, visual hierarchy is achieved through gentle tonal contrasts rather than harsh dividing lines, and critical appliance states glow with a vibrant hearth-like orange. The overall mood is welcoming, domestic, and unmistakably modern.

## Colors

The palette balances warm neutral foundations with high-clarity typographic contrast and an electric thermal accent.

- **Primary Canvas (`#F5F5F3`)**: A warm, calm oat/cream background that grounds the UI and softens screen glare compared to sterile cold whites.
- **Surface Elevation (`#FFFFFF`)**: Pure crisp white surfaces create dimensional separation from the canvas, acting as tactile cards and floating control pods.
- **Secondary / Content Fill (`#EFEFEA`)**: An internal nested container tint used for secondary metric wells, stat blocks, and unselected state chips.
- **Primary Ink (`#1E1E1E`)**: Deep charcoal-black delivering crisp readability and commanding presence for headers, bold metric values, and active icons without the harshness of pure `#000000`.
- **Secondary Ink (`#8A8A8E`)**: Subdued warm gray for metadata, unit indicators, inactive labels, and auxiliary status text.
- **Primary Accent (`#F36C21`)**: Energetic flame orange reserved for active thermal indicators, primary operational badges, active segment pill toggles, and critical action cues.

## Typography

Plus Jakarta Sans governs the entire system. Its geometric foundation, friendly aperture openness, and balanced warmth align seamlessly with clean, physical-inspired hardware interfaces.

- **Weight Contrast**: Headlines pair heavy semi-bold and bold weights with lighter secondary gray subtitles, creating instant structural readability at a glance.
- **Numerical Dominance**: Key numerical readouts (such as oven temps or countdown timers) use bold weights with tight tracking (`-0.03em`) to anchor the visual balance of control cards.
- **Case Conventions**: Natural sentence casing is prioritized across headers, labels, and badges to preserve an approachable, domestic atmosphere.

## Layout & Spacing

The layout model is fluid and card-centric. It uses generous internal breathing room while keeping outer margins tight to maximize touch targets on handheld displays.

- **Grid Alignment**: Mobile layouts utilize a 4-column structure with an outer canvas inset of `margin` (20px) and column gaps of `gutter` (16px). Dual-tile metric groups split the grid evenly (`2 cols + 2 cols`).
- **Internal Card Rhythm**: Outer surfaces enforce comfortable interior padding (`space-lg` or 20px) to house nested control surfaces comfortably. Nested sub-cards and metric tiles apply `space-md` (14px) or `space-lg` (20px).
- **Reflow Rules**: On wider viewports (tablets and dashboards), the layout scales into a multi-column modular card mesh rather than stretching individual cards full-width, locking individual card widths between 340px and 420px.

## Elevation & Depth

Visual depth avoids harsh borders and heavy shadows in favor of a soft-tactile, layered-surface model:

- **Base Layer (Canvas)**: Non-elevated flat plane rendered in `#F5F5F3`.
- **Card Tier (Elevation 1)**: Floating white modules (`#FFFFFF`) with ultra-diffuse ambient shadows: `0px 8px 24px -4px rgba(30, 30, 30, 0.04), 0px 2px 6px -1px rgba(30, 30, 30, 0.02)`. No border stroke is required.
- **Nested Insets (Elevation 0 - Recessed)**: Inside white cards, internal telemetry modules and data pods use flat neutral fills (`#EFEFEA` or `#F4F4F1`) with zero shadow, conveying physical recessed tactile trays.
- **Floating Controls (Elevation 2)**: Circular utility buttons (such as quick-add or notification bells) employ a subtle, higher-lift shadow: `0px 6px 16px -2px rgba(30, 30, 30, 0.07)`.

## Shapes

The design system embraces an ultra-rounded, soft-geometric shape language that reflects organic product design and physical hardware enclosures:

- **Primary Cards & Pods**: Generous corner radiuses (24px to 28px) soften interfaces and frame screen content into self-contained objects.
- **Nested Tiles**: Internal metric boxes within cards maintain an internal radius of 16px to 18px, conforming neatly to outer card perimeters.
- **Pill Badges & Buttons**: Interactive selectors, timeline range chips, and status badges take full pill curves (`border-radius: 9999px`).
- **Circular Utilities**: Secondary circular control buttons (such as add buttons, alert icons, and avatar slots) use perfect 1:1 circular aspect ratios with complete pill rounding.

## Components

### Buttons & Quick Actions
- **Circular Action Icon Button**: A 44px × 44px pure white or soft-neutral circular surface (`#FFFFFF` or `#EFEFEA`), housing a centered dark charcoal icon with subtle ambient elevation.
- **Primary Pill Action**: Vibrant orange solid background (`#F36C21`) with crisp white typography, pill shape, and horizontal padding of 20px.

### Badges & Status Chips
- **Active State Badge**: Filled with `#F36C21`, displaying bold, compact white typography (`label-sm` or `label-md`), full pill curvature, and 6px × 12px padding.
- **Segmented Range Pill**: A floating horizontal rail containing pill-shaped segment options. Unselected states display muted secondary gray text on transparent backgrounds; active selection is highlighted by a filled solid pill (either dark charcoal `#1E1E1E` or vibrant orange `#F36C21` with white text).

### Cards & Telemetry Containers
- **Device Row Card**: Solid white surface, 24px border radius, featuring a rounded circular icon tray (`#F5F5F3` or `#EFEFEA`) on the left, primary and secondary stacked labels in the center, and a subtle vertical three-dot menu trigger on the right.
- **Telemetry Tile**: Nested pod inside the parent surface using `#EFEFEA`, containing label metadata, high-contrast metric values, and mini status glyphs or radial progress arcs.

### Circular Metric Gauges
- **Radial Indicator**: A clean 24px–32px ring displaying a muted gray background track with an active arc stroke in dark charcoal (`#1E1E1E`) or flame orange (`#F36C21`), conveying percentage or progress without clutter.

### Input Controls & Toggles
- **Soft Switch**: A tactile pill track (height 28px, width 48px) filled with soft gray (`#E5E5DF`) when off and vibrant orange (`#F36C21`) when on. The circular thumb is pure white with a gentle ambient drop-shadow.
- **Lists & Dividers**: Avoid hairline borders. Separate consecutive items using rhythmic vertical spacing or clean alternating card pods.