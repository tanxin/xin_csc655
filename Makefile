all:	lex yacc compile

lex:
	flex -o mycalc.yy.c mycalc.lex

yacc:
	bison -d -v mycalc.y

compile:
	gcc -Wall -lm -o mycalc mycalc.tab.c mycalc.yy.c

clean:
	rm -f mycalc.tab.h mycalc.tab.c mycalc.yy.c mycalc mycalc.output
