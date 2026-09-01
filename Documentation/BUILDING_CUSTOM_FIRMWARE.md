# Building Custom ArduPlane Firmware

## Overview

The Lua controller in this project does not require custom firmware. Custom firmware is only needed for the optional AP_OSD loiter-radius display.

The included firmware:

```text
Firmware/arduplane-WPLR-OSD.apj
```

was built for the TBS LUCID H7 WING flight controller.

If you use a different ArduPilot-supported flight controller, create your own `.apj` file for that exact hardware target using the patch included in this project.

The current Lua controller is version **1.2** and targets **ArduPlane 4.7.x+**.

---

# Requirements

You will need:

- Ubuntu Linux or WSL2
- Git
- ArduPilot source code
- ArduPilot build tools
- A supported ArduPilot flight-controller target

The included OSD patch was developed against the ArduPlane 4.7.x code used by this project. When using a different ArduPilot revision, the patch may require manual adjustment if the affected OSD source files have changed.

---

# 1. Download ArduPilot Source

Clone ArduPilot:

```bash
git clone https://github.com/ArduPilot/ardupilot.git
```

Enter the folder:

```bash
cd ardupilot
```

Install build requirements:

```bash
Tools/environment_install/install-prereqs-ubuntu.sh -y
```

Reload the environment:

```bash
. ~/.profile
```

For reproducible builds, check out the ArduPilot source revision appropriate for the firmware version you intend to build before applying the patch.

---

# 2. Apply the WP_LOITER_RAD OSD Patch

Copy the patch from this project:

```text
Patches/WP_LOITER_RAD_OSD.patch
```

Apply it from the ArduPilot source directory:

```bash
git apply /path/to/WP_LOITER_RAD_OSD.patch
```

Verify the patch applies cleanly and review the resulting changes before building.

The patch modifies the ArduPilot OSD to:

- Add a configurable loiter-radius OSD element
- Display the active `WP_LOITER_RAD` value
- Preserve positive and negative direction
- Display feet or meters
- Add OSD enable and screen-position settings

The OSD implementation is independent of `Lua/LRAD_v1.2.lua`. The Lua script does not directly access the OSD.

---

# 3. Select Your Flight Controller

Configure ArduPilot for the exact hardware target you are using:

```bash
./waf configure --board <board>
```

Replace `<board>` with the appropriate ArduPilot board target.

For example, the exact board target for your hardware can be identified from the ArduPilot board documentation or build configuration.

**Do not substitute another board target simply because the hardware appears similar.** The resulting `.apj` is target-specific.

---

# 4. Build ArduPlane

Build the firmware:

```bash
./waf plane
```

The firmware will be created under:

```text
build/<board>/bin/
```

The output will normally include:

```text
arduplane.apj
```

The exact path depends on the selected board target.

---

# 5. Install Firmware

Install the generated `.apj` file using Mission Planner or another supported ArduPilot firmware tool.

Before flashing:

1. Confirm the `.apj` was built for the exact flight-controller hardware.
2. Confirm the build contains the intended OSD modification.
3. Make sure you have a recovery/reflash path available.

After flashing, verify normal aircraft operation before configuring the optional OSD element.

---

# Lua Script

The Lua script:

```text
Lua/LRAD_v1.2.lua
```

is hardware independent and targets ArduPlane 4.7.x+.

Copy it to:

```text
/APM/scripts/
```

on the aircraft SD card.

Enable scripting and configure RC Option 300 as described in:

```text
Documentation/INSTALLATION.md
```

The Lua script can be used with standard ArduPlane firmware; the custom OSD build is not required for radius control.

---

# OSD Configuration

After installing firmware containing the patch, configure the OSD loiter-radius element using:

```text
LOITRAD_EN
LOITRAD_X
LOITRAD_Y
LOITRAD_UNITS
```

`LOITRAD_UNITS` values:

```text
0 = Feet (default)
1 = Meters
```

The OSD reads the active `WP_LOITER_RAD` parameter directly, so it can display changes regardless of whether the value was changed by the Lua controller or externally.

---

# Notes

The included `.apj` file is only an example build for the TBS LUCID H7 WING.

The Lua script and OSD modification are separate components:

- Use `Lua/LRAD_v1.2.lua` alone when dynamic radius control is required.
- Apply `Patches/WP_LOITER_RAD_OSD.patch` and build custom firmware when the OSD display is required.

When building against a different ArduPilot revision, inspect and test the patch carefully. Source-level changes in the AP_OSD implementation may prevent the patch from applying cleanly or may require equivalent manual changes.

Always bench-test the resulting firmware and Lua configuration before operational flight.
