grammar CS;

// ===================== ПАРСЕР =====================

program
    : statement* EOF
    ;

statement
    : ifStatement
    | varDeclaration
    | blockStatement
    | expressionStatement
    ;

ifStatement
    : IF LROUND expression RROUND statement (ELSE statement)?
    ;

varDeclaration
    : TYPE IDENTIFIER (ASSIGN expression)? SEMI
    ;

blockStatement
    : LBRACE statement* RBRACE
    ;

expressionStatement
    : expression SEMI
    ;

// Порядок альтернатив = пріоритет: чим вище, тим сильніше зв'язує
expression
    : expression (INC | DEC)                          // x++  x--
    | (LOGICAL_NOT | MINUS) expression                // !x   -x
    | expression (MULTIPLY | DIVIDE) expression
    | expression (PLUS | MINUS) expression
    | expression (LESS | GREATER | LE | GE) expression
    | expression (EQ | NEQ) expression
    | expression LOGICAL_AND expression
    | expression LOGICAL_OR expression
    | <assoc=right> expression ASSIGN expression      // x = y = 5
    | LROUND expression RROUND                        // (a + b)
    | IDENTIFIER
    | NUMBER
    | STRING
    ;

// ===================== ЛЕКСЕР =====================

// Ключові слова й типи ПЕРЕД IDENTIFIER
IF      : 'if' ;
ELSE    : 'else' ;
TYPE    : 'int' | 'string' | 'bool' ;

// Оператори (довші токени лексер обере сам: <= замість < і =)
INC         : '++' ;
DEC         : '--' ;
LE          : '<=' ;
GE          : '>=' ;
EQ          : '==' ;
NEQ         : '!=' ;
LOGICAL_AND : '&&' ;
LOGICAL_OR  : '||' ;
LOGICAL_NOT : '!' ;
LESS        : '<' ;
GREATER     : '>' ;
ASSIGN      : '=' ;
PLUS        : '+' ;
MINUS       : '-' ;
MULTIPLY    : '*' ;
DIVIDE      : '/' ;

// Розділювачі
LROUND  : '(' ;
RROUND  : ')' ;
LBRACE  : '{' ;
RBRACE  : '}' ;
SEMI    : ';' ;

// Літерали та імена
IDENTIFIER : [a-zA-Z_][a-zA-Z0-9_]* ;
NUMBER     : [0-9]+ ;
STRING     : '"' .*? '"' ;

// Пропуски й коментарі
WS           : [ \t\r\n]+ -> skip ;
LINE_COMMENT : '//' ~[\r\n]* -> skip ;