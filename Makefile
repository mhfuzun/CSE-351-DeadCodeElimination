SRC     	:= src
BUILD   	:= build
TARGET  	:= dead
INC     	:= inc

CXX     	:= g++
CC      	:= g++
CFLAGS  	:= -Wall -Wextra -I$(INC) 
CXXFLAGS	:= -Wall -Wextra -I$(INC)

CFLAGS 		+= -Wno-sign-compare -Wno-unused-variable -Wno-unused-function
CXXFLAGS 	+= -Wno-sign-compare -Wno-unused-variable -Wno-unused-function

LEX     	:= flex
YACC    	:= /opt/homebrew/opt/bison/bin/bison

# ========================
# Kaynaklar
# ========================

SRC_CPP := $(wildcard $(SRC)/*.cpp)
OBJ_CPP := $(patsubst $(SRC)/%.cpp,$(BUILD)/%.o,$(SRC_CPP))

LEX_C   := $(BUILD)/lex.yy.cpp
YACC_C  := $(BUILD)/y.tab.cpp

LEX_O   := $(BUILD)/lex.yy.o
YACC_O  := $(BUILD)/y.tab.o

OBJS := $(OBJ_CPP) $(LEX_O) $(YACC_O)

# ========================
# Hedefler
# ========================

all: $(BUILD) $(TARGET)

$(BUILD):
	mkdir -p $(BUILD)

$(TARGET): $(OBJS)
	$(CXX) $(OBJS) -o $(BUILD)/$(TARGET)

# ========================
# C++ derleme
# ========================

$(BUILD)/%.o: $(SRC)/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# ========================
# Lex / Yacc
# ========================

YACC_C := $(BUILD)/y.tab.cpp
YACC_H := $(BUILD)/y.tab.hpp

$(YACC_C) $(YACC_H): $(SRC)/yacc_file.y | $(BUILD)
	$(YACC) -d -v $< -o $(YACC_C)

$(LEX_C): $(SRC)/lex_file.l $(BUILD)/y.tab.hpp | $(BUILD)
	$(LEX) -o $@ $<

# ========================
# Generated C → Object
# ========================

$(YACC_O): $(YACC_C)
	$(CC) $(CFLAGS) -c $< -o $@

$(LEX_O): $(LEX_C)
	$(CC) $(CFLAGS) -c $< -o $@

# ========================
# Temizlik
# ========================

clean:
	rm -rf $(BUILD)
