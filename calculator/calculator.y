%{
#include <stdlib.h>
#include <stdio.h>
int yylex();
int yyerror(char *s);
%}

%token ADD SUB MUL DIV ABS OP CP EOL NUMBER

%left ADD SUB
%left MUL DIV

%%

CALC: /* empty */ { printf("> "); }
    | CALC EOL { printf("> "); }
    | CALC exp EOL { printf("= %d\n> ", $2); }

exp: FACTOR
   | exp ADD FACTOR { $$ = $1 + $3; }
   | exp SUB FACTOR { $$ = $1 - $3; }

FACTOR: TERM
      | FACTOR MUL TERM { $$ = $1 * $3; }
      | FACTOR DIV TERM { $$ = $1 / $3; }

TERM: NUMBER
    | ABS TERM { $$ = abs($2); }
    | OP exp CP { $$ = $2; }

%%

int main() {
  yyparse();
  return 0;
}

int yyerror(char *error) {
  fprintf(stderr, "Error: %s\n", error);
  return 0;
}
