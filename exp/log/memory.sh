#!/bin/bash

output_file="rbtree.csv"

fslist="DIR FILE"
sizelist="64_1"
datathreads="0 2 4 8 16"
pipethreads="0 2 4 8 16"
for fs in $fslist; do
    for size in $sizelist; do
        for data in $datathreads; do
#        for pipe in $pipethreads; do
#      for file in *fsck_*_0_*log; do
#file=pfsck_${data}_${pipe}_FILE${size}.log
                    file=new_fsck_0_${data}_${fs}${size}.log

#                   echo "Pass 1,Pass 2,Pass 3,Pass 4,Pass 5,$file" >> "$output_file"

                    echo "$file"
                    grep "Memory used:" "$file" | sed -n 's/.*: Memory used: \([0-9]*\)k\/\([0-9]*\)k.*/\1+\2/p' | bc | sort -n | tail -n 1

# done
#        done
        done
    done
done

for fs in $fslist; do
    for size in $sizelist; do
        for data in $datathreads; do
#        for pipe in $pipethreads; do
#      for file in *fsck_*_0_*log; do
#file=pfsck_${data}_${pipe}_FILE${size}.log
                    file=pfsck_0_${data}_${fs}${size}.log

#                   echo "Pass 1,Pass 2,Pass 3,Pass 4,Pass 5,$file" >> "$output_file"

                    echo "$file"
                    grep "Memory used:" "$file" | sed -n 's/.*: Memory used: \([0-9]*\)k\/\([0-9]*\)k.*/\1+\2/p' | bc | sort -n | tail -n 1

# done
#        done
        done
    done
done
