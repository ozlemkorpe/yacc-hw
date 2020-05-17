%{
int yylex();
#include  <studio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "calc3.h"

void yyerror (char *s);
int semboller [52];
int sembolDegeri(char sembol);
void SembolDegeriniGuncelle(char sembol, int deger);
nodeType *opr(int oper, int nops, ...);
nodeType *id(int i);
nodeType *con(int value);
void freeNode(nodeType *p);
int ex(nodeType *p);
int yylex(void);
}%

/* Definitions */
%union {int num; char id; char* strval; nodeType *nodePointer] 
%start line

/*Token definitions*/
%token yazdir
%token cikis
%token <num> sayi
%token metin
%token <id> identifier
%token suresince
%token eger
%nonassoc egerx
%nonassoc degilse


/* Type Definitions */
%type <id> assignment
%type <num> expression
%type <strval> metin
%type <nodePointer> line expression line_list
%%


/*Inputs*/

line	: assignment ';'						{;}
		| cikis	';'								{exit(EXIT_SUCCESS);}
		| print exp ';'							{printf("Print %d\n", $2);}
		| line assignment ';'					{;}
		| expr ';' { $$ = $1; }
		| deger '=' expr ';'					{ $$ = opr('=', 2, id($1), $3); }
		/* WHILE, IF, IF ELSE */
		| suresince '(' expr ')' line 			{ $$ = opr(suresince, 2, $3, $5); }
		| eger '(' expr ')' line %prec IFX 		{ $$ = opr(eger, 2, $3, $5); }
		| eger '(' expr ')' line degilse line	{ $$ = opr(eger, 3, $3, $5, $7); }
		| '{' line_list '}' 					{ $$ = $2; }
		| line print exp ';'					{printf("Print %d\n", $3)}
		| line cikis ';'						{exit(EXIT_SUCCESS);}
		;

program	: fonksiyon 				{exit(0);};
fonksiyon: fonksiyon line 		{ex($2); freeNode($2);}
		| /* NULL */;
		
/*Mathematical Operations*/
assignment = identifier '=' exp {SembolDegeriniGuncelle($1, $3);};
exp		: term					{$$ = $1;}
		| exp '+' term			{$$ = $1 + $3;}
		| exp '-' term			{$$ = $1 - $3;}
		| exp '/' term			{$$ = $1 / $3;}
		| exp '*' term			{$$ = $1 * $3;}

		;

term	:sayi					{$$ = $1;}
		| identifier			{$$= sembolDegeri($1);}
		;

%%
int MetinIndexHesapla(char token){
	int idx=-1;
	if(isLower(token)){
		idx = token - 'a' + 26;
	} else if(isupper(token)){
		idx = token - 'A';
	}return idx;
}

int SembolIndexHesapla(char token){
	int idx= -1;
	if(isLower(token)){
		idx = token - 'a' + 26;
	} else if(isupper(token)){
		idx = token - 'A';
	}return idx;
}

int sembolDegeri(char sembol){
	int sembolIndexi = computeSymbolIndex(sembol);
	return semboller[sembolIndexi];	
}

void SembolDegeriniGuncelle(char sembol, int deger){
	int sembolIndexi=computeSymbolIndex(sembol);
	sembol[sembolIndexi] =  deger;
}

int main (void) {
	/* Symbol table*/
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 
