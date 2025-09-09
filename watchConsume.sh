#!/bin/bash

# Usage: ./record_hw.sh <interval_sec> <duration_sec> <outfile.csv>
# Example: ./record_hw.sh 2 60 hw_log.csv

interval=$1
duration=$2
outfile=$3
end=$((SECONDS + duration))

echo "timestamp,cpu_usage(%),cpu_temp(C),gpu_usage(%),gpu_mem(MB),gpu_temp(C),ram_used(MB)" > "$outfile"

while [ $SECONDS -lt $end ]; do
    ts=$(date +"%Y-%m-%d %H:%M:%S")

    # CPU usage %
    cpu_usage=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}')

    # CPU temp (first sensor)
    cpu_temp=$(sensors | grep -E "Tctl" | awk '{print $2}' | tr -d '+C' )

    # RAM used (MB)
    ram_used=$(free -m | awk '/Mem:/ {print $3}')

    # GPU usage + memory + temp (NVIDIA)
    if command -v nvidia-smi &>/dev/null; then
        gpu_line=$(nvidia-smi --query-gpu=utilization.gpu,utilization.memory,memory.used,temperature.gpu --format=csv,noheader,nounits | head -n1)
        gpu_util=$(echo $gpu_line | awk -F',' '{print $1}')
        gpu_mem=$(echo $gpu_line | awk -F',' '{print $3}')
        gpu_temp=$(echo $gpu_line | awk -F',' '{print $4}')
    else
        gpu_util=NA
        gpu_mem=NA
        gpu_temp=NA
    fi

    echo "$ts,$cpu_usage,$cpu_temp,$gpu_util,$gpu_mem,$gpu_temp,$ram_used" >> "$outfile"

    sleep "$interval"
done

