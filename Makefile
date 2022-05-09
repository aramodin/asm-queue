try_stdlib:	main.o stdlib.o string.o stack.o memory.o test.o
	ld main.o stdlib.o string.o stack.o memory.o test.o -o try_stdlib

lab-gal-1_2: lab-gal-1_2.o stdlib2.o string.o memory.o
	ld lab-gal-1_2.o stdlib2.o string.o memory.o -o lab-gal-1_2

lab-gal-1_2.o:  lab-gal-1_2.s
	as --64 -g lab-gal-1_2.s -o lab-gal-1_2.o


main.o: main.s
	as --64 -g main.s -o main.o
stdlib.o: stdlib.s
	as --64 -g stdlib.s -o stdlib.o
stdlib2.o: stdlib2.s
	as --64 -g stdlib2.s -o stdlib2.o
string.o: string.s
	as --64 -g string.s -o string.o
stack.o: stack.s
	as --64 -g stack.s -o stack.o
memory.o: memory.s
	as --64 -g memory.s -o memory.o
test.o: test.s
	as --64 -g test.s -o test.o


clean:
	rm -rf *.o
	rm -rf try_stdlib
	rm -rf lab-gal-1_2
