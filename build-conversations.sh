#!/bin/sh

# IETF118 Hackathon LLTCP

# script to split a cap file into conversations, then they can be merged
# with other conversations coming from other cap files (solves the rolling capture problem)
#
# Finally a sorted tshark conv,tcp will be performed to find the longest lasting conversations
#
# Requires : tshark

# v0 : incomplete/unfinished

outdir=/tmp

# extract isolated incomplete conversations
for conv in `run/tshark -r $1 -T fields -e tcp.stream | sort -n | uniq`
do
    IP=`run/tshark -r $1 -T fields -e ip.addr -Y "tcp.stream==$conv" | head -1 | xargs -n1 -d ',' | sort | xargs | tr -s ' ' '_'`
    out=stream-$1-$IP-$conv.pcapng
    echo "creating ${out} for iic conv $conv"
    run/tshark -r $1 -w "${outdir}"/"${out}" -Y "tcp.stream==$conv"
done

# identify IP endpoints related by common conversations
ls "${outdir}"/stream-$1* | cut -d '-' -f4 | uniq > endpoints

# 
time for endpoint in $(cat endpoints)
do
  echo  "processing $endpoint";
  ls "${outdir}"/*$endpoint*;
  run/mergecap -w "${outdir}"/merged-convs/$endpoint.pcapng "${outdir}"/stream-$1-$endpoint*
  echo;
done 

exit
