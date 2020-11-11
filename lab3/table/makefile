sym.exe: sym.tab.o
	gcc -o sym sym.tab.o
sym.tab.o: sym.tab.c
	gcc -c sym.tab.c
sym.tab.c: sym.y 
	bison -d -v sym.y 
sym.tab.h: sym.y
	echo "sym.tab.h was created at the same time as sym.tab.c."
clean:
	rm-f sym.exe  sym.tab.o sym.tab.c sym.tab.h sym.exe.stackdumpsym.output