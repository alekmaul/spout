# Define compilation type
OSTYPE=msys
#OSTYPE=oda320
#OSTYPE=odgcw0

PRGNAME     = spout-od

# define regarding OS, which compiler to use
ifeq "$(OSTYPE)" "msys"	
EXESUFFIX = .exe
TOOLCHAIN = /c/MinGW32
CC          = gcc
LD          = gcc
else
ifeq "$(OSTYPE)" "oda320"	
TOOLCHAIN = /opt/opendingux-toolchain/usr
else
TOOLCHAIN = /opt/gcw0-toolchain/usr
endif
EXESUFFIX = .dge
CC = $(TOOLCHAIN)/bin/mipsel-linux-gcc
LD = $(TOOLCHAIN)/bin/mipsel-linux-gcc
endif

# add SDL dependencies
SDL_LIB     = $(TOOLCHAIN)/lib
SDL_INCLUDE = $(TOOLCHAIN)/include

# change compilation / linking flag options
ifeq "$(OSTYPE)" "msys"	
CFLAGS      = -I$(SDL_INCLUDE) -O2 
LDFLAGS     = -L$(SDL_LIB) -L. -lmingw32 -lSDLmain -lSDL -mwindows
else
F_OPTS = -falign-functions -falign-loops -falign-labels -falign-jumps \
	-ffast-math -fsingle-precision-constant -funsafe-math-optimizations \
	-fomit-frame-pointer -fno-builtin -fno-common \
	-fstrict-aliasing  -fexpensive-optimizations \
	-finline -finline-functions -fpeel-loops
ifeq "$(OSTYPE)" "oda320"	
CC_OPTS	= -O2 -mips32 -msoft-float -G0 $(F_OPTS)
else
CC_OPTS	= -O2 -mips32 -mhard-float -G0 $(F_OPTS)
endif
CFLAGS      = -I$(SDL_INCLUDE) -DOPENDINGUX $(CC_OPTS)
LDFLAGS     = -L$(SDL_LIB) $(CC_OPTS) -lSDL 
endif

# Files to be compiled
OBJS        = spout.o piece.o

# Rules to make executable
$(PRGNAME)$(EXESUFFIX): $(OBJS)
ifeq "$(OSTYPE)" "msys"	
	$(LD) $(CFLAGS) -o $(PRGNAME)$(EXESUFFIX) $^ $(LDFLAGS)
else
	$(LD) $(LDFLAGS) -o $(PRGNAME)$(EXESUFFIX) $^
endif

.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<

spout.o: piece.h font.h sintable.h
piece.c: piece.h

clean:
	rm -f $(PRGNAME)$(EXESUFFIX) *.o
