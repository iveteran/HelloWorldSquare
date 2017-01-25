%module Bit #module name  
%{  
#include "Bit.h"
%}  
  
#需要导出到python的函数  
extern Bit* createBit(unsigned long len);  
extern int setBit(Bit *pb,unsigned long index, int value);  
extern int getBit(Bit *pb,unsigned long index);  
extern int bitLength(Bit *pb);  
extern void freeBit(Bit *pb);
