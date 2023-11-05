#!/bin/sh

find "$@" -type f -name '*.pcap.gz' | sort | while read file; do
    echo $file
    gunzip -c "$file" | \
        tcpdump -nvr - tcp port 53 2>/dev/null | \
        perl tcp2.pl

#    tshark -r "$file" -z 'conv,tcp' -Y 'tcp.port==53' -q | \
#        grep '^[0-9]' | perl tcp3.pl
    

done

find "$@" -type f -name '*.pcap.xz' | sort | while read file; do
    echo $file
    unxz -c "$file" | \
        tcpdump -nvr - tcp port 53 2>/dev/null | \
        perl tcp2.pl

#    tshark -r "$file" -z 'conv,tcp' -Y 'tcp.port==53' -q | \
#        grep '^[0-9]' | perl tcp3.pl
    

done

