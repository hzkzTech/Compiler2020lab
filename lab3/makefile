myyacc1.exe: myyacc1.tab.o
	gcc -o myyacc1 myyacc1.tab.o
myyacc1.tab.o: myyacc1.tab.c
	gcc -c myyacc1.tab.c
myyacc1.tab.c: myyacc1.y 
	bison -d -v myyacc1.y 
myyacc1.tab.h: myyacc1.y
	echo "myyacc1.tab.h was created at the same time as myyacc1.tab.c."
clean:
	rm-f myyacc1.exe  myyacc1.tab.o myyacc1.tab.c myyacc1.tab.h myyacc1.exe.stackdumpmyyacc1.output