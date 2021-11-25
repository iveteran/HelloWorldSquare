#!/usr/bin/python2
#coding=utf-8  
#create-2012-10-17  
#version: 1.0  
#计算小于1亿的素数个数  
  
import time  
from Bit  import *  
  
MAX=100000000  
count=1  
  
#0 表示素数  
#1 表示已经去除  
  
start_time=time.time()  
  
len=MAX/2-1  
b=createBit(len)  
  
def remove(idx):  
    i=idx  
    global b  
    while i<len:  
        #b[i]=1  
        setBit(b,i,1)  
        i+=2*idx+3  
  
for i in range(3,MAX,2):  
    if getBit(b,(i-3)/2)==0:  
        #素数  
        count+=1  
        remove((i-3)/2)  
  
end_time=time.time()  
print "result:", count  
print "cost:", end_time-start_time
