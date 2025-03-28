%option yylineno 

%{
#include "tabela_simbolos.h"
#include "compilador.h"
#include "compilador.tab.h"
%}

%%

"program" { return PROGRAM;}
[a-zA-Z][a-zA-Z0-9]* { return ID;}
"var" { return VAR; }
"integer" { return INTEIRO; }
"real" { return REAL; }
"function" { return FUNCTION; }
"procedure" { return PROCEDURE; }
"begin" { return BEGIN_TOKEN; }
"end" { return END; }
"if" { return IF; }
"then" { return THEN; }
"else" { return ELSE; }
"while" { return WHILE; }
"do" { return DO; }
":=" { return OPERADOR_ATRIBUCAO; }

"="  |
"<>" |
">"  |
">=" |
"<"  |
"<=" { return OPERADOR_RELACIONAL; }

"+" { return MAIS; }
"-" { return MENOS; }

"or" { return OR; }

"*" |
"/" |
"div" |
"mod" |
"and" { return OPERADOR_MULTIPLICATIVO; }

"." |
"," |
":" |
";" |
")" |
"(" { return yytext[0]; }

[0-9]+(.[0-9]+)?([Ee][+-])?[0-9]+ {
    yylval.lexema = strdup(yytext);
    return NUM;
}

[a-zA-Z][a-zA-Z0-9]* {
    yylval.lexema = strdup(yytext);
    return ID;
}

\n {
    //return EOL;
}

[ \t] {/*ignorar espacos em branco, incluindo tabs*/}

%%

// Sem codigo aqui, flex sera usado pelo bison e nao 'standalone'
