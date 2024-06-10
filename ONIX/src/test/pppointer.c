int test(char **p)
{
    int b=100;
    int *a = &b;
    int c;
    
    // int b ;
    // a = &b;
    // int  *c;
    // c = a++;
    // c = ++a;

    // char a ;
    // char *b;
    // b = (*p)++;
    // a = *(*p)++;
    // return (int )a;

}

void test2()
{
    char ary[5] ;
    void *p = &ary;
    int a = test(p);
}
