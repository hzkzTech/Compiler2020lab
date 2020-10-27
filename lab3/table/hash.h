#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define HASHSIZE 50

typedef unsigned int uint;
/*定义一个链表的节点*/
typedef struct Node{
    char key[17];
    double value;
    struct Node *next;
};

/*定义一组链表*/
Node *node[HASHSIZE];

/*初始化:为链表头开辟空间*/
int init(Node *node)
{
    node = (Node *)malloc(sizeof(Node));
    if(NULL == node)
        return 1;

    bzero(node, sizeof(Node));

    return 0;
}

/*计算哈希值*/
uint hash(const char *key){
    uint hash = 0;
    for(; *key; ++key)
    {
        hash = hash*33+*key;
    }
    return hash%HASHSIZE;
}

/*查找:根据哈希值得出index, 然后到对应的链表中查找*/
Node *lookup(const char *key)
{
    Node *np;
    uint index;
    index = hash(key);
    for(np = node[index];np;np = np->next){
        if(!strcmp(key, np->key))
            return np;
    }
    return NULL;
}

/*插入：先查找该值是否存在，然后计算哈希值，插入对应的链表*/
uint install(const char *key, const double value)
{
    uint index;
    Node *np;

    if(!(np = lookup(key))){
        index = hash(key);
        np = (Node*)malloc(sizeof(Node));
        if(!np)
            return 1;
        strcpy(np->key, key);
        np->value=value;

        np->next = node[index];
        node[index] = np;
    }
    return 0;
}