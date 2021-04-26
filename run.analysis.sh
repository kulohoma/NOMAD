#!/usr/bin/bash 
# clean-up
for f in *.initial.result.txt ; do cat $f | sed  's/#    score/*    score/g' | grep -v "#" |  grep -v "Internal pipeline statistics summary:" | grep -v "Query sequence(s): " | grep -v "Target model(s):" | grep -v "Passed" | grep -v "Initial search space (Z):" | grep -v "Domain search space  (domZ):"  | grep -v "Scores for complete" | grep -v "Domain annotation for each model:" | grep -v ">>" | grep -v " *    score " | grep -v "\!" | grep -v " --- "  | grep -v "\[ok\]" | grep -v "\?" | sed  '/^$/d'  | grep -v "\-\-" |  sed 's/  Description//g' > ${f%.initial.result.txt}.clean.result.1.txt ; done 

#progress status!
echo -ne '#####################   	 (90%)\r'
sleep 1

# clean-up some more
for f in *.clean.result.1.txt; do cat $f | tr '\n'  '#\n' | tr -s ' ' | tr '//' '\n' | sed '/^$/d' | grep -v "\[No targets detected that satisfy reporting thresholds\]" | sed 's/\[L=/[aa.length=/g' | sed 's/\# E-value/#E-value/g' | sed 's/#Description:/ Description:/g' | sed 's/ \# /#/g' | sed 's/#Query/Query/g' | tr '\#' '\n' | awk '{if($1=="Query:" || $1 == "E-value" || $1<=0.001) print }' |  grep  -B 2 -A 1 "E-value" | grep -B 2 "tr|" > ${f%.clean.result.1.txt}.clean.result.2.txt ; done

#progress status!
echo -ne '########################	 (95%)\r'
sleep 1

## merge 
for f in *clean.result.2.txt ; do cat $f | grep -v "E-value" | awk '{if($1=="Query:") print ; else print $9 }' | tr '\n' '#' | sed 's/\#\#/%/g' | sed 's/#/ /g' | tr '\%' '\n' | sed 's/|/ /g' | sort -k 5 > ${f%clean.result.2.txt}merge_file.1 ; done 

# merge and re-organize (remover duplicates from the 6 frame sequences)
for f in *.merge_file.1 ; do rm ${f%.merge_file.1}.viruses.present.and.distribution.txt ; join -1 5 -2 1 $f 14.trembl.virus.annotation.metadata | sed 's/: /:/g' | sed 's/\_[0-9] \[aa./ [aa./g'  | sort -k 2 | awk '!seen[$2]++' | sed 's/ Query:/$ Query:/g' | sed 's/ \[aa./$ [aa./g' |  sed 's/ tr /$ /g' | sed 's/ @OS /$ @OS$ /g' | sed 's/ @OC /$ @OC$ /g' | awk -F '$' '{print $2,"$",$6,"$"$8}' |  sort -t $ -k 2 | sed 's/ \$/;/g' > ${f%.merge_file.1}.viruses.present.and.distribution.txt ; printf "\n" >> ${f%.merge_file.1}.viruses.present.and.distribution.txt; echo "Distribution of virus sequences present:" >> ${f%.merge_file.1}.viruses.present.and.distribution.txt; printf "\n" >> ${f%.merge_file.1}.viruses.present.and.distribution.txt; cat ${f%.merge_file.1}.viruses.present.and.distribution.txt | cut -d ";" -f 1 --complement | uniq -f 1 -c | grep -v "1 Distribution of virus sequences present:" | awk '{if($3!="") print}' >> ${f%.merge_file.1}.viruses.present.and.distribution.txt; printf "\nEND\n" >> ${f%.merge_file.1}.viruses.present.and.distribution.txt; done 

#clean-up
rm *merge_file.1 *clean.result.1.txt *clean.result.2.txt 2>/dev/null 
#*.initial.result.txt

#progress status!
echo -ne '########################## (100%)\r'
echo -ne '\n'