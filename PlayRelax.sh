#!/bin/bash 
#!/bin/bash
# Play all mp3 in ~/Relax

DIR="$HOME/Relax"
nohup cvlc --quiet --play-and-exit "$DIR"/*.mp3 &>/dev/null & echo $! > /tmp/relax.pid

