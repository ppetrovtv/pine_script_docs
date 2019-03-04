.. raw:: mediawiki

   {{Languages}}

Pine Script *@version=2* lexer grammar in `ANTLR
v3 <http://www.antlr3.org/>`__ syntax.

.. code:: antlr

    COND : '?' ;
    COND_ELSE : ':' ;
    OR : 'or' ;
    AND : 'and' ;
    NOT : 'not' ;
    EQ : '==' ;
    NEQ : '!=' ;
    GT : '>' ;
    GE : '>=' ;
    LT : '<' ;
    LE : '<=' ;
    PLUS : '+' ;
    MINUS : '-' ;
    MUL : '*' ;
    DIV : '/' ;
    MOD : '%' ;
    COMMA : ',' ;
    ARROW : '=>' ;
    LPAR : '(' ;
    RPAR : ')' ;
    LSQBR : '[' ;
    RSQBR : ']' ;
    DEFINE : '=' ;
    IF_COND : 'if' ;
    IF_COND_ELSE : 'else' ;
    BEGIN : '|BEGIN|' ;
    END : '|END|' ;
    ASSIGN : ':=' ;
    FOR_STMT : 'for' ;
    FOR_STMT_TO : 'to' ;
    FOR_STMT_BY : 'by' ;
    BREAK : 'break' ;
    CONTINUE : 'continue' ;
    LBEG : '|B|' ;
    LEND : '|E|' ;
    PLEND : '|PE|' ;
    INT_LITERAL : ( '0' .. '9' )+ ;
    FLOAT_LITERAL : ( '.' DIGITS ( EXP )? | DIGITS ( '.' ( DIGITS ( EXP )? )? | EXP ) );
    STR_LITERAL : ( '"' ( ESC | ~ ( '\\' | '\n' | '"' ) )* '"' | '\'' ( ESC | ~ ( '\\' | '\n' | '\'' ) )* '\'' );
    BOOL_LITERAL : ( 'true' | 'false' );
    COLOR_LITERAL : ( '#' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT | '#' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT );
    ID : ( ID_LETTER ) ( ( '\.' )? ( ID_BODY '\.' )* ID_BODY )? ;
    ID_EX : ( ID_LETTER_EX ) ( ( '\.' )? ( ID_BODY_EX '\.' )* ID_BODY_EX )? ;
    INDENT : '|INDENT|' ;
    LINE_CONTINUATION : '|C|' ;
    EMPTY_LINE_V1 : '|EMPTY_V1|' ;
    EMPTY_LINE : '|EMPTY|' ;
    WHITESPACE : ( ' ' | '\t' | '\n' )+ ;
    fragment ID_BODY : ( ID_LETTER | DIGIT )+ ;
    fragment ID_BODY_EX : ( ID_LETTER_EX | DIGIT )+ ;
    fragment ID_LETTER : ( 'a' .. 'z' | 'A' .. 'Z' | '_' ) ;
    fragment ID_LETTER_EX : ( 'a' .. 'z' | 'A' .. 'Z' | '_' | '#' ) ;
    fragment DIGIT : ( '0' .. '9' ) ;
    fragment ESC : '\\' . ;
    fragment DIGITS : ( '0' .. '9' )+ ;
    fragment HEX_DIGIT : ( '0' .. '9' | 'a' .. 'f' | 'A' .. 'F' ) ;
    fragment EXP : ( 'e' | 'E' ) ( '+' | '-' )? DIGITS ;
    Tokens : ( COND | COND_ELSE | OR | AND | NOT | EQ | NEQ | GT | GE | LT | LE | PLUS | MINUS | MUL | DIV | MOD | COMMA | ARROW | LPAR | RPAR | LSQBR | RSQBR | DEFINE | IF_COND | IF_COND_ELSE | BEGIN | END | ASSIGN | FOR_STMT | FOR_STMT_TO | FOR_STMT_BY | BREAK | CONTINUE | LBEG | LEND | PLEND | INT_LITERAL | FLOAT_LITERAL | STR_LITERAL | BOOL_LITERAL | COLOR_LITERAL | ID | ID_EX | INDENT | LINE_CONTINUATION | EMPTY_LINE_V1 | EMPTY_LINE | WHITESPACE );

--------------

Previous: `Appendix A. Pine Script v2
preprocessor <Appendix_A._Pine_Script_v2_preprocessor>`__, Next:
`Appendix C. Pine Script v2 parser
grammar <Appendix_C._Pine_Script_v2_parser_grammar>`__, Up: `Pine Script
Tutorial <Pine_Script_Tutorial>`__

`Category:Pine Script <Category:Pine_Script>`__
