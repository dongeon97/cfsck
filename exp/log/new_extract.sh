#!/bin/bash

output_file="rbtree.csv"

DIR="./"
FILE="../paper2_exp/"

fslist="DIR FILE"
sizelist="32 64 256 64_1 64_10"
datathreads="0 1 2 4 8 16"

echo "Pass 1,Pass 2,Pass 3,Pass 4,Pass 5" >> "$output_file"

for fs in $fslist; do
    for size in $sizelist; do

        for data in $datathreads; do
            file=oFSCK_${data}_0_${fs}${size}.log

            echo ",,,,, $file" >> "$output_file"

            grep -snrI "time taken by [02345]\|Total" "$file" | awk '{print $NF}' | paste -d, - - - - - - | awk -F',' '{ for(i=1;i<=NF;i++) sum[i]+=$i } END { for(i=1;i<=NF;i++) printf "%.3f%s", sum[i]/NR, (i==NF)?"\n":"," }'>> "$output_file"
#                grep -snrI "time taken by [02345]" "$file" | awk '{print $NF}' | paste -d, - - - - - | awk -F',' '{ for(i=1;i<=NF;i++) sum[i]+=$i } END { for(i=1;i<=NF;i++) printf "%.3f%    s", sum[i]/NR, (i==NF)?"\n":"," }'>> "$output_file"
            echo >> "$output_file"
        done

        for pipe in $datathreads; do
                file=oFSCK_0_${pipe}_${fs}${size}.log

                echo ",,,,, $file" >> "$output_file"

                grep -snrI "time taken by [02345]\|Total" "$file" | awk '{print $NF}' | paste -d, - - - - - - | awk -F',' '{ for(i=1;i<=NF;i++) sum[i]+=$i } END { for(i=1;i<=NF;i++) printf "%.3f%s", sum[i]/NR, (i==NF)?"\n":"," }'>> "$output_file"
#                grep -snrI "time taken by [02345]" "$file" | awk '{print $NF}' | paste -d, - - - - - | awk -F',' '{ for(i=1;i<=NF;i++) sum[i]+=$i } END { for(i=1;i<=NF;i++) printf "%.3f%    s", sum[i]/NR, (i==NF)?"\n":"," }'>> "$output_file"
                echo >> "$output_file"
        done

        for data in $datathreads; do
            file=oFSCK_${data}_${data}_${fs}${size}.log

            echo ",,,,, $file" >> "$output_file"

            grep -snrI "time taken by [02345]\|Total" "$file" | awk '{print $NF}' | paste -d, - - - - - - | awk -F',' '{ for(i=1;i<=NF;i++) sum[i]+=$i } END { for(i=1;i<=NF;i++) printf "%.3f%s", sum[i]/NR, (i==NF)?"\n":"," }'>> "$output_file"
#                grep -snrI "time taken by [02345]" "$file" | awk '{print $NF}' | paste -d, - - - - - | awk -F',' '{ for(i=1;i<=NF;i++) sum[i]+=$i } END { for(i=1;i<=NF;i++) printf "%.3f%    s", sum[i]/NR, (i==NF)?"\n":"," }'>> "$output_file"
            echo >> "$output_file"
        done
    done
done

#fs="FILE"
#    for size in $sizelist; do
#        for data in $datathreads; do
#                file=${FILE}new_fsck_${data}_${data}_${fs}${size}.log
#
#                echo "Pass 1,Pass 2,Pass 3,Pass 4,Pass 5, $file" >> "$output_file"
#
#                grep -snrI "time taken by [02345]" "$file" | awk '{print $NF}' | paste -d, - - - - - | awk -F',' '{ for(i=1;i<=NF;i++) sum[i]+=$i } END { for(i=1;i<=NF;i++) printf "%.3f%    s", sum[i]/NR, (i==NF)?"\n":"," }'>> "$output_file"
##grep -snrI "time taken by [02345]\|Total" "$file" | awk '{print $NF}' | paste -d, - - - - - - | awk -F',' '{ for(i=1;i<=NF;i++) sum[i]+=$i } END { for(i=1;i<=NF;i++) printf "%.3f%s", sum[i]/NR, (i==NF)?"\n":"," }'>> "$output_file"
#
#
#                echo >> "$output_file"
#        done
#    done
#done

for fs in $fslist; do
    for size in $sizelist; do
            for data in $datathreads; do
                    file=pfsck_${data}_0_${fs}${size}.log

                    echo ",,,,, $file" >> "$output_file"
# echo "Pass 1,Pass 2,Pass 3,Pass 4,Pass 5, Total, $file" >> "$output_file"

#         grep -snrI "Pass [12345] time" "$file" | awk '{print $4}' | paste -d, - - - - -   | awk -F',' '{ for(i=1;i<=NF;i++) sum[i]+=$i } END     { for(i=1;i<=NF;i++) printf "%.3f%s", sum[i]/NR, (i==NF)?"\n":"," }'>> "$output_file"
                    grep -snrI "Pass [12345] time\|Total" "$file" | awk '/Total Time/ {print $3} !/Total Time/ {print $4}' | paste -d, - - - - - -  | awk -F',' '{ for(i=1;i<=NF;i++) sum[i]+=$i } END { for(i=1;i<=NF;i++) printf "%.3f%s", sum[i]/NR, (i==NF)?"\n":"," }'>> "$output_file"

                    echo >> "$output_file"
            done
        for pipe in $datathreads; do
                    file=pfsck_0_${pipe}_${fs}${size}.log

                    echo ",,,,, $file" >> "$output_file"
# echo "Pass 1,Pass 2,Pass 3,Pass 4,Pass 5, Total, $file" >> "$output_file"

#         grep -snrI "Pass [12345] time" "$file" | awk '{print $4}' | paste -d, - - - - -   | awk -F',' '{ for(i=1;i<=NF;i++) sum[i]+=$i } END     { for(i=1;i<=NF;i++) printf "%.3f%s", sum[i]/NR, (i==NF)?"\n":"," }'>> "$output_file"
                    grep -snrI "Pass [12345] time\|Total" "$file" | awk '/Total Time/ {print $3} !/Total Time/ {print $4}' | paste -d, - - - - - -  | awk -F',' '{ for(i=1;i<=NF;i++) sum[i]+=$i } END { for(i=1;i<=NF;i++) printf "%.3f%s", sum[i]/NR, (i==NF)?"\n":"," }'>> "$output_file"

                    echo >> "$output_file"
        done
            for data in $datathreads; do
                    file=pfsck_${data}_${data}_${fs}${size}.log

                    echo ",,,,, $file" >> "$output_file"
# echo "Pass 1,Pass 2,Pass 3,Pass 4,Pass 5, Total, $file" >> "$output_file"

#         grep -snrI "Pass [12345] time" "$file" | awk '{print $4}' | paste -d, - - - - -   | awk -F',' '{ for(i=1;i<=NF;i++) sum[i]+=$i } END     { for(i=1;i<=NF;i++) printf "%.3f%s", sum[i]/NR, (i==NF)?"\n":"," }'>> "$output_file"
                    grep -snrI "Pass [12345] time\|Total" "$file" | awk '/Total Time/ {print $3} !/Total Time/ {print $4}' | paste -d, - - - - - -  | awk -F',' '{ for(i=1;i<=NF;i++) sum[i]+=$i } END { for(i=1;i<=NF;i++) printf "%.3f%s", sum[i]/NR, (i==NF)?"\n":"," }'>> "$output_file"

                    echo >> "$output_file"
            done
    done
done
