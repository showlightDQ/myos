#define NULL 0
typedef unsigned int size_t;

void *memcpy(void *dest, const void *src, size_t count)
{
    char *dptr = dest;
    const char *sptr = src;
    for (size_t i = 0; i < count; `)
    {
        dptr[i] = sptr[i];
    }
    return dest ;    
}

char message[] = "hello world!!!\n";
char buffer[sizeof(message)];

int main(int argc, char const *argv[])
{
    memcpy(buffer,message,sizeof(message));
    return 0;
}
