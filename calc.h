#ifndef __CALC_H__
#define __CALC_H__

/* Data type for links in the chain of symbols.      */
struct symrec {
	char *name;			/* name of symbol */
	int type;			/* type of symbol: either VAR or FNCT */
	union {
		double var;		/* value of a VAR */
		double (*fnctptr)();	/* value of a FNCT */
	} value;
	struct symrec *next;		/* link field */
};
typedef struct symrec symrec;

struct init {
	char *name;
	double (*fnct)();
};

/* The symbol table: a chain of `struct symrec'. */
extern symrec *sym_table;
symrec *putsym ();
symrec *getsym ();

/* declaration */
int yyerror (char const *);
int yylex();
void init_table();
struct init *in_word_set(register const char *, register unsigned int);
#endif

