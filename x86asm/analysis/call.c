#include<stdio.h>

extern int add(int  ,int );

int main(int argc, char const *argv[])
{
    int i = 3;
    int j = 4;
    int k = add(i,j);
    printf("%d+%d=%d\n",i,j,k);



    printf("argc=%d,argv=%s\n",argc,argv);
    return 0;
}
