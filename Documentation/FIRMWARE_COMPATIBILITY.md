# Firmware Compatibility

## Lua Script Compatibility

`Lua/LRAD_v1.2.lua` targets **ArduPlane 4.7.x+**.

The Lua script is hardware independent and can be used on supported ArduPlane flight controllers with Lua scripting enabled and RC Option 300 assigned to a transmitter control.

The Lua controller does not require the custom OSD firmware modification.

---

## Included Firmware

The firmware file:

```text
Firmware/arduplane-WPLR-OSD.apj
```

is a custom ArduPlane 4.7.x build created for:

- TBS LUCID H7 WING flight controller

This firmware should **only** be installed on compatible TBS LUCID H7 WING hardware.

The `.apj` file is not a universal ArduPilot firmware image. It contains a board-specific build and should not be flashed to other flight-controller targets.

---

## Other Flight Controllers

Users with other flight controllers should **not** install the provided `.apj` file.

Instead, build ArduPlane firmware for the exact target board and apply:

```text
Patches/WP_LOITER_RAD_OSD.patch
```

Examples of other ArduPilot-supported hardware include:

- Cube series
- Matek boards
- Pixhawk family
- Other ArduPilot-supported flight controllers

The patch must be applied to a compatible ArduPilot source version. The included patch is associated with the ArduPlane 4.7.x firmware used by this project; patch application may require adjustment when building against a different ArduPilot source revision.

---

## Firmware Modification

The firmware modification changes:

```text
libraries/AP_OSD/AP_OSD.h
libraries/AP_OSD/AP_OSD_Screen.cpp
```

These changes add a configurable `WP_LOITER_RAD` OSD element and the drawing logic required to display the active loiter radius through supported DisplayPort OSD systems.

The modification:

- Reads the active `WP_LOITER_RAD` value
- Preserves the positive or negative sign
- Converts meters to feet when configured
- Supports meter display
- Adds OSD enable and position settings
- Displays the loiter radius through the ArduPilot DisplayPort OSD system

The Lua script does **not** directly access or control this OSD functionality.

---

## OSD Parameters

The firmware patch adds the following OSD parameters:

```text
LOITRAD_EN
LOITRAD_X
LOITRAD_Y
LOITRAD_UNITS
```

`LOITRAD_UNITS` is defined as:

```text
0 = Feet (default)
1 = Meters
```

This OSD unit setting is independent of the Lua parameter:

```text
LRAD_UNITS
```

`LRAD_UNITS` controls Lua GCS message units, while `LOITRAD_UNITS` controls the OSD display units.

---

## Compatibility Summary

| Component | Target | Custom Firmware Required |
| --- | --- | --- |
| `Lua/LRAD_v1.2.lua` | ArduPlane 4.7.x+ | No |
| Included `arduplane-WPLR-OSD.apj` | TBS LUCID H7 WING | Yes |
| `WP_LOITER_RAD` OSD patch | ArduPilot firmware build for target board | Yes |

Always verify the exact firmware target before flashing an `.apj` file.
