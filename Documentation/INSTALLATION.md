# WP_LOITER_RAD Controller Installation Guide

## Overview

This guide explains installation and configuration of the ArduPilot WP_LOITER_RAD Controller system.

The project consists of two independent components:

### LRAD_v1.2.lua

A standalone ArduPilot Lua script that provides:

* RC transmitter control of `WP_LOITER_RAD` using RC Option 300
* Initial knob position sets the starting loiter radius
* Adjustable minimum and maximum radius
* Positive or negative loiter-radius support
* Intuitive scaling where increasing knob position always increases the physical loiter circle size
* Deadzone protection
* Detection and acceptance of external `WP_LOITER_RAD` changes
* Knob-movement takeover after an external change
* Optional GCS radius notifications
* Selectable GCS display units

The current Lua version is **v1.2** and targets **ArduPlane 4.7.x+**.

The Lua script can be used with supported ArduPlane vehicles and does **not** require custom firmware.

### Optional AP_OSD firmware modification

The optional custom ArduPlane firmware modification adds:

* OSD loiter radius display
* Loiter direction indication through the sign
* Selectable OSD display units
* Configurable OSD position and enable settings

The Lua script does not directly access or control the OSD. The OSD functionality is provided by the firmware modification.

The included firmware is a **hardware-specific example build** created for the:

* TBS LUCID H7 WING flight controller

It should only be installed on compatible hardware.

Users with other ArduPilot-supported flight controllers should build their own firmware using:

```text
Patches/WP_LOITER_RAD_OSD.patch
```

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

Copy it to:

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

to the transmitter knob used for radius adjustment.

The knob controls:

```text
WP_LOITER_RAD
```

The full knob range is mapped between the configured minimum and maximum **absolute** radius values. A higher knob position always produces a larger physical loiter circle.

---

# LRAD Parameters

The script creates the following parameters in the `LRAD_` parameter table:

| Parameter | Default | Description |
| --- | ---: | --- |
| `LRAD_MIN_RADIUS` | `-90` | Minimum absolute loiter radius used by the knob range |
| `LRAD_MAX_RADIUS` | `-180` | Maximum absolute loiter radius used by the knob range |
| `LRAD_RADIUS_DZ` | `2` | Minimum radius change required before the script updates `WP_LOITER_RAD` |
| `LRAD_GCS_MSG` | `1` | GCS radius message control: `0` off, `1` on |
| `LRAD_UNITS` | `1` | GCS message units: `0` meters, `1` feet |

### Example configuration

For a left-hand loiter range from 90 to 180 meters:

```text
LRAD_MIN_RADIUS = -90
LRAD_MAX_RADIUS = -180
LRAD_RADIUS_DZ = 2
LRAD_GCS_MSG = 1
LRAD_UNITS = 1
```

Because the script works from the absolute radius values, the higher knob position corresponds to `-180`, while the lower knob position corresponds to `-90`. The resulting circle therefore becomes larger as the knob is increased.

If `MIN_RADIUS` and `MAX_RADIUS` have reversed absolute magnitudes, the script automatically swaps the range and sends:

```text
LRAD: MIN/MAX swapped
```

---

# Initial Knob Position

When the script first obtains the RC channel, it uses the current knob position to calculate the starting radius and writes that value to `WP_LOITER_RAD`.

This means the knob position at startup is authoritative for the initial Lua-controlled radius.

After startup, the script monitors `WP_LOITER_RAD` for changes made outside the Lua controller.

---

# External WP_LOITER_RAD Changes

The v1.2 script detects an external change to `WP_LOITER_RAD`.

For example, if a ground station changes `WP_LOITER_RAD` while the transmitter knob remains stationary:

1. The script detects that the parameter changed from the last Lua-controlled value.
2. The external value is accepted and tracked.
3. The script does not immediately overwrite the external value with the knob's current value.
4. The current knob-selected radius becomes the takeover reference.
5. The pilot moves the knob.
6. The first knob movement after the external change returns control to Lua and sets `WP_LOITER_RAD` to the new knob-selected radius.

This behavior prevents a stationary knob from immediately undoing an intentional external parameter change.

---

# Deadzone

`LRAD_RADIUS_DZ` prevents frequent small changes to `WP_LOITER_RAD`.

The script only updates the parameter when the calculated knob radius differs from the last Lua-controlled radius by at least the configured deadzone.

Values below `1` are treated as `1`.

---

# GCS Message Control

The parameter:

```text
LRAD_GCS_MSG
```

controls radius notifications sent through GCS messages.

Values:

```text
0 = GCS messages OFF
1 = GCS messages ON (default)
```

Radius updates are sent in the form:

```text
R: 300
```

or:

```text
R: -300
```

Messages are rate-limited to approximately one per second.

If using the custom OSD firmware and you do not want duplicate radius information in the GCS, set:

```text
LRAD_GCS_MSG = 0
```

The OSD display is independent of this parameter and will continue to operate normally.

---

# Lua Display Units

The parameter:

```text
LRAD_UNITS
```

controls the units used for Lua GCS radius messages.

Values:

```text
0 = Meters
1 = Feet (default)
```

The displayed sign is preserved:

```text
R: 984
R: -984
```

The unit selection only affects the Lua GCS message. It does not change the underlying `WP_LOITER_RAD` parameter, which remains in ArduPilot's native units.

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

**Do not install this firmware on other flight controllers.**

For other ArduPilot-supported boards:

1. Build compatible ArduPlane firmware for the target board.
2. Apply the AP_OSD modification patch:

```text
Patches/WP_LOITER_RAD_OSD.patch
```

3. Build the firmware.
4. Flash the resulting firmware.

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
3. Install and configure `Lua/LRAD_v1.2.lua` if the Lua controller is also being used.
4. Configure the OSD loiter-radius element.

---

# OSD Loiter Radius Settings

The firmware patch adds the following OSD settings:

```text
LOITRAD_EN
LOITRAD_X
LOITRAD_Y
LOITRAD_UNITS
```

`LOITRAD_UNITS` controls the OSD display units:

```text
0 = Feet (default)
1 = Meters
```

This setting is independent from:

```text
LRAD_UNITS
```

which controls Lua GCS message units.

The OSD display reads the active `WP_LOITER_RAD` value directly. It is therefore independent of whether the value was most recently changed by the Lua script, a ground station, or another ArduPilot function.

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

The Lua controller preserves this behavior while mapping increasing transmitter knob position to increasing physical circle size.

---

# OSD Display

The custom firmware displays the active `WP_LOITER_RAD` value with its sign.

Examples:

Right-hand loiter:

```text
R:590
```

Left-hand loiter:

```text
R:-590
```

The value can be displayed in feet or meters according to `LOITRAD_UNITS`.

---

# Testing Procedure

Perform the following checks before flight:

1. Confirm the Lua script loads and reports `LRAD v1.2`.
2. Verify the selected startup units in the load message.
3. Confirm RC Option 300 is assigned to the intended knob.
4. Move the knob through its range and verify the physical radius increases as the knob is increased.
5. Verify positive values produce right-hand loiters and negative values produce left-hand loiters.
6. Verify the configured minimum and maximum radius are respected.
7. Verify the deadzone prevents unnecessary updates.
8. Change `WP_LOITER_RAD` externally and confirm the Lua controller accepts the change without immediately overwriting it.
9. Move the knob and confirm Lua control resumes.
10. If GCS messages are enabled, verify messages use the selected units.
11. If using the custom OSD firmware, verify the OSD matches the active `WP_LOITER_RAD` value and selected OSD units.

Example GCS messages:

```text
R: 300
```

or:

```text
R: -300
```

Example OSD displays:

```text
R:984
```

or:

```text
R:-984
```

Perform initial testing in a safe, controlled area before operational flight.

---

# Safety Notes

This project modifies normal ArduPilot loiter behavior.

Before operational flight, verify:

* Correct loiter direction
* Correct radius scaling
* Correct startup knob behavior
* Correct external-parameter takeover behavior
* Correct RC control operation
* Correct GCS message behavior
* Correct OSD display behavior, if using custom firmware
* Correct firmware target for the flight controller

Always perform initial testing in a controlled environment and confirm the aircraft behaves as expected before relying on the controller in flight.
