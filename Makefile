lab-1_2: lab-1_2.o stdlib2.o string.o memory.o
	ld lab-1_2.o stdlib2.o string.o memory.o -o lab-1_2

lab-1_2.o:  lab-1_2.s
	as --64 -g lab-1_2.s -o lab-1_2.o


stdlib2.o: stdlib2.s
	as --64 -g stdlib2.s -o stdlib2.o
string.o: string.s
	as --64 -g string.s -o string.o
memory.o: memory.s
	as --64 -g memory.s -o memory.o


clean:
	rm -rf *.o
	rm -rf lab-1_2
