#!/bin/bash


touch outputData.txt

# echo "mha.overlapadd.mhachain.dc.gtdata = [..." > outputData.txt

# echo "" >> outputData.txt

octave testvasu.m


# sed -i -e 's/^/[/' outputData.txt

# sed -i -e 's/$/]; .../' outputData.txt

# pbcopy < outputData.txt


octave reader.m

# ./comprunner.sh &

qjackctl &

sleep 5

octave Vasu_Compression.m





