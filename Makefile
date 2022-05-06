try_stdlib:	main.o stdlib.o string.o stack.o memory.o test.o
	ld main.o stdlib.o string.o stack.o memory.o test.o -o try_stdlib
	
main.o: main.o
	as --64 -g main.s -o main.o
stdlib.o: stdlib.s
	as --64 -g stdlib.s -o stdlib.o
string.o: string.s
	as --64 -g string.s -o string.o
stack.o: stack.s
	as --64 -g stack.s -o stack.o
memory.o: memory.s
	as --64 -g memory.s -o memory.o
test.o: test.s
	as --64 -g test.s -o test.o


clean:
	rm -r *.o
	rm -r try_stdlib
