#!/bin/sh
# Ref: https://github.com/red-data-tools/YouPlot

# echo -e "from numpy import random; n = random.randn(10000); print('\\\n'.join(str(i) for i in n))" | python3 | uplot hist --nbins 20
echo "from numpy import random; n = random.randn(10000); print('\\\n'.join(str(i) for i in n))" | python3 | uplot hist --nbins 20

cat uplot_demo_data/ISLANDScsv.txt | sort -nk2 -t, | tail -n15 | uplot bar -d, -t "Areas of the World's Majar Landmasses"

cat uplot_demo_data/AirPassengers.txt | cut -f2,3 -d, | uplot line -d, -w 50 -h 15 -t AirPassengers --xlim 1950,1960 --ylim 0,600

cat uplot_demo_data/IRIStsv.txt | cut -f1-4 | uplot scatter -H -t IRIS

cat uplot_demo_data/IRIStsv.txt | cut -f1-4 | uplot density -H -t IRIS

cat uplot_demo_data/IRIStsv.txt | cut -f1-4 | uplot boxplot -H -t IRIS
