
int compare(int condition, int a, int b)
{
    for (int  i = 0; i < 10; i++)
    {
        if(condition)
            continue;
        else
            break;  
    }
} 

int main()
{
    compare(1,2,3);
    return 0;
}