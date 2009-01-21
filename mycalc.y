/* mfcalc - as given in the Bison mannual - no changes       */

/* Ralph Belcher - preliminary to Project 2 CS 655           */
/*               - 14 Nov 2004                               */

%{
#include <math.h>  /* For math functions, cos(), sin(), etc. */
#include <stdio.h>
#include "calc.h"  /* Contains definition of `symrec'        */
%}
%union {
double val;		/* For returning numbers.                   */
struct symrec  *tptr;	/* For returning symbol-table pointers      */
double (*fnct)();
}
%token NL LP RP
%token <val>  NUM        /* Simple double precision number   */
%token <tptr> VAR	/* Variable */
%token <fnct> FNCT	/* Function */
%type  <val>  exp
%right ASSIGNOP
%left ADDOP SUBOP
%left MULTIOP DIVOP
%left NEG     /* Negation--unary minus */
%right POWER    /* Exponentiation        */

/* Grammar follows */

%%
input:   /* empty */
        | input line
;
line:   NL
        | exp NL   { printf ("\t%.10g\n", $1); }
        | error NL { yyerrok;                  }
;
exp:      NUM                { $$ = $1;                         }
        | VAR                { $$ = $1->value.var;              }
        | VAR ASSIGNOP exp        { $$ = $3; $1->value.var = $3;     }
        | FNCT LP exp RP   { $$ = (*$1)($3); }
        | exp ADDOP exp        { $$ = $1 + $3;                    }
        | exp SUBOP exp        { $$ = $1 - $3;                    }
        | exp MULTIOP exp        { $$ = $1 * $3;                    }
        | exp DIVOP exp        { $$ = $1 / $3;                    }
        | SUBOP exp  %prec NEG { $$ = -$2;                        }
        | exp POWER exp        { $$ = pow ($1, $3);               }
        | LP exp RP        { $$ = $2;                         }
;
/* End of grammar */
%%

#include <string.h>

int main ()
{
  init_table ();
  yyparse ();
  return 0;
}

int yyerror (s)  /* Called by yyparse on error */
	char const *s;
{
  printf ("%s\n", s);
  return 0;
}

struct init arith_fncts[]
  = {
      {"sin", sin},
      {"cos", cos},
      {"atan", atan},
      {"ln", log},
      {"log10", log10},
      {"exp", exp},
      {"sqrt", sqrt},
      {0, 0}
    };

/* The symbol table: a chain of `struct symrec'.  */

symrec *sym_table = (symrec *)0;
void init_table ()  /* puts arithmetic functions in table. */
{
  int i;
  symrec *ptr;
  for (i = 0; arith_fncts[i].name != 0; i++)
    {
      ptr = putsym (arith_fncts[i].name, FNCT);
      ptr->value.fnctptr = arith_fncts[i].fnct;
    }
}

symrec *
putsym (sym_name,sym_type)
     char *sym_name;
     int sym_type;
{
  symrec *ptr;
  ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name,sym_name);
  ptr->type = sym_type;
  ptr->value.var = 0; /* set value to 0 even if fctn.  */
  ptr->next = (struct symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}

symrec *getsym (sym_name)  char *sym_name;
{
  symrec *ptr;
  for (ptr = sym_table; ptr != (symrec *) 0;
       ptr = (symrec *)ptr->next)
    if (strcmp (ptr->name,sym_name) == 0)
      return ptr;
  return 0;
}

#include <ctype.h>
//#include "mycalc.yy.c"

