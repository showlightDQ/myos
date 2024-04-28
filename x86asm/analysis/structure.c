typedef struct st_t
{
    char c1;
    short s1;
    char c2;
    char c3;
    int i1;
}__attribute__((packed)) struct_t;

/// @brief 
typedef struct st_tu
{
    char u1:1;
    char u2:3;
    char u3:2;
    char u4:2;
    char u5:4;
    char u6:4;
}__attribute__((packed)) struct_union_t;
struct_t data1;
struct st_t data2;
struct_union_t u2;

typedef enum et
{
    e1 = 1 ,
    e2 = 2,
    e3,
    e4,
}enum_t;
enum_t en = 3 ;

int main(int argc, char const *argv[])
{
    struct_union_t u1;
    u1.u1=1;
    u1.u2=7;
    u1.u3=1;
    u1.u4=1;
    u1.u5=7;
    u1.u6=0xf;
    return 0;
}
