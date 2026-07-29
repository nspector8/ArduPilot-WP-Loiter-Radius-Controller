# WP_LOITER_RAD Controller Installation Guide

## Overview

This guide explains installation and configuration of the ArduPilot WP_LOITER_RAD Controller system.

The project consists of two components:

### LRAD.lua

A standalone ArduPilot Lua script that provides:

* RC transmitter control of `WP_LOITER_RAD`
* Dynamic in-flight loiter radius adjustment
* Direction-preserving radius control
* Optional GCS radius notifications
* Selectable display units
The Lua script can be used with supported ArduPlane vehicles and does **not** require custom firmware.

### arduplane-WPLR-OSD.apj

An optional custom ArduPlane firmware build that adds:

* OSD loiter radius display
* Loiter direction indication
* Selectable display units

The included firmware is a **hardware-specific example build** created for the:

* TBS LUCID H7 WING flight controller

It should only be installed on compatible TBS LUCID H7 WING hardware.

Users with other ArduPilot-supported flight controllers should build their own firmware using:

```text
Patches/WP_LOITER_RAD_OSD.patch
```

---

# Requirements

## Lua Script

Required:

* ArduPlane with Lua scripting enabled
* Compatible ArduPilot vehicle

## Optional OSD Firmware

Required:

* TBS LUCID H7 WING (for included firmware)
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
Lua/LRAD.lua
```

Copy to:

```text
/APM/scripts/
```

on the aircraft SD card.

After installation:

1. Reboot the flight controller.
2. Confirm Lua scripting is running.
3. Verify the GCS message:

```text
WPLR: Loaded
```

---

# Parameter Configuration

## Enable Lua

Set:

```text
SCR_ENABLE = 1
```

Reboot the flight controller after enabling scripting.

---

## Assign Transmitter Control

Assign:

```text
RC Option 300
```

to the transmitter knob used for radius adjustment.

The knob controls:

```text
WP_LOITER_RAD
```

---

# Lua Parameters

| Parameter         | Description                      |
| ----------------- | -------------------------------- |
| `WPLR_MIN_RADIUS` | Minimum allowed loiter radius    |
| `WPLR_MAX_RADIUS` | Maximum allowed loiter radius    |
| `WPLR_RADIUS_DZ`  | Radius update deadzone           |
| `WPLR_GCS_MSG`    | Enable/disable GCS notifications |
| `WPLR_UNITS`      | GCS message units                |

Example:

```text
WPLR_MIN_RADIUS = -90
WPLR_MAX_RADIUS = -180
WPLR_RADIUS_DZ = 2
```

---

# GCS Message Control

The parameter:

```text
WPLR_GCS_MSG
```

controls radius notifications sent through GCS messages.

Values:

```text
0 = GCS messages ON (default)
1 = GCS messages OFF
```

When using the OSD loiter radius display with FPV goggles, set:

```text
WPLR_GCS_MSG = 1
```

to prevent duplicate radius notifications.

The OSD display will continue to operate normally.

---

# Optional OSD Firmware Installation

The OSD loiter radius display requires the custom firmware modification.

## Important Hardware Notice

The included firmware:

```text
Firmware/arduplane-WPLR-OSD.apj
```

was built specifically for:

```text
TBS LUCID H7 WING
```

Do **not** install this firmware on other flight controllers.

For other ArduPilot-supported boards:

1. Build compatible ArduPlane firmware.
2. Apply the AP_OSD modification patch:

```text
Patches/WP_LOITER_RAD_OSD.patch
```

3. Flash the resulting firmware.

---

## Installing the Provided Firmware

For compatible TBS LUCID H7 WING controllers:

Flash:

```text
Firmware/arduplane-WPLR-OSD.apj
```

using Mission Planner or another compatible ArduPilot flashing tool.

After flashing:

1. Allow the flight controller to reboot.
2. Confirm normal vehicle operation.
3. Configure the OSD display.

---

# OSD Loiter Radius Units

The firmware parameter:

```text
LOITRAD_UNITS
```

controls the OSD display units.

Values:

```text
0 = Feet (default)
1 = Meters
```

This parameter only affects the OSD loiter radius display.

It is independent from:

```text
WPLR_UNITS
```

which controls Lua GCS message units.

---

# Loiter Direction

ArduPilot uses the sign of:

```text
WP_LOITER_RAD
```

to determine loiter direction.

Positive value:

```text
WP_LOITER_RAD = 180
```

Creates a right-hand loiter.

Negative value:

```text
WP_LOITER_RAD = -180
```

Creates a left-hand loiter.

The Lua script preserves this behavior while ensuring increasing transmitter knob position always increases the physical loiter circle size.

---

# OSD Display

The custom firmware displays:

* Active `WP_LOITER_RAD`
* Loiter direction sign
* Selected display units

Examples:

Right-hand loiter:

```text
R:590
```

Left-hand loiter:

```text
R:-590
```

---

# Testing Procedure

Before flight testing:

1. Confirm the Lua script loads.
2. Move the transmitter knob.
3. Verify GCS radius updates.

Examples:

```text
WPLR: 300
```

or:

```text
WPLR: -300
```

If using the custom OSD firmware:

Confirm the OSD matches the active radius.

Examples:

```text
R:984
```

or:

```text
R:-984
```

Perform initial testing in a safe area.

---

# Safety Notes

This project modifies normal ArduPilot loiter behavior.

Before operational flight, verify:

* Correct loiter direction
* Correct radius scaling
* Correct RC control operation
* Correct GCS message behavior
* Correct OSD display behavior (if using custom firmware)

Always perform initial testing in a controlled environment.
