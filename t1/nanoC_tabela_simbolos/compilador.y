%{
#include <stdio.h>
#include <stdlib.h>
#include "tabela_simbolos.h"
#include "compilador.h"

int yylex();
extern FILE *yyin;
extern int yylineno;
FILE *log_file, *out_file;

struct tabela_simbolos * tab_simbolos = NULL;
int escopo_atual = 0;
%}

%define parse.error detailed

%union {
    char *lexema;
    struct lista_simbolo * lista_s;
    Tipo tipo;
}


%token INTEIRO REAL PROGRAM VAR BEGIN_TOKEN END IF THEN ELSE WHILE DO OPERADOR_ATRIBUICAO OPERADOR_RELACIONAL MAIS MENOS OR OPERADOR_MULTIPLICATIVO

%token <lexema>NUM <lexema>ID <lexema> FUNCTION <lexema> PROCEDURE

%type <lista_s>LISTA_DE_IDENTIFICADORES 
%type <lista_s> ARGUMENTOS
%type <lista_s> DECLARACOES 
%type <lista_s> LISTA_DE_PARAMETROS 
%type <lista_s> CABECALHO_DE_SUBPROGRAMA
%type <tipo>TIPO

%left '+' '-'
%left '*' '/'

%%

PROGRAMA: PROGRAM ID '(' LISTA_DE_IDENTIFICADORES ')' ';'
	DECLARACOES
	DECLARACOES_DE_SUBPROGRAMAS {
		imprime_tabela_simbolos(log_file, tab_simbolos);
	}
	ENUNCIADO_COMPOSTO
	'.'
        ;

LISTA_DE_IDENTIFICADORES: ID {$$ = insere_lista_simbolo(NULL, novo_simbolo3($1, VARIAVEL, escopo_atual));}
			| LISTA_DE_IDENTIFICADORES ',' ID {$$ = insere_lista_simbolo($1, novo_simbolo3($3, VARIAVEL, escopo_atual));}
			;

DECLARACOES: DECLARACOES VAR LISTA_DE_IDENTIFICADORES ':' TIPO ';' {atualiza_tipo_simbolos($3,$5); tab_simbolos = insere_simbolos_ts(tab_simbolos, $3); imprime_tabela_simbolos(log_file, tab_simbolos);}
	   | /* empty */ { $$ = NULL; }
	   ;

TIPO: INTEIRO {$$ = INTEIRO;}
    | REAL {$$ = REAL;}
    ;

DECLARACOES_DE_SUBPROGRAMAS: DECLARACOES_DE_SUBPROGRAMAS DECLARACAO_DE_SUBPROGRAMA ';'
			   | /* empty */
			   ;

DECLARACAO_DE_SUBPROGRAMA: CABECALHO_DE_SUBPROGRAMA DECLARACOES ENUNCIADO_COMPOSTO 
                         ;

CABECALHO_DE_SUBPROGRAMA: FUNCTION ID { struct simbolo *func = novo_simbolo4($2, FUNCAO, escopo_atual, $1);tab_simbolos = insere_simbolo_ts(tab_simbolos, func); escopo_atual++;} ARGUMENTOS {
                 struct simbolo *func = busca_simbolo(tab_simbolos, $2);
                 insere_func_args(func, $4);
                 tab_simbolos = insere_simbolos_ts(tab_simbolos, $4);
                 fprintf(log_file, "Iniciando funcao %s\n",$2); } ':' TIPO ';' {imprime_tabela_simbolos(log_file, tab_simbolos); 
                 tab_simbolos = remove_simbolos(tab_simbolos, escopo_atual); 
                 escopo_atual--;
                 fprintf(log_file, "Finalizando funcao %s\n",$2);
                 }
		 | PROCEDURE ID { struct simbolo *func = novo_simbolo4($2, FUNCAO, escopo_atual, $1);tab_simbolos = insere_simbolo_ts(tab_simbolos, func); escopo_atual++;} ARGUMENTOS {
                 struct simbolo *func = busca_simbolo(tab_simbolos, $2);
                 insere_func_args(func, $4);
                 tab_simbolos = insere_simbolos_ts(tab_simbolos, $4);
                 fprintf(log_file, "Iniciando funcao %s\n",$2); } ':' TIPO ';' {imprime_tabela_simbolos(log_file, tab_simbolos); 
                 tab_simbolos = remove_simbolos(tab_simbolos, escopo_atual); 
                 escopo_atual--;
                 fprintf(log_file, "Finalizando funcao %s\n",$2);
                 }
		;

ARGUMENTOS: '(' LISTA_DE_PARAMETROS ')' { $$ = $2; }
	  | /* empty */ { $$ = NULL; }
	  ;

LISTA_DE_PARAMETROS: LISTA_DE_IDENTIFICADORES ':' TIPO {atualiza_tipo_simbolos($1,$3); tab_simbolos = insere_simbolos_ts(tab_simbolos, $1); imprime_tabela_simbolos(log_file, tab_simbolos);}
		   | VAR LISTA_DE_IDENTIFICADORES ':' TIPO {atualiza_tipo_simbolos($2,$4); tab_simbolos = insere_simbolos_ts(tab_simbolos, $2); imprime_tabela_simbolos(log_file, tab_simbolos);}
// NEED TO WORK ON THIS
		   | LISTA_DE_PARAMETROS ';' LISTA_DE_IDENTIFICADORES ':' TIPO {atualiza_tipo_simbolos($1,$5); tab_simbolos = insere_simbolos_ts(tab_simbolos, $1); imprime_tabela_simbolos(log_file, tab_simbolos);}
		   | LISTA_DE_PARAMETROS ';' VAR LISTA_DE_IDENTIFICADORES ':' TIPO {atualiza_tipo_simbolos($1,$6); tab_simbolos = insere_simbolos_ts(tab_simbolos, $1); imprime_tabela_simbolos(log_file, tab_simbolos);}
		   ;

ENUNCIADO_COMPOSTO: BEGIN_TOKEN ENUNCIADOS_OPCIONAIS END
		  ;

ENUNCIADOS_OPCIONAIS: LISTA_DE_ENUNCIADOS
		    | /* empty */
		    ;

LISTA_DE_ENUNCIADOS: ENUNCIADO
		   | LISTA_DE_ENUNCIADOS ';' ENUNCIADO

ENUNCIADO: VARIAVEL OPERADOR_ATRIBUICAO EXPRESSAO
	 | CHAMADA_DE_PROCEDIMENTO
	 | ENUNCIADO_COMPOSTO
	 | ID EXPRESSAO THEN ENUNCIADO ELSE ENUNCIADO
	 | WHILE EXPRESSAO DO ENUNCIADO
	 ;

VARIAVEL: ID
	;

CHAMADA_DE_PROCEDIMENTO: ID
                    | ID '(' LISTA_DE_EXPRESSOES ')'
                    ;

LISTA_DE_EXPRESSOES: EXPRESSAO
                   | LISTA_DE_EXPRESSOES ',' EXPRESSAO
                   ;

EXPRESSAO: EXPRESSAO_SIMPLES
         | EXPRESSAO_SIMPLES OPERADOR_RELACIONAL EXPRESSAO_SIMPLES
         ;

EXPRESSAO_SIMPLES: TERMO
                 | SINAL TERMO  
                 | EXPRESSAO_SIMPLES MAIS EXPRESSAO_SIMPLES 
                 | EXPRESSAO_SIMPLES MENOS EXPRESSAO_SIMPLES 
                 | EXPRESSAO_SIMPLES OR EXPRESSAO_SIMPLES 
                 ;

TERMO: FATOR
     | TERMO OPERADOR_MULTIPLICATIVO FATOR
     ;

FATOR: ID
     | ID '(' LISTA_DE_EXPRESSOES ')'
     | NUM 
     | '(' EXPRESSAO ')'
     ;

SINAL: MAIS
     | MENOS 
     ;

%%

int main(int argc, char ** argv) {
    log_file = fopen ("compilador.log", "w");
    //out_file = fopen ("output.ll", "w");
    if (argc == 2) {
        yyin = fopen(argv[1], "r");
        yylineno=1;
        yyparse();
    } else if (argc == 1) {
        yyparse();
    }    
    fprintf(log_file, "Finalizando compilacao\n");
    //fclose(out_file);
    fclose(log_file);
    return 0;
}

int yyerror(const char *s) {
  fprintf(stderr, "Erro na linha %d: %s\n", yylineno,s);
  exit(1);
  //return 0;
}

