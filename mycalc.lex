%{
#include "mycalc.tab.h"
%}
num		[0-9]+\.?[0-9]*
var		[A-Za-z][A-Za-z0-9_]*
nl		"\n"
assignop	"="
addop		"+"
subop		"-"
multiop		"*"
divop		"/"
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
	return VAR;
}
{nl} {return NL;}
.	return yytext[0];

%%
int yywrap(){
	return 1;
}
