%{
#include "compiler.tab.h"
char err_buffer[500];
int yyerror(char *s);
%}

digitos [0-9]+

%%

"program"                                   { return PROGRAM; }
"."                                         { return DOT; }
"var"                                       { return VAR; }
"integer"                                   { return INTEGER; }
"real"                                      { return REAL; }
"function"                                  { return FUNCTION; }
"procedure"                                 { return PROCEDURE; }
"("                                         { return LPAREN; }
")"                                         { return RPAREN; }
";"                                         { return SEMI; }
":"                                         { return COLON; }
"begin"                                     { return BEGIN_TOKEN; }
"end"                                       { return END_TOKEN; }
"if"                                        { return IF; }
"then"                                      { return THEN; }
"else"                                      { return ELSE; }
"while"                                     { return WHILE; }
"do"                                        { return DO; }
":="                                        { return ASSIGN; }
"+"                                         { return PLUS; }
"-"                                         { return MINUS; }
"or"                                        { return OR; }
(=)|(<>)|(>=)|(<=)|(>)|(<)                  { return RELOP; }
(\*)|(\/)|(mod)|(div)|(and)                 { return MULOP; }
{digitos}(.{digitos})?([Ee][+-]?{digitos})? { yylval = atof(yytext); return NUM; }
[a-zA-Z][a-zA-Z1-9]*                        { return ID; }
[ \t\n\r\f\v]+                              { /* Ignores white spaces */ };
.      { sprintf(err_buffer, "UNEXPECTED CHARACTER: '%c'", *yytext); yyerror(err_buffer); }

%%

/* Fazer planejamento das tarefas */
/* pensar no software */
/* add logger */

