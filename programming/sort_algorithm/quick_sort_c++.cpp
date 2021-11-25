#include<iostream>
#include<stdlib.h>
using namespace std;

void QuickSort(int *pData,int left,int right)
{
    int i(left),j(right),middle(0),iTemp(0);
    middle=pData[(left+right)/2];
    middle=pData[(rand()%(right-left+1))+left]; 
    do{
        while((pData[i]<middle)&&(i<right))
            i++;
        while((pData[j]>middle) && (j>left))
            j--;
        if(i<=j){
            iTemp=pData[j];
            pData[j]=pData[i];
            pData[i]=iTemp;
            i++;
            j--;
        }
    }while(i<=j);
    if(left<j){
        QuickSort(pData,left,j);
    }
    if(right>i){
        QuickSort(pData,i,right);
    }
}
int main()
{
    int data[]={10,7,8,9,6,5,4};
    const int count(6);

    cout << "before sort:\n";
    for(int i(0);i!=7;++i){
        cout<<data[i]<<" "<<flush;
    }
    cout<<endl;

    QuickSort(data,0,count);

    cout << "after sort:\n";
    for(int i(0);i!=7;++i){
        cout<<data[i]<<" "<<flush;
    }
    cout<<endl;

    return 0;
}
