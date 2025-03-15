%{
  #include "calculator.tab.h"
  char err_buffer[500];
  int yyerror(char *s);
%}

%%

"+"    { return ADD; }
"-"    { return SUB; }
"*"    { return MUL; }
"/"    { return DIV; }
"|"    { return ABS; }
"("    { return OP; }
")"    { return CP; }
"//".*  { /* Ignores comments */ }
[0-9]+ { yylval = atoi(yytext); return NUMBER; }
[ \t]  { /* Ignores whitespaces */ }
\n     { return EOL; }
.      { sprintf(err_buffer, "UNEXPECTED CHARACTER: %c\n", yytext); yyerror(err_buffer); }

%%

