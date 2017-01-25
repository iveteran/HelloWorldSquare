#!/usr/bin/pypy
import timeit 

lon1, lat1, lon2, lat2 = -72.345, 34.323, -61.823, 54.826
num = 500000

t1 = timeit.Timer("p1.great_circle(%f,%f,%f,%f)" % (lon1,lat1,lon2,lat2),"import p1")
print ("pypy function %f sec" % t1.timeit(num))
