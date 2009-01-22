/* Ralph Belcher - preliminary to Project 2 CSC 655	*/
/*		 - 14 Nov 2004				*/

%{
#include <math.h>	/* For math functions, cos(), sin(), etc. */
#include <stdio.h>	/* For printf function */
#include "calc.h"	/* Contains definition of `symrec' */
%}
%union {
double val;		/* For returning numbers. */
struct symrec *tptr;	/* For returning symbol-table pointers. */
double (*fnct)();	/* For function pointer. */
}

%token NL LP RP
%token <val> NUM	/* Simple double precision number */
%token <tptr> VAR	/* Variable */
%token <fnct> FNCT	/* Function */
%type <val> exp
%right ASSIGNOP
%left ADDOP SUBOP
%left MULTIOP DIVOP
%left NEG		/* Negation--unary minus */
%right POWER		/* Exponentiation */

/* Grammar follows */

%%
input:	/* empty */
	| input line
;
line:	NL
 	| exp NL	{ printf ("\t%.10g\n", $1); }
 	| error NL	{ yyerrok; }
;
exp:	NUM			{ $$ = $1; }
 	| VAR			{ $$ = $1->var; }
	| VAR ASSIGNOP exp 	{ $$ = $3; $1->var = $3; }
	| FNCT LP exp RP	{ $$ = (*$1)($3); }
	| exp ADDOP exp		{ $$ = $1 + $3; }
	| exp SUBOP exp		{ $$ = $1 - $3; }
	| exp MULTIOP exp	{ $$ = $1 * $3; }
	| exp DIVOP exp		{ $$ = $1 / $3; }
	| SUBOP exp  %prec NEG { $$ = -$2; }
	| exp POWER exp		{ $$ = pow ($1, $3); }
	| LP exp RP		{ $$ = $2; }
;
/* End of grammar */
%%

#include <string.h>

extern FILE *yyin;
int main (int argc, char *argv[]){
	if(argc > 1){
		if(!(yyin = fopen(argv[1], "r"))){
			printf("file %s could not be read, use stdin backward\n", argv[1]);
			yyin = stdin;
		}
	}else{
		yyin = stdin;
	}

	yyparse ();
	
	if(yyin != stdin){
		fclose(yyin);
	}

	return 0;
}

int yyerror (char const *s){	/* Called by yyparse on error */
	printf ("%s\n", s);
	return 0;
}

/* The symbol table: a chain of `struct symrec'. */

symrec *sym_table = (symrec *)0;

symrec *putsym (char *sym_name){
	symrec *ptr;
	ptr = (symrec *) malloc (sizeof (symrec));
	ptr->name = (char *) malloc (strlen (sym_name) + 1);
	strcpy (ptr->name,sym_name);
	ptr->var = 0; /* set value to 0 even if fctn. */
	ptr->next = (struct symrec *)sym_table;
	sym_table = ptr;
	return ptr;
}

symrec *getsym (char *sym_name){
	symrec *ptr;
	for (ptr = sym_table; ptr != (symrec *) 0; ptr = (symrec *)ptr->next)
		if (strcmp (ptr->name,sym_name) == 0)
			return ptr;
	return 0;
}
