#The Makefile for bfc
#
#Providies conviniance for building and cleaning the project.
#
#Author: John Berg

#The name of the target file.
TARGET	:= bfc

#Project directories.
out 	:= $(CURDIR)/build
obj		:= $(CURDIR)/obj
src		:= $(CURDIR)/src

#Tools.
RM		:= rm -rf
GHC 	:= ghc

#The compiler flags to be used turing compilaiton.
CFLAGS 	:=
CFLAGS	+= -tmpdir $(obj)
CFLAGS	+= -odir $(obj)
CFLAGS 	+= -hidir $(obj)
CFLAGS	+= -i$(obj)
CFLAGS	+= -O3
CFLAGS 	+= -Wall
CFLAGS	+= -o

#A variable for storing all the rules which are not actual targets.
PHONY 	:=

#Default rule.
#Build the projcet.
all: build

#Build the project.
PHONY 	+= build
build: $(out)/$(TARGET)

#Make the projcet.
#Create the obj and out directory if they do not exist.
#Compile all the haskell source files.
$(out)/$(TARGET): $(wildcard $(src)/*.hs)
	$(mkdir -p $(obj))
	$(mkdir -p $(out))
	$(GHC) $(CFLAGS) $@ $^

#Rebuild the project.
#Clean the project then build the project.
PHONY 	+= rebuild
rebuild: clean build

#Clean the project.
#Remove all the .hi .o files in the out and obj directories.
PHONY 	+= clean
clean:
	$(RM) $(obj)/*.o $(obj)*.hi $(out)/bfc

#Mark PHONY as .PHONY
.PHONY: PHONY
