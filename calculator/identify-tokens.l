
%%

"+"    { printf("PLUS\n"); }
"-"    { printf("MINUS\n"); }
"*"    { printf("TIMES\n"); }
"/"    { printf("DIVIDE\n"); }
"|"    { printf("ABS\n"); }
[0-9]+ { printf("%s\n", yytext); }
[ \t]  { printf("WHITESPACE OR TAB\n"); }
\n     { printf("END OF EXPRESSION\n"); }
.      { printf("UNEXPECTED CHARACTER\n"); }

%%
