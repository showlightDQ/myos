#include<stdio.h>

int main(int argc, char const *argv[])
{
    char ar[] = "abcdefghijklmn";
    char *p1 = ar;
    char *p2 = &ar;
    char *p3 = &ar[3];
    printf("p1=%p\np2=%p\np3=%p\n",p1,p2,p3);
    printf("p1=%p\np2=%p\np3=%p\n",*p1,*p2,*p3);
    return 0;
}
