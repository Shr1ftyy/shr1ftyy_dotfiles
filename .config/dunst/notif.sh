#!/bin/sh
if [ "$DUNST_STACK_TAG" != "volume" ] && [ "$DUNST_STACK_TAG" != "brightness" ]; then
    play /usr/share/sounds/Yaru/stereo/message.oga > /dev/null 2>&1 &
fi
