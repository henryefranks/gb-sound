ASM    := rgbasm
LINKER := rgblink
FIX    := rgbfix

SRCDIR := src
INCDIR := include

BLDDIR := build
OBJDIR := $(BLDDIR)/obj
GB     := $(BLDDIR)/sound.gb

SRC := $(wildcard $(SRCDIR)/*.asm)
OBJ := $(addprefix $(OBJDIR)/, $(SRC:$(SRCDIR)/%.asm=%.o))


.PHONY: all clean

all: build

build: $(OBJ)
	$(LINKER) $(OBJ) -o $(GB)
	$(FIX) -p0 -v $(GB)

$(OBJDIR)/%.o: $(SRCDIR)/%.asm
	@ mkdir -p $(OBJDIR)
	$(ASM) -i $(INCDIR) -o $@ $<

clean:
	@ $(RM) -r $(BLDDIR)/*
