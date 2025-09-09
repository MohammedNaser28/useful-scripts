#!/bin/bash

#!/bin/bash
# Stop music

if [ -f /tmp/relax.pid ]; then
  kill $(cat /tmp/relax.pid) 2>/dev/null
  rm -f /tmp/relax.pid
else
  pkill vlc 2>/dev/null
fi

