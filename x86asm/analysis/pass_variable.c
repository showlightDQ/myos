void fun1(){
    static int a = 1;
}

void fun2(void){
    static int a = 2;
}
int main()

{
    static int a = 3;
    int b = 5;
    fun2();
    fun2();

    return 0;
} 