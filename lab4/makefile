.PHONY:lcc,clean
lcc:
	flex -+ mylex3.l
	g++ lex.yy.cc -o lcc.out
	./lcc.out <test.c
clean:
	rm *.out

