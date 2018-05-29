out 	:= $(CURDIR)/build
obj		:= $(CURDIR)/obj
src		:= $(CURDIR)/src

RM		:= rm -rf

GHC 	:= ghc
CFLAGS 	:= -tmpdir $(obj) -odir $(obj) -hidir $(obj) -i$(obj) -O3

PHONY 	:=

all: build

PHONY 	+= build
build: $(out)/bfc

$(out)/bfc: $(wildcard $(src)/*.hs)
	$(mkdir -p $(obj))
	$(mkdir -p $(out))
	$(GHC) $(CFLAGS) -o $@ $^

PHONY 	+= rebuild
rebuild: clean build

PHONY 	+= clean
clean:
	$(RM) $(obj)/*.o $(obj)*.hi $(out)/bfc

.PHONY: PHONY
