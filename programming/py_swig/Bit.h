//Bit.h  
#ifndef BIT_H  
#define BIT_H  

//create: 2012-10-19  
//version: 1.0  
#define CHAR_LENGTH sizeof(unsigned char)   

//Bit模拟位操作  
typedef struct  
{  
    unsigned char *pArray;//指向一个字符型数组，用以存储bit位  
    unsigned long length;//记录pArray的长度, 字符个数  
    unsigned long used;//记录用户使用的bit位  
}Bit;  

//创建Bit对象  
//@len: 初始化bit位数  
//@return: 返回一个指向Bit对象的指针, 该指针需要使用freeBit销毁  
Bit* createBit(unsigned long len);  

//设置bit位  
//@pb:指向Bit的一个对象, 如果为NULL, 返回1  
//@index: 需要设置的bit位, 范围应当是 (0~used)  
//@value: bit位的值, (0,1)  
//@return: 成功返回0, 如果出现pb==NULL, index out of range, value!=0 and value!=1, 返回1  
int setBit(Bit *pb,unsigned long index, int value);  

//获取bit位  
//@pb:指向Bit的一个对象, 如果为NULL, 返回1  
//@index: 需要设置的bit位, 范围应当是 (0~used)  
//@return: 成功返回0, 如果出现pb==NULL, index out of range, 返回1  
int getBit(Bit *pb,unsigned long index);  

//返回使用的长度  
//@pb: 如果pb==NULL, return -1  
int bitLength(Bit *pb);  

//销毁Bit对象  
void freeBit(Bit *pb);  
#endif
