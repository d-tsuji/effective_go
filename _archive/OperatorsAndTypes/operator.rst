=========================
演算子
=========================

https://golang.org/ref/spec#Operators

Goでは以下の演算子が定義されています。

.. code-block:: go

    Expression = UnaryExpr | Expression binary_op Expression .
    UnaryExpr  = PrimaryExpr | unary_op UnaryExpr .

    binary_op  = "||" | "&&" | rel_op | add_op | mul_op .
    rel_op     = "==" | "!=" | "<" | "<=" | ">" | ">=" .
    add_op     = "+" | "-" | "|" | "^" .
    mul_op     = "*" | "/" | "%" | "<<" | ">>" | "&" | "&^" .

    unary_op   = "+" | "-" | "!" | "^" | "*" | "&" | "<-" .

演算子の優先順位は以下のとおりです。数字が大きいほど優先順位が高いです。

.. code-block:: go

    Precedence    Operator
        5             *  /  %  <<  >>  &  &^
        4             +  -  |  ^
        3             ==  !=  <  <=  >  >=
        2             &&
        1             ||