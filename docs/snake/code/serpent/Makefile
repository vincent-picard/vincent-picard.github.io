CC = cc # nom du compilateur

# Resultat de la commande sdl2-config --cflags
CFLAGS= -I/usr/local/include -I/usr/local/include/SDL2 -D_REENTRANT -D_THREAD_SAFE

# Resultat de la commande sdl2-config --libs
LIBS= -L/usr/local/lib -lSDL2

.PHONY: clean

snake: main.o serpent.o
	$(CC) main.o serpent.o -o snake $(CFLAGS) $(LIBS)

main.o: main.h serpent.h main.c
	$(CC) -c main.c $(CFLAGS)

serpent.o: main.h serpent.h serpent.c
	$(CC) -c serpent.c

clean:
	rm -f *.o
