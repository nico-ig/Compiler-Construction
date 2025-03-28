%{
unsigned long long chars = 0;
unsigned long long words = 0;
unsigned long long lines = 0;
%}

%%

[^ \t\n\r\f\v]+ { words++; chars += strlen(yytext); };
\n             { chars++; lines++; };
.              { chars++; };

%%

int main(int argc, char** argv) {
  yylex();
  printf("%lld %lld %lld\n", lines, words, chars);
}
