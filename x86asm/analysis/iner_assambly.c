int main(int argc, char const *argv[])
{

    asm("\n\t movl $1,%eax\n\t movl $2,%ebx\n\t int $0x80\n\t");
     
      
}
