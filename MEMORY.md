# Developer Memory & Decisions

This file records hard-won lessons, quirks, and decisions that are easy to forget.

## Simulator Quirks

- **Settings persistence:** The simulator caches settings in a binary `REACTOR.SET` file under `$TMPDIR/com.garmin.connectiq/GARMIN/APPS/SETTINGS/`. Changing defaults in `properties.xml` and recompiling does NOT override the cached values. You **must** delete `REACTOR.SET` before relaunching. The `set_theme.sh` script handles this automatically.
- **App Settings Editor:** Opening the App Settings Editor (`Cmd+P`) from a `monkeydo`-launched session shows "No settings file found". This is normal when not using VS Code's Connect IQ extension. Use `set_theme.sh` instead.
- **Clean builds:** When changing `settings.xml`, `properties.xml`, or `drawables.xml`, always delete `bin/` and `gen/` before rebuilding to clear stale generated code. The `set_theme.sh` script now automates this step to avoid dirty cache errors.
- **OneDrive Dataless Files Lock:** macOS OneDrive can randomly lock `.png` files (e.g., `Operation timed out` / `Could not process image for bitmap`). To fix this, run `python scripts/fix_svg_icons.py` to cleanly regenerate the PNGs from your local SVG files.

## Layout Constraints (454×454 Fenix 8)

- **Chart Y offset:** `chartTopY = 44` (originally 64) was specifically chosen to avoid clipping by the circular screen bezel.
- **Chart gap:** The 18px gap between left and right charts aligns with the battery widget centerline.
- **Header Widget:** The top battery widget is centered vertically at `Y=14`, creating a perfect balance between the top bezel edge (`Y=0`) and the top of the charts (`Y=44`).
- **Central Layout Shift:** The entire central block (`ChartWidget`, `TimeWidget`, `BottomMetricsWidget`) was shifted up by 20 pixels to better balance the watchface vertically.
- **TimeWidget Date Size:** The text for day and month uses a font height of 22 (originally 14, then 18). The day number now uses `SegmentRenderer` at size 14x24 for all themes, eliminating the small VFD bitmaps.
- **TimeWidget Frame:** The outer cyan frame thickness was reduced from 4px to 3px for a slightly finer look.
- **TimeWidget separator:** The horizontal line between calendar and clock is dynamically calculated to span from the left edge of window 1 to the right edge of window 3.
- **Flank segment logic:** Maps metric values (HR: 60–180, Stress: 0–100, etc.) into 10 discrete LED-style segments.

## Rendering Decisions

- **Nixie tubes are sacred:** The VFD bitmap rendering path (`THEME_NIXIE_CYAN`) must never be modified or broken. The base bitmaps in `resources/drawables/vfd/` are the original Nixie tube art, and are processed via `scripts/process_nixie_images.py` to add a wire mesh, bloom, and unlit filament background to distinguish them from the LCD vectors.
- **True Nixie Tube Mode:** Added `THEME_NIXIE_AMBER` (Theme 10) which uses a set of ultra-high-resolution Nixie digits cropped tight (120px top, 50px bottom removed before scaling) to 72x104, giving a highly authentic amber gas-discharge glow that fills the entire digit space.
- **SegmentRenderer for LCD:** All non-Nixie themes use the procedural `SegmentRenderer` which draws 7-segment digits using filled polygons. Zero bitmaps, resolution-independent.
- **CompactFont:** Custom procedural font for date windows and bottom metrics. Extended to support `0-9`, `%` and all A-Z characters using rectangles and lines only — no curves.
- **Metric Icons (BMFont):** All 30 configurable metric icons (steps, stress, floors, etc.) are rendered using a single `BMFont` atlas (`MetricsIconsFont`) generated from Material Design Outlined icons. This replaces 30+ individual PNGs, saving massive amounts of RAM and compilation time, while allowing dynamic `dc.setColor()` tinting.
- **Battery font:** Reverted to system `Graphics.FONT_XTINY` because custom square vector fonts looked unnatural for standalone digits.
- **Flank font:** Uses native `Graphics.FONT_XTINY` for numeric readouts — aligns well without being overly dominant.

## Memory Management

- **BMFont Atlas:** All UI icons are packed into a single BMFont atlas (`metrics_icons.png`), eliminating the overhead of loading and caching `WatchUi.BitmapResource` objects.
- **No allocations in draw loop:** Renderers reuse passed structures and primitives. No new objects are created during `onUpdate()`.
- **Lazy loading:** VFD bitmaps (`_vfdDrawables`) and the `MetricsIconsFont` are loaded on first use, not during `initialize()`.

## Theme System Evolution

- **v1:** Single hardcoded Nixie Cyan style.
- **v2:** Added `digitStyle` (Tube vs Solid) + `themeColor` (5 colors) — two separate settings. This was confusing because you could select a color for Nixie mode (which had no effect).
- **v3 (current):** Unified into a single `themeStyle` setting (0–10). Value 0 = VFD Cyan bitmaps, values 1–5 = LCD segments, value 10 = True Nixie Amber bitmaps. Clean, no invalid combinations possible.

## Settings & Localization

- **On-Device Menu (`ReactorSettingsMenu.mc`):** Implements a fully localized, hierarchical on-device configuration menu (`Menu2`).
- **Options Exposed:** Theme Style (VFD/LCD), Top Battery Toggle, Left/Right Flank Metrics (7 options), and Bottom Slots 1-4 (30 options).
- **Localization:** Hardcoded Spanish strings were completely removed from code. All menu labels and metric names dynamically load from `resources/strings/strings.xml` and `resources-eng/strings/strings.xml` via `WatchUi.loadResource()`. This ensures the UI automatically adapts to the watch's system language (Spanish or English).

## Premium Feature Implementations

- **AOD Burn-In Protection:** Implemented in `TimeWidget.mc` and other widgets. When AMOLED devices (like Fenix 8) enter low-power sleep mode, heavy graphics are skipped and only the time/minimal date are drawn. The time text position shifts slightly based on minutes `(min % 7)` to prevent burn-in.
- **Dynamic Flank Gradients:** Flank gauges for severity-based metrics (Battery, Heart Rate, Stress) are dynamically colorized segment-by-segment (e.g., green -> amber -> red) based on the user's realtime data, rather than being a static color.
- **Complications API & Touch:** SDK targeted to `minSdkVersion="4.2.0"`. Added `ReactorDelegate.mc` extending `WatchUi.WatchFaceDelegate` with `onPress()`. Tapping flanks or bottom metrics intercepts pixel coordinates and triggers `Toybox.Complications.exitTo(id)` to open native Garmin apps like Heart Rate or Stress.
- **Partial Updates on AMOLED:** Explicitly skipped. AMOLED screens do not support the legacy `onPartialUpdate()` 1Hz MIP callback. High power 1Hz updates happen natively during the wrist gesture `onUpdate()`.
- **Industrial Custom Fonts:** Replaced `Graphics.FONT_XTINY` with our procedural `CompactFont.mc` vector class for all small numeric readouts. `CompactFont` was extended to support `%` and `.` using zero-memory polygon rendering, preserving the Nixie/LCD aesthetic without heavy bitmap fonts.

---

## Recent Developer Notes (AUTOGENERATED)

- 2026-08-06: Local build artifacts created during development:
  - `bin/reactor.prg` — runtime binary suitable for sideloading to a device (via MTP client/OpenMTP on macOS).
  - `bin/reactor.iq` — signed release package for Connect IQ Store distribution.

- macOS 26 MTP note: macOS does not mount MTP devices under `/Volumes`. Use OpenMTP or another MTP client to transfer `bin/reactor.prg` when developing on macOS.

- If you sideloaded with OpenMTP manually, verify the file placed on the device is `reactor.prg` and that you copied it into the APPS/GARMIN path exposed by the MTP client.

