#include "tree.h"
static int _NodeID=0; //递增节点ID

void TreeNode::addChild(TreeNode* child) {
    if(this->child==nullptr){  //无孩子节点
        this->child=child;
        return;
    }
    this->child->addSibling(child); //添加到孩子的兄弟节点
}

void TreeNode::addSibling(TreeNode* sibling){
    TreeNode* p=this;
    while(p->sibling!=nullptr){  
        p=p->sibling;
    }
    p->sibling=sibling;
}

TreeNode::TreeNode(int lineno, NodeType type) {
    //this->genNodeId(); 导致底层向高层编号，换一种方式
    this->lineno=lineno;
    this->nodeType=type;
    this->type=nullptr;
}

void TreeNode::genNodeId() {    //先序遍历
    this->nodeID=_NodeID;
    _NodeID++;
    TreeNode* p=this->child;
    while (p!=nullptr){
        p->genNodeId();
        p=p->sibling;
    }    
}

void TreeNode::printNodeInfo() {
    cout<<"lno@"<<lineno<<" @"<<nodeID<<" "<<nodeType2String(nodeType)<<" ";
    printSpecialInfo();
    cout<<endl;
}

void TreeNode::printChildrenId() {
    if(child==nullptr) return; //不是stmt
    cout<<"children: [";
    TreeNode* p=child;
    while(p!=nullptr){
        cout<<"@"<<p->nodeID<<" ";
        p=p->sibling;
    }
    cout<<"] ";
}

void TreeNode::printAST() {
    this->printNodeInfo();
    TreeNode* p=this->child;
    while (p!=nullptr){
        p->printAST();
        p=p->sibling;
    }    
}


// You can output more info...
void TreeNode::printSpecialInfo() {
    switch(this->nodeType){
        case NODE_CONST:
            cout<<"type: "<<this->type->getTypeInfo()<<" ";
            //TODO:常量值，类型
            break;
        case NODE_VAR:
            cout<<"varname: "<<this->var_name<<" ";
            //TODO:变量类型
            break;
        case NODE_EXPR:
            this->printChildrenId();
            break;
        case NODE_STMT:
            this->printChildrenId();
            cout<<"stmt: "<<sType2String(this->stype)<<" ";
            break;
        case NODE_TYPE:
            cout<<"type: "<<this->type->getTypeInfo()<<" ";
            //TODO:复杂类型的输出处理
            break;
        default:
            break;
    }
}

string TreeNode::sType2String(StmtType type) {
    switch (type){
        case STMT_SKIP:
            return "skip";
            break;
        case STMT_DECL:
            return "decl";
            break;
        //TODO:stmt类型添加时这里添加
        default:
            return "unknown stmt";
            break;
        }
    return "?";
}


string TreeNode::nodeType2String (NodeType type){
  switch(type){
        case NODE_PROG:
            return "program";
            break;
        case NODE_STMT:
            return "statement";
            break;
        case NODE_CONST:
            return "const";
            break;
        case NODE_VAR:
            return "variable";
            break;
        case NODE_EXPR:
            return "expression";
            break;
        case NODE_TYPE:
            return "type";
            break;
        //TODO：NodeType增加时在此增加
    }
    return "<unknown>";
}
