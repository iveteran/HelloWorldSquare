#include<iostream>
void Merge(int r[],int r1[],int s,int m,int t)
{
    int i=s;int j=m+1;int k=s;
    while(i<=m&&j<=t)
    {
        if(r[i]<=r[j])r1[k++]=r[i++];
        else r1[k++]=r[j++];
    }
    if(i<=m)
        while(i<=m) r1[k++]=r[i++];
    else while(j<=t)
        r1[k++]=r[j++];
    for(int l=0;l<8;l++)
        r[l]=r1[l];
}
void MergeSort(int r[],int r1[],int s,int t)
{
    if(s==t)r1[s]=r[s];
    else
    {
        int m=(s+t)/2;
        MergeSort(r,r1,s,m);
        MergeSort(r,r1,m+1,t);
        Merge(r1,r,s,m,t);
    }
}
int main()
{
    int r[8]={10,3,5,1,9,34,54,565},r1[8];
    std::cout << "before sort:\n";
    for(int q=0;q<8;q++)
        std::cout<<" "<<r[q];
    std::cout << std::endl;

    MergeSort(r,r1,0,7);
    std::cout << "after sort:\n";
    for(int q=0;q<8;q++)
        std::cout<<" "<<r[q];
    std::cout << std::endl;

    return 0;
} 
