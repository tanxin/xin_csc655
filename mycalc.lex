%{
#include "mycalc.tab.h"
#include "calc.h"
%}
num		[0-9]+\.?[0-9]*
var		[A-Za-z][A-Za-z0-9_]*
nl		"\n"
assignop	"="
addop		"+"
subop		"-"
multiop		"*"
divop		"/"
power		"^"
lp		"("
rp		")"
%%
[ \t] ;
EOF return 0;
{num} {
	//printf("lex: NUM %s\n", yytext);
	yylval.val = atof(yytext);
	return NUM;
}

{var} {
	symrec *s;
	s = getsym(yytext);
	if(s == 0)
		s = putsym(yytext, VAR);
	yylval.tptr = s;
	return s->type;
}
{assignop}	return ASSIGNOP;
{addop}		return ADDOP;
{subop}		return SUBOP;
{multiop}	return MULTIOP;
{divop}		return DIVOP;
{power}		return POWER;
{lp}		return LP;
{rp}		return RP;
{nl}		return NL;
.		return yytext[0];

%%
int yywrap(){
	return 1;
}
