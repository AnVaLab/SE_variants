#!/bin/bash

# transferring files from server to the local pc to visualise it in IGV
scp -i '/home/an/Downloads/avasileva' avasileva@51.250.11.65:~/project/enhancers/ENCFF900YFA_classified.bed ~/Documents/Work/SE;
scp -i '/home/an/Downloads/avasileva' avasileva@51.250.11.65:~/project/enhancers/ENCFF900YFA.bed ~/Documents/Work/SE;
scp -i '/home/an/Downloads/avasileva' avasileva@51.250.11.65:~/project/se/SE_only_cd14plus_monocyte_norownumb_SEA00101.bed ~/Documents/Work/SE;
scp -i '/home/an/Downloads/avasileva' avasileva@51.250.11.65:~/project/se/E_only_cd14plus_monocyte_norownumb_SEA00101.bed ~/Documents/Work/SE;
scp -i '/home/an/Downloads/avasileva' avasileva@51.250.11.65:~/project/enhancers/E_SEA_ENCODE_intersect.bed ~/Documents/Work/SE
