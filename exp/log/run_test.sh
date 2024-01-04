#!/bin/bash

#RESULTPATH="/home/oslab/mnt/dongeon/FSCK/log/exp2"
#FSCKPATH="/home/oslab/mnt/dongeon/FSCK/e2fsprogs/build/e2fsck/e2fsck"
#pFSCKPATH="/home/oslab/mnt/dongeon/FSCK/pFSCK/e2fsprogs-v1.44.4/build/e2fsck/e2fsck"

RESULTPATH="/home/dongeon/Research/FSCK/log/additional_paper_exp"

FSCKPATH="/home/dongeon/Research/FSCK/e2fsprogs/build/e2fsck/e2fsck"
pFSCKPATH="/home/dongeon/Research/FSCK/pFSCK/e2fsprogs-v1.44.4/build/e2fsck/e2fsck"

FSCKSOURCE="/home/dongeon/Research/FSCK/e2fsprogs/e2fsck/pass1.c"
pFSCKSOURCE="/home/dongeon/Research/FSCK/pFSCK/e2fsprogs-v1.44.4/lib/ext2fs/icount.c"

FSCKBUILD="/home/dongeon/Research/FSCK/e2fsprogs/build"
pFSCKBUILD="/home/dongeon/Research/FSCK/pFSCK/e2fsprogs-v1.44.4/build"

FlushDisk()
{
        sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
        sudo sh -c "sync"
        sudo sh -c "sync"
        sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
      #  numactl --hardware
}

FlushDisk

imagelist="FILE32 FILE64 FILE256 DIR32 DIR64 DIR256 FILE64_1 DIR64_1"
#imagelist="FILE32 FILE64 FILE256"

DIR32="/dev/loop21"
FILE32="/dev/loop22"
DIR64="/dev/loop23"
FILE64="/dev/loop24"
DIR256="/dev/loop25"
FILE256="/dev/loop26"
DIR64_1="/dev/loop27"
FILE64_1="/dev/loop28"

RUN_OPT="-fFnttv"
FSCK_DATA="-m"
FSCK_PIPE="-w"


#run cFSCK

#use FULLMAP
for var in $imagelist; do
    IMGNAME=$(eval echo \$$var)

#for iter in {1..10}; do
#    for iter in {1..5}; do
#
#        echo "fsck for $var starts with thread 0 / $iter" 
#        sudo $FSCKPATH $RUN_OPT $IMGNAME | tee -a  $RESULTPATH/sfsck_0_0_$var.log
#        FlushDisk
#
#    done

#for data in 1 2 4 8 16; do
#    for data in 1 ; do
##for iter in {1..10}; do
#        for iter in {1..5}; do
#
#            echo "new fsck for $var starts with pipe thread $data / $iter" 
#            sudo $FSCKPATH $RUN_OPT $FSCK_DATA $data $IMGNAME | tee -a  $RESULTPATH/sfsck_${data}_0_$var.log
#            FlushDisk
#
#        done
#    done
#
##for pipe in 1 2 4 8 16; do
#    for pipe in 1 ; do
##for iter in {1..10}; do
#        for iter in {1..5}; do
#
#            echo "new fsck for $var starts with pipe thread $pipe / $iter" 
#            sudo $FSCKPATH $RUN_OPT $FSCK_PIPE $pipe $IMGNAME | tee -a  $RESULTPATH/sfsck_0_${pipe}_$var.log
#            FlushDisk
#
#        done
#    done

# for data in 1 2 4 8 16; do
#        for pipe in 1 2 4 8 16; do
    for data in 1 ; do
        for pipe in 1 ; do
#for iter in {1..10}; do
            for iter in {1..5}; do

                echo "new fsck for $var starts with data thread $data , pipe thread $pipe / $iter" 
                sudo $FSCKPATH $RUN_OPT $FSCK_DATA $data $FSCK_PIPE $pipe $IMGNAME | tee -a  $RESULTPATH/sfsck_${data}_${pipe}_$var.log
                FlushDisk

            done
        done
    done
done

#run pFSCK

pFSCK_RUN_OPT="-fFnttvx"
pFSCK_DATA="-g 1 -q"
pFSCK_PIPE="-w"

echo $pFSCK_RUN_OPT
echo $pFSCK_DATA
echo $pFSCK_PIPE

#use FULLMAP
for var in $imagelist; do
    IMGNAME=$(eval echo \$$var)

#    for iter in {1..10}; do
#
#        echo "pfsck for $var starts with thread 0 / $iter" 
#        echo "sudo $pFSCKPATH $pFSCK_RUN_OPT $IMGNAME"
#        sudo $pFSCKPATH $pFSCK_RUN_OPT $IMGNAME | tee -a  $RESULTPATH/pfsck_0_0_$var.log
#        FlushDisk
#
#    done
# for data in 2 4 8 16; do
#    for data in 1; do
#        for iter in {1..10}; do
#
#            echo "pfsck for $var starts with data thread $pipe / $iter" 
#            sudo $pFSCKPATH $pFSCK_RUN_OPT $pFSCK_DATA $data $IMGNAME | tee -a  $RESULTPATH/pfsck_${data}_0_$var.log
#            FlushDisk
#
#        done
#    done
#
##for pipe in 2 4 8 16; do
#    for pipe in 1; do
#        for iter in {1..10}; do
#
#            echo "pfsck for $var starts with pipe thread $pipe / $iter" 
#            sudo $pFSCKPATH $pFSCK_RUN_OPT $pFSCK_DATA 1 $pFSCK_PIPE $pipe $IMGNAME | tee -a  $RESULTPATH/pfsck_0_${pipe}_$var.log
#            FlushDisk
#
#        done
#    done

    for data in 1; do
        for pipe in 1; do
            for iter in {1..10}; do

                echo "pfsck for $var starts with data $data, pipe thread $pipe / $iter" 
                sudo $pFSCKPATH $pFSCK_RUN_OPT $pFSCK_DATA $data $pFSCK_PIPE $pipe $IMGNAME | tee -a  $RESULTPATH/pfsck_${data}_${pipe}_$var.log
                FlushDisk

            done
        done
    done

done

