Building Custom ArduPlane Firmware

Overview

The included firmware:

Firmware/arduplane-WPLR-OSD.apj

was built for the TBS H7 Lucid Wing flight controller.

If you use a different ArduPilot-supported flight controller, you can
create your own .apj file using the patch included in this project.

------------------------------------------------------------------------

Requirements

You will need:

-   Ubuntu Linux (or WSL2)
-   Git
-   ArduPilot source code
-   ArduPilot build tools

------------------------------------------------------------------------

1. Download ArduPilot Source

Clone ArduPilot:

git clone https://github.com/ArduPilot/ardupilot.git

Enter the folder:

cd ardupilot

Install build requirements:

Tools/environment_install/install-prereqs-ubuntu.sh -y

Reload environment:

. ~/.profile

------------------------------------------------------------------------

2. Apply the WP_LOITER_RAD OSD Patch

Copy the patch from this project:

Patches/WP_LOITER_RAD_OSD.patch

Apply it:

git apply /path/to/WP_LOITER_RAD_OSD.patch

The patch modifies the ArduPilot OSD to:

-   Display WP_LOITER_RAD
-   Preserve positive and negative direction
-   Convert meters to feet

------------------------------------------------------------------------

3. Select Your Flight Controller

Configure ArduPilot for your hardware:

./waf configure –board

Replace:

with your flight controller target.

Examples:

CubeOrange

matekh743

------------------------------------------------------------------------

4. Build ArduPlane

Build the firmware:

./waf plane

Your new firmware will be created in:

build//bin/

The output file will be:

arduplane.apj

------------------------------------------------------------------------

5. Install Firmware

Install the generated .apj file using Mission Planner or another
supported ArduPilot firmware tool.

------------------------------------------------------------------------

Lua Script

The Lua script:

Lua/LRAD.lua

is hardware independent.

Copy it to:

/APM/scripts/

Enable scripting and configure your RC knob as described in:

Documentation/INSTALLATION.md

------------------------------------------------------------------------

Notes

The included .apj file is only an example build.

The Lua script can be used on any supported ArduPlane vehicle with Lua
scripting enabled.
