#!/usr/bin/bash

# generate input files for the scans
# they are translated in all 6 frames
rm  *.6.frames.translated
for f in Reads.txt ; do /home/bkulohoma/EMBOSS-6.6.0/emboss/transeq $f ${f}.6.frames.translated -frame=6 ;  done; 

#progress status!
echo -ne '#####                     (10%)\r'
sleep 1

#clean-up
rm *.initial.result.txt
#do the scans
for f in *.6.frames.translated;
do
        for cluster in *.hmm.cluster;
        do
                hmmscan --noali --cpu 7 $cluster $f > ${f%.6.frames.translated}.initial.result.txt &
        done;
done;

#progress status!
echo -ne '######################   (85%)\r'
sleep 1