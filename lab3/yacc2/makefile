myyacc2.exe: myyacc2.tab.o
	gcc -o myyacc2 myyacc2.tab.o
myyacc2.tab.o: myyacc2.tab.c
	gcc -c myyacc2.tab.c
myyacc2.tab.c: myyacc2.y 
	bison -d -v myyacc2.y 
myyacc2.tab.h: myyacc2.y
	echo "myyacc2.tab.h was created at the same time as myyacc2.tab.c."
clean:
	rm-f myyacc2.exe  myyacc2.tab.o myyacc2.tab.c myyacc2.tab.h myyacc2.exe.stackdumpmyyacc2.output