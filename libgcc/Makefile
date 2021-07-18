.POSIX:

CC=clang

libgcc_s.so: lib.c
	$(CC) -shared -o $@ -fPIC $? -lunwind

clean:
	rm -f libgcc_s.so
