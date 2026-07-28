Building Custom ArduPlane Firmware

Overview

The included firmware file:

Firmware/arduplane-WPLR-OSD.apj

was built specifically for the TBS H7 Lucid Wing flight controller.

Users with other ArduPilot-supported flight controllers should build
their own firmware using the AP_OSD modification included in this
project.

------------------------------------------------------------------------

Requirements

A Linux build environment is recommended.

Required:

-   ArduPilot source code
-   Python build tools
-   Git
-   Waf build system

------------------------------------------------------------------------

Clone ArduPilot Source

Clone the ArduPilot repository:

git clone https://github.com/ArduPilot/ardupilot.git

Enter the source directory:

cd ardupilot

------------------------------------------------------------------------

Apply the OSD Modification

The modification affects:

libraries/AP_OSD/AP_OSD_Screen.cpp

The patch file included with this project:

Patches/AP_OSD_Screen.cpp.patch

shows the required changes.

The modification:

-   Reads WP_LOITER_RAD
-   Preserves the positive or negative sign
-   Converts meters to feet
-   Displays the loiter radius in DisplayPort OSD

------------------------------------------------------------------------

Select Your Flight Controller

Configure ArduPilot for your specific hardware.

Example:

./waf configure –board

Replace:

with your flight controller target.

Examples:

CubeOrange matekh743

Refer to the ArduPilot documentation for supported board names.

------------------------------------------------------------------------

Build ArduPlane

Build the firmware:

./waf plane

The resulting firmware file will be created for your selected hardware
target.

------------------------------------------------------------------------

Install Firmware

Install the generated .apj file using Mission Planner or another
supported ArduPilot firmware installation method.

------------------------------------------------------------------------

Notes

The Lua script:

Lua/LRAD.lua

is hardware independent and can be used on any supported ArduPlane
vehicle with Lua scripting enabled.

The included firmware file is only one example build for the TBS H7
Lucid Wing.
