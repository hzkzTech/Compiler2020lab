说明：
1. 项目目前可以编译成功（`make`）。
2. lex与yacc只支持分析变量声明。
3. `*.cpp`是空的，需要你自己填充。
4. `*.h`中枚举变量的声明只包含了最简单的内容，需要你根据需要填充。

仅作参考，相信已经足够你思考到完成作业的思路。

添加实现内容：
### 常量类型
1. float
   1. node_type=TYPE_FLOAT
   2. 小数
   3. 科学计数法
2. char
   1. 存在int值与char值
   2. 具有float值
3. string
   1. str_val=yytext
4. bool
   1. 支持true,false