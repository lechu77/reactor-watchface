# REACTOR Watchface

**REACTOR** is a premium Garmin Connect IQ watchface engineered specifically for modern Garmin AMOLED smartwatches (like the Fenix 8 Series, Epix Gen 2, etc). It blends a hyper-optimized industrial aesthetic with retro design cues inspired by Nixie tubes, LCD screens, and vintage control panels.

## Features

- **Industrial Brutalist Aesthetic**: Clean, heavy geometric lines inspired by Dieter Rams' Braun designs and Casio watches.
- **Dynamic Flank Widgets**: 10-segment LED-style vertical gauges for tracking Heart Rate, Stress, Battery, Steps, Floors, and Intensity Minutes.
- **Real-Time Telemetry Charts**: A dual-channel historical chart at the top tracking sensor history trends (e.g., Heart Rate).
- **Custom Vector Typography**: Features `CompactFont`, an entirely procedural geometric vector font mapped for date windows and metrics.
- **Extremely Low Power Overhead**: Engineered from the ground up utilizing caching, layout isolation, and geometric primitive rendering to maximize battery life on AMOLED screens.
- **Interactive Themes**: Switch between `Nixie Cyan`, `LCD Green`, `LCD STN`, and `LCD Gray` right from the watch's settings menu.

## Architecture & Code Highlights

Built using a highly decoupled architecture:
1. **Views & Widgets:** `ReactorView` manages layout geometry, delegating drawing logic entirely to specialized UI Widgets (`HeaderWidget`, `ChartWidget`, `TimeWidget`, `BottomMetricsWidget`, `FlankWidget`).
2. **Data Abstraction:** The `DataProvider` handles reading from `Toybox.ActivityMonitor` and `SensorHistory`, while `MetricSlot` connects dynamic configuration properties to the physical draw calls.
3. **Optimized Rendering:** `CompactNumberRenderer` and `SegmentRenderer` perform complex, highly legible geometric draws using 0 bitmaps, bypassing expensive image memory loads for core temporal displays.

## Device Support

Primarily tested and optimized for:
- Garmin Fenix 8 (47mm & 51mm)
- Garmin Epix Pro
- Garmin Tactix AMOLED

## Building & Running

1. Ensure the Garmin Connect IQ SDK is installed.
2. Compile the project using VSCode or CLI `monkeyc`.
3. Push to a simulator or a physical Garmin watch.

```bash
# Build
./scripts/build.sh

# Run in simulator
./scripts/sim.sh
```

## Credits
Designed and Developed with precision.
