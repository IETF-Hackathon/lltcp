#!/bin/sh

find "$@" -type f | sort -R | while read file; do
    echo "$file"
    if echo "$file" | grep -q '.pcap.gz$'; then
        gunzip -c "$file" | \
            tcpdump -nvr - net 2600:3000:1511:200:d201:27f::/96 and tcp port 53 2>/dev/null
    fi
    if echo "$file" | grep -q '.pcap.xz$'; then
        unxz -c "$file" | \
            tcpdump -nvr - net 2600:3000:1511:200:d201:27f::/96 and tcp port 53 2>/dev/null
    fi
done


