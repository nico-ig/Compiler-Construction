%{
  enum yytokentype {
    NUMBER = 258, ADD, MINUS, TIMES, DIVIDE, ABS, EOL
  };

  int yylval = 0;
%}

%%

"+"    { return ADD; }
"-"    { return MINUS; }
"*"    { return TIMES; }
"/"    { return DIVIDE; }
"|"    { return ABS; }
[0-9]+ { yylval = atoi(yytext); return NUMBER; }
[ \t]  { /* Ignores whitespaces */ }
\n     { return EOL; }
.      { printf("UNEXPECTED CHARACTER\n"); }

%%

int main(int argc, char** argv) {
  int tok;

  while ((tok = yylex())) {
    printf("%d", tok);
    if (tok == NUMBER)
      printf(" = %d", yylval);
    printf("\n");
  }
}
