#include<stdio.h>


int test1 = 100;
static int test2 = 200;

int main(int argc, char const *argv[])
{
    printf("test1=%zd\n",test1);/* code */
    printf("test2=%zd\n",test2);/* code */
    return 0;
}
