#!/bin/sh

find "$1" -type f -name '*.pcap.gz' | sort | while read file; do
    echo $file
    gunzip -c $file | \
        tcpdump -nvr - ip and tcp port 53 2>/dev/null | \
        perl tcp2.pl

done

