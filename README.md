# NOMAD
NOMAD (Non-Malaria Acute febrile illness Detector) an algorithm capable of detecting multiple non-malaria acute febrile illness (NM-AFI) viral pathogens within an intra-host disease episode

To run the programme the following steps are required: 
1. Make sure that the lastest version of the HMMER software suite is installed
2. Provide the reads in FASTA format in an initial analysis file "Reads.txt"
3. In bash call the script "run_hmmer.sh" in the same folder with uniprot.hmms
4. Then call "run.analysis.sh"
5. This will gnerate a text results file with the final results, which can be further collated to other results


