# WP_LOITER_RAD Controller Installation Guide

## Overview

This guide covers installation of the ArduPilot WP_LOITER_RAD Controller Lua script and the optional custom AP_OSD firmware modification.

The Lua script can be installed and used with standard ArduPilot firmware. The optional OSD functionality requires the custom firmware modification.

---

# Requirements

## Lua Script

Required:

* ArduPlane 4.7.x or newer
* Lua scripting enabled
* A transmitter control assigned to RC Option 300
* An SD card/scripts directory available to the flight controller

## Optional OSD Firmware

Required:

* TBS LUCID H7 WING for the included firmware
* DisplayPort OSD support

The included firmware:

```text
Firmware/arduplane-WPLR-OSD.apj
```

is not intended as a universal ArduPilot firmware file.

---

# Lua Script Installation

Lua script:

```text
Lua/LRAD_v1.2.lua
```

Copy `LRAD_v1.2.lua` from the current release assets to:

```text
/APM/scripts/
```

on the aircraft SD card.

Enable Lua scripting:

```text
SCR_ENABLE = 1
```

Reboot the flight controller after enabling scripting.

After installation, confirm the script is running by checking the GCS messages. The startup message should look similar to:

```text
LRAD v1.2: Loaded (Feet)
```

or:

```text
LRAD v1.2: Loaded (Meters)
```

---

# Assign the Transmitter Control

Assign:

```text
RC Option 300
```

to the transmitter control intended for loiter-radius adjustment.

---

# LRAD Parameter Configuration

After the script has been installed and loaded, configure the `LRAD_*` parameters as required for the aircraft.

The parameters created by the script are:

| Parameter | Default | Description |
| --- | ---: | --- |
| `LRAD_MIN_RADIUS` | `-90` | Minimum signed radius used by the knob range |
| `LRAD_MAX_RADIUS` | `-180` | Maximum signed radius used by the knob range |
| `LRAD_RADIUS_DZ` | `2` | Minimum radius change required before the script updates `WP_LOITER_RAD` |
| `LRAD_GCS_MSG` | `1` | GCS radius message control: `0` off, `1` on |
| `LRAD_UNITS` | `1` | GCS message units: `0` meters, `1` feet |

For usage details and parameter behavior, see the main `README.md`.

---

# Optional OSD Firmware Installation

The OSD loiter-radius display requires the custom firmware modification.

## Important Hardware Notice

The included firmware:

```text
Firmware/arduplane-WPLR-OSD.apj
```

was built specifically for:

```text
TBS LUCID H7 WING
```

**Do not install this firmware on other flight controllers.**

For other ArduPilot-supported boards, build compatible firmware for the target board and apply:

```text
Patches/WP_LOITER_RAD_OSD.patch
```

See `Documentation/BUILDING_CUSTOM_FIRMWARE.md` for the complete custom firmware build procedure.

---

## Installing the Provided Firmware

For compatible TBS LUCID H7 WING controllers, flash:

```text
Firmware/arduplane-WPLR-OSD.apj
```

using Mission Planner or another compatible ArduPilot flashing tool.

After flashing:

1. Allow the flight controller to reboot.
2. Confirm that the flight controller starts normally.
3. Install `Lua/LRAD_v1.2.lua` if the Lua controller is also being used.
4. Configure the OSD settings as required.

---

# Installation Notes

The Lua script and OSD firmware modification are independent components.

The Lua script does not require the custom firmware modification.

The included `.apj` firmware is board-specific and must only be flashed to the supported TBS LUCID H7 WING target.

Users with other ArduPilot-supported flight controllers must build firmware for the exact target board rather than using the included `.apj` file.

---

# Safety and Disclaimer

This project modifies normal ArduPilot loiter behavior and may affect aircraft operation.

Use of the provided Lua scripts, firmware files, patches, and documentation is entirely at the user's own risk. The user assumes all responsibility for installation, configuration, testing, operation, and any resulting damage, loss, or injury. No guarantee is made that the provided files are suitable for any particular aircraft, flight controller, or operating environment.

Always follow the appropriate ArduPilot and flight-controller safety procedures when installing firmware or operating the aircraft.
