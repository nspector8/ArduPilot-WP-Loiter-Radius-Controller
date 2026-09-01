# WP_LOITER_RAD Controller v1.2

**Release status:** Stable  
**Target:** ArduPlane 4.7.x+

## Overview

Version 1.2 refines the Lua-based loiter-radius controller with improved control handoff, clearer configuration, and optional unit-aware GCS messages. The controller remains hardware-independent at the Lua level and continues to use RC Option 300 to control `WP_LOITER_RAD`.

## What's New

### Improved loiter-radius control

- The initial RC knob position is now used to establish the starting `WP_LOITER_RAD` value when the script initializes.
- The knob continues to map from the configured minimum to maximum **absolute** radius, so moving the knob higher always produces a larger loiter circle.
- Positive and negative radius ranges are supported. Use positive values or negative values consistently when selecting the desired ArduPlane loiter-direction convention.
- Minimum and maximum absolute-radius values are automatically normalized if they are supplied in reverse order.
- A configurable deadzone helps prevent unnecessary parameter writes from small RC input changes.

### External `WP_LOITER_RAD` changes

Version 1.2 detects changes to `WP_LOITER_RAD` made outside the Lua controller and temporarily yields control instead of immediately overwriting the external value.

- External changes are accepted and tracked.
- The controller remains paused while the knob stays at the position where the external change was detected.
- Moving the knob away from that position returns control to the Lua script.
- On takeover, the controller applies the knob-selected radius and reports the new value through GCS when messages are enabled.

This makes it easier to make temporary manual or GCS adjustments without the script immediately fighting the change.

### GCS message control

The Lua script now exposes `LRAD_GCS_MSG`:

- `0` = GCS messages OFF
- `1` = GCS messages ON (default)

Radius-change messages are rate-limited to avoid flooding the GCS. The startup message identifies the script version and selected display units.

### Unit-aware GCS display

The Lua script now exposes `LRAD_UNITS`:

- `0` = Meters
- `1` = Feet (default)

GCS radius messages use the selected unit while the underlying `WP_LOITER_RAD` parameter remains in meters, as required by ArduPlane.

> **OSD note:** `LRAD_UNITS` controls Lua/GCS message formatting only. OSD functionality is provided separately by the `WP_LOITER_RAD` firmware patch and its own OSD unit setting. The Lua script does not directly access or control the OSD.

## Configuration

The script creates the following `LRAD_` parameters:

| Parameter | Default | Description |
|---|---:|---|
| `LRAD_MIN_RADIUS` | `-90` | Minimum absolute loiter radius, with sign selecting the radius convention. |
| `LRAD_MAX_RADIUS` | `-180` | Maximum absolute loiter radius, with sign selecting the radius convention. |
| `LRAD_RADIUS_DZ` | `2` | Minimum radius change before the knob writes a new value. |
| `LRAD_GCS_MSG` | `1` | Enable (`1`) or disable (`0`) Lua GCS messages. |
| `LRAD_UNITS` | `1` | GCS display units: meters (`0`) or feet (`1`). |

The script uses RC **Option 300**. Assign the desired transmitter knob or other RC control to this option.

## Firmware and OSD

The included custom firmware remains based on ArduPlane 4.7.x and is intended for the supported TBS LUCID H7 WING configuration documented in this repository.

The `WP_LOITER_RAD` OSD functionality remains implemented by the firmware patch in `Patches/WP_LOITER_RAD_OSD.patch`. The v1.2 Lua changes do not modify the OSD implementation.

If using a different flight controller or ArduPilot build, rebuild the firmware from source using the supplied patch and follow the custom-firmware build documentation.

## Compatibility

- ArduPlane **4.7.x+**
- Lua scripting enabled
- RC Option **300** available and assigned to a suitable control
- Custom OSD firmware is required only for the optional `WP_LOITER_RAD` OSD display

For hardware-specific firmware information, see `Documentation/FIRMWARE_COMPATIBILITY.md`.

## Upgrade Notes

If upgrading from v1.1:

1. Replace the existing Lua script with `LRAD_v1.2.lua`.
2. Copy it to the ArduPilot scripts directory as `LRAD_v1.2.lua`.
3. Reboot or reload the Lua scripting environment as appropriate.
4. Review the `LRAD_*` parameters and set your preferred minimum, maximum, deadzone, GCS-message, and unit settings.
5. Confirm the RC control is assigned to **Option 300**.
6. If you use the custom OSD firmware, review its OSD unit setting separately; it is independent of `LRAD_UNITS`.

The v1.2 release does **not** require a new OSD patch. The patch supplied with the repository remains applicable.

## Release Contents

The v1.2 release is associated with:

- `Lua/LRAD_v1.2.lua` — Lua controller v1.2
- `Patches/WP_LOITER_RAD_OSD.patch` — custom OSD firmware patch
- `Firmware/arduplane-WPLR-OSD.apj` — included custom ArduPlane firmware build

The included firmware image is carried forward from the previous release; the primary functional change in v1.2 is the Lua controller and its configuration/documentation.

## Known Considerations

- `WP_LOITER_RAD` is stored by ArduPilot in meters. Unit conversion in the Lua script affects displayed GCS messages, not the parameter's stored value.
- For predictable direction selection, configure both `LRAD_MIN_RADIUS` and `LRAD_MAX_RADIUS` with the same sign.
- The OSD patch has its own unit configuration and should be treated independently from `LRAD_UNITS`.

## Files and Documentation

- `Lua/LRAD_v1.2.lua`
- `Documentation/INSTALLATION.md`
- `Documentation/FIRMWARE_COMPATIBILITY.md`
- `Documentation/BUILDING_CUSTOM_FIRMWARE.md`
- `Patches/WP_LOITER_RAD_OSD.patch`
