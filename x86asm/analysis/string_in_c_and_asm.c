#define NULL 0
#include<stdio.h>
#include<time.h>

typedef unsigned int size_t;
extern void *amemcpy(void *dest, const void *src, size_t count);
void *memcpy(void *dest, const void *src, size_t count)
{
    char *dptr = dest;
    const char *sptr = src;
    for (size_t i = 0; i < count; i++)
    {
        dptr[i] = sptr[i];
    }
    return dest ;    
}

char message[] = "hello world!!!\n";
char message2[] = "HELLO world???\n";

char buffer[sizeof(message)];

int main(int argc, char const *argv[])
{
    int total = 1000000;
    int now1; 
    int now2;
    int num ;

    num = total;
    now1=time(NULL);
    printf("Now=%d\n",now1);
    while(num--)
    {
    memcpy(buffer,message,sizeof(message));
    }
    now2 = time(NULL);
    printf("Now=%d\n",now2);
    printf("memcpy spend %d\n\n",now2-now1);

    num = total;
    now1=time(NULL);
    printf("Now=%d\n",now1);
    while(num--)
    {
    amemcpy(buffer,message2,100);    
    }
    now2 = time(NULL);
    printf("Now=%d\n",now2);
    printf("amemcpy spend %d\n",now2-now1);

    return 0;
}
