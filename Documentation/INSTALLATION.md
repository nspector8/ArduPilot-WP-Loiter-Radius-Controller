# WP_LOITER_RAD Controller Installation Guide

## Overview

This guide explains installation and configuration of the ArduPilot WP_LOITER_RAD Controller system.

The project consists of two components:

### LRAD.lua

Standalone Lua script that provides:

* RC transmitter control of `WP_LOITER_RAD`
* Dynamic in-flight loiter radius adjustment
* Direction-preserving radius control

The Lua script can be used with standard ArduPilot firmware.

### arduplane-WPLR-OSD.apj

Optional custom ArduPlane firmware that adds:

* OSD loiter radius display
* Loiter direction indication
* Selectable OSD display units

---

# Requirements

Required:

* ArduPlane 4.7.x or compatible
* Lua scripting enabled

Optional OSD features:

* Custom firmware
* DisplayPort OSD support

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

```text
SCR_ENABLE = 1
```

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

| Parameter       | Description                      |
| --------------- | -------------------------------- |
| WPLR_MIN_RADIUS | Minimum allowed loiter radius    |
| WPLR_MAX_RADIUS | Maximum allowed loiter radius    |
| WPLR_RADIUS_DZ  | Radius update deadzone           |
| WPLR_GCS_MSG    | Enable/disable GCS notifications |
| WPLR_UNITS      | GCS message units                |

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

controls radius notifications.

Values:

```text
0 = GCS messages ON (default)
1 = GCS messages OFF
```

When using the OSD display with FPV goggles, set:

```text
WPLR_GCS_MSG = 1
```

to avoid duplicate notifications.

---

# Optional OSD Firmware Installation

For pilots who want FPV display confirmation, install:

```text
Firmware/arduplane-WPLR-OSD.apj
```

using Mission Planner or another compatible ArduPilot flashing tool.

After flashing, configure the OSD element and units.

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

This parameter only affects the OSD display.

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

to determine direction.

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

The Lua script preserves this behavior while ensuring increasing knob position increases the physical loiter circle size.

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

1. Confirm Lua script loads.
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

If using OSD firmware:

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
* Correct OSD display behavior
