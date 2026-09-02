# ArduPilot WP_LOITER_RAD Controller

## Overview

This project provides an ArduPlane Lua script for in-flight waypoint loiter-radius control, plus an optional custom AP_OSD firmware modification for displaying the active loiter radius on the OSD.

The Lua controller operates independently with standard ArduPilot firmware. The optional firmware modification adds the OSD display.

---

# Features

## Dynamic Loiter Radius Control

The Lua script (`LRAD_v1.2.lua`) provides:

* RC transmitter control of `WP_LOITER_RAD` using RC Option 300
* Initial knob position as the starting loiter radius
* Configurable minimum and maximum radius limits
* Positive and negative loiter radius support
* Increasing knob position always produces a larger physical loiter circle
* Deadzone protection
* Validation of zero and mismatched-sign MIN/MAX configurations
* Automatic swapping of reversed absolute MIN/MAX ranges
* Detection of external `WP_LOITER_RAD` changes
* Knob movement required before control is taken back after an external change
* Optional GCS radius notifications
* Configurable GCS message units (meters or feet)

---

# Usage

## RC Loiter Radius Control

Assign **RC Option 300** to a transmitter knob. The knob position is mapped across the configured absolute radius range.

A larger knob position always corresponds to a larger physical loiter circle, regardless of whether the configured radii are positive or negative.

For example:

```text
LRAD_MIN_RADIUS = -90
LRAD_MAX_RADIUS = -180
```

The controller treats the absolute values as a range from 90 to 180 meters and applies the negative sign. The lower knob position produces the smaller circle and the higher knob position produces the larger circle.

The knob position at startup is authoritative for the initial Lua-controlled radius.

## LRAD Parameters

The script creates the following parameters in the `LRAD_` parameter table:

| Parameter | Default | Description |
| --- | ---: | --- |
| `LRAD_MIN_RADIUS` | `-90` | Minimum signed radius used by the knob range |
| `LRAD_MAX_RADIUS` | `-180` | Maximum signed radius used by the knob range |
| `LRAD_RADIUS_DZ` | `2` | Minimum radius change required before updating `WP_LOITER_RAD` |
| `LRAD_GCS_MSG` | `1` | GCS radius messages: `0` off, `1` on |
| `LRAD_UNITS` | `1` | GCS message units: `0` meters, `1` feet |

### MIN/MAX Configuration

`LRAD_MIN_RADIUS` and `LRAD_MAX_RADIUS`:

* Cannot be `0`.
* Must have matching signs.
* Are automatically swapped by absolute magnitude if reversed.

Invalid zero or mixed-sign configurations prevent the controller from changing `WP_LOITER_RAD` until corrected.

The corresponding warnings are:

```text
LRAD: MIN/MAX cannot be zero
LRAD: MIN/MAX signs must match
LRAD: MIN/MAX swapped
```

## Deadzone

`LRAD_RADIUS_DZ` prevents frequent small changes to `WP_LOITER_RAD`. The parameter is updated only when the calculated knob radius differs from the last Lua-controlled radius by at least the configured deadzone. Values below `1` are treated as `1`.

## External WP_LOITER_RAD Changes

If `WP_LOITER_RAD` is changed outside the Lua controller, the new value is temporarily accepted and tracked. The current knob position becomes the takeover point, so the controller does not immediately overwrite the external change.

The pilot must move the knob before Lua takes control again.

## GCS Messages

Set `LRAD_GCS_MSG` to enable or disable radius notifications:

```text
0 = GCS messages OFF
1 = GCS messages ON (default)
```

Messages use the format:

```text
R:300
R:-300
```

Radius messages are limited to approximately one per second.

`LRAD_UNITS` controls the units used in these messages:

```text
0 = Meters
1 = Feet (default)
```

The sign is preserved in the displayed value. `WP_LOITER_RAD` remains in ArduPilot's native units.

---

# OSD Firmware Modification

The optional custom ArduPlane firmware modification adds a loiter-radius display element to the OSD.

It:

* Reads the active `WP_LOITER_RAD` value
* Displays the current loiter radius and direction
* Converts the displayed value between feet and meters
* Provides configurable OSD display position and enable settings

Example:

```text
R:590
R:-590
```

The OSD units are controlled independently by the firmware parameter `LOITRAD_UNITS`:

```text
0 = Feet (default)
1 = Meters
```

The OSD reads the active `WP_LOITER_RAD` directly, regardless of whether it was changed by Lua, a ground station, or another ArduPilot function.

The included firmware is a custom ArduPlane 4.7.x build for the **TBS LUCID H7 WING**. Users with other supported flight controllers should build their own firmware using the included AP_OSD modification patch.

For pilots who prefer to have the loiter radius displayed as an OSD element, flash:

```text
Firmware/arduplane-WPLR-OSD.apj
```

Use the firmware only with the matching flight controller. See `Documentation/BUILDING_CUSTOM_FIRMWARE.md` for building firmware for other controllers.

---

# Included Files

```text
ArduPilot-WP-Loiter-Radius-Controller

├── Firmware
│   └── arduplane-WPLR-OSD.apj
│
├── Lua
│   └── LRAD_v1.2.lua
│
├── Patches
│   └── WP_LOITER_RAD_OSD.patch
│
└── Documentation
    ├── INSTALLATION.md
    ├── FIRMWARE_COMPATIBILITY.md
    └── BUILDING_CUSTOM_FIRMWARE.md
```

---

# Installation

Install `LRAD_v1.2.lua` in:

```text
/APM/scripts/
```

Enable Lua scripting, configure the `LRAD_*` parameters, and assign RC Option 300 to a transmitter knob.

See `Documentation/INSTALLATION.md` for complete installation instructions.

---

# Tested Hardware

Aircraft:

* AtomRC Swordfish

Flight Controller:

* TBS LUCID H7 WING

Video / OSD System:

* Walksnail Avatar Goggles X
* Walksnail Avatar Moonlight VTX

OSD:

* DisplayPort OSD integration

---

# Compatibility

## Lua Script

The Lua script targets ArduPlane 4.7.x+ and requires a supported ArduPilot vehicle with Lua scripting enabled.

## Firmware

The included firmware is a custom ArduPlane 4.7.x build for the **TBS LUCID H7 WING**. Other supported flight controllers require a custom build using the included AP_OSD modification patch.

---

# Documentation

* Installation — `Documentation/INSTALLATION.md`
* Firmware compatibility — `Documentation/FIRMWARE_COMPATIBILITY.md`
* Custom firmware building — `Documentation/BUILDING_CUSTOM_FIRMWARE.md`

---

# Safety and Disclaimer

This project modifies normal ArduPilot loiter behavior and may affect aircraft operation.

Use of the provided Lua scripts, firmware files, patches, and documentation is entirely at the user's own risk. The user assumes all responsibility for installation, configuration, testing, operation, and any resulting damage, loss, or injury. No guarantee is made that the provided files are suitable for any particular aircraft, flight controller, or operating environment.

Always follow the appropriate ArduPilot and flight-controller safety procedures when installing firmware or operating the aircraft.
