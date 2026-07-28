Firmware Compatibility

Included Firmware

The firmware file:

Firmware/arduplane-WPLR-OSD.apj

is a custom ArduPlane 4.7.x build created for:

-   TBS H7 Lucid Wing flight controller

This firmware should only be installed on compatible hardware.

------------------------------------------------------------------------

Other Flight Controllers

Users with other flight controllers should not install the provided
.apj.

The .apj file is compiled for a specific hardware target and contains
board-specific configuration.

Users with other supported ArduPilot flight controllers should rebuild
ArduPlane firmware using the included source modification.

Examples of other supported hardware:

-   Cube series
-   Matek boards
-   Pixhawk family
-   Other ArduPilot supported flight controllers

------------------------------------------------------------------------

Portable Components

The following components are hardware independent.

LRAD.lua

The Lua script:

-   Controls WP_LOITER_RAD
-   Uses RC Option 300
-   Creates WPLR parameters
-   Supports positive and negative loiter radius values
-   Preserves ArduPilot loiter direction behavior

The Lua script can be used on any supported ArduPlane vehicle with Lua
scripting enabled.

------------------------------------------------------------------------

Firmware Modification

The firmware modification changes:

libraries/AP_OSD/AP_OSD.h

libraries/AP_OSD/AP_OSD_Screen.cpp

These changes add a configurable WP_LOITER_RAD OSD element and the drawing logic required to display the active loiter radius through supported DisplayPort OSD systems.

The modification:

-   Reads the active WP_LOITER_RAD value
-   Preserves the positive or negative sign
-   Converts meters to feet
-   Displays loiter radius through DisplayPort OSD

Users can apply this modification when building firmware for their own
flight controller.
