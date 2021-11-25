//Bit.c  
#include "Bit.h"  
#include <stdio.h>  
#include <stdlib.h>  
#include <limits.h>  

//创建Bit对象  
//@len: 初始化bit位数, len>=0  
//@return: 返回一个指向Bit对象的指针, 该指针需要使用freeBit销毁  
Bit* createBit(unsigned long len)  
{  
    if(len<0)  
        return NULL;  

    Bit *pb=(Bit*)malloc(sizeof(Bit));  
    if(len>0)  
    {  
        pb->length=(len-1)/CHAR_LENGTH+1;  
        pb->pArray=(char*)malloc(sizeof(char)*pb->length);  
        pb->used=len;  
    }else  
    {  
        pb->length=0;  
        pb->pArray=NULL;  
        pb->used=len;  
    }  
    return pb;  
}  

//设置bit位  
//@pb:指向Bit的一个对象, 如果为NULL, 返回1  
//@index: 需要设置的bit位, 范围应当是 [0~used)  
//@value: bit位的值, (0,1)  
//@return: 成功返回0, 如果出现pb==NULL, index out of range, value!=0 and value!=1, 返回1  
int setBit(Bit *pb,unsigned long index, int value)  
{  
    if(pb==NULL || pb->pArray==NULL || index<0 || index>=pb->used || (value!=0 && value!=1))  
        return 1;  

    unsigned long a=index/CHAR_LENGTH;  
    unsigned long b=index%CHAR_LENGTH;  
    if(value==0)  
    {  
        pb->pArray[a]&=(UCHAR_MAX^(1<<b));  
        //printf("%d\n",pb->pArray[a]);  
    }else  
    {  
        pb->pArray[a]|=(1<<b);  
        //printf("%d\n",pb->pArray[a]);  
    }  
    return 0;  
}  

//获取bit位  
//@pb:指向Bit的一个对象, 如果为NULL, 返回1  
//@index: 需要设置的bit位, 范围应当是 [0~used)  
//@return: 成功返回0, 如果出现pb==NULL, index out of range, 返回1  
int getBit(Bit *pb,unsigned long index)  
{  
    if(pb==NULL || pb->pArray==NULL || index<0 || index>=pb->used)  
        return 1;  
    unsigned long a=index/CHAR_LENGTH;  
    unsigned long b=index%CHAR_LENGTH;  
    //printf("%d\n",pb->pArray[a]&(1<<b));  
    if((pb->pArray[a]&(1<<b))==0)  
        return 0;  
    else  
        return 1;  
}  

//返回使用的长度  
//@pb: 如果pb==NULL, return -1  
int bitLength(Bit *pb)  
{  
    if(pb==NULL || pb->pArray==NULL)  
        return -1;  
    return pb->used;  
}  

//销毁Bit对象  
void freeBit(Bit *pb)  
{  
    if(pb==NULL)  
        return;  
    if(pb->pArray!=NULL)  
    {  
        free(pb->pArray);  
        pb->pArray=NULL;  
    }  
    free(pb);  
}  
