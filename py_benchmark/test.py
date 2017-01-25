import timeit 

lon1, lat1, lon2, lat2 = -72.345, 34.323, -61.823, 54.826
num = 500000

t1 = timeit.Timer("p1.great_circle(%f,%f,%f,%f)" % (lon1,lat1,lon2,lat2),"import p1")
print ("Pure python function %f sec" % t1.timeit(num))

t2 = timeit.Timer("c1.great_circle(%f,%f,%f,%f)" % (lon1,lat1,lon2,lat2), "import c1")
print ("Cython function (still using python math) %f sec" % t2.timeit(num))

t3 = timeit.Timer("c2.great_circle(%f,%f,%f,%f)" % (lon1,lat1,lon2,lat2), "import c2")
print ("Cython function (using trig function from math.h) %f sec" % t3.timeit(num))

t4 = timeit.Timer("c3.great_circle(%f,%f,%f,%f)" % (lon1,lat1,lon2,lat2), "import c3")
print ("Cython function (using trig function from math.h #2) %f sec" % t4.timeit(num))
