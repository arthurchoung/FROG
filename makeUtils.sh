#!/bin/bash

set -x

gcc -o frog-alsa-generatePanel frog-alsa-generatePanel.c -lasound
gcc -o frog-alsa-printFirstElement frog-alsa-printFirstElement.c -lasound
gcc -o frog-alsa-printUpdates frog-alsa-printUpdates.c -lasound
gcc -o frog-alsa-printStatus frog-alsa-printStatus.c -lasound
gcc -o frog-alsa-setMute: frog-alsa-setMute:.c -lasound
gcc -o frog-alsa-setVolume frog-alsa-setVolume.c -lasound
gcc -o frog-alsa-setValues frog-alsa-setValues.c -lasound
gcc -o frog-packRectanglesIntoWidth:height:... frog-packRectanglesIntoWidth:height:....c
gcc -o frog-x11-monitor-monitorEvents frog-x11-monitor-monitorEvents.c

