# define the name of application
TARGET := MyProgram

# define the cpp compiler to use
CXX := g++

# define the FLAGS
CFLAGS := -Wall $(shell pkg-config gtkmm-3.0 sdl2 --cflags)

LFLAGS := $(shell pkg-config gtkmm-3.0 sdl2 --libs) -lSDL2_image

# define bin directory
BIN := bin

# define include directory
INC := include

# define lib directory
LIB := lib

# define source directory
SRC := src

# define object directory
OBJ := obj

VPATH := $(SRC) $(INC) $(LIB)

# define the color of the console text
RED    := $(shell echo -e "[031m")
GREEN  := $(shell echo -e "[032m")
YELLOW := $(shell echo -e "[033m")
BLUE   := $(shell echo -e "[034m")
PURPLE := $(shell echo -e "[035m")
CYAN   := $(shell echo -e "[036m")
WHITE  := $(shell echo -e "[037m")
RESET  := $(shell echo -e "[0m")

OBJS := $(patsubst %.cpp, $(OBJ)/%.o, $(wildcard $(SRC)/*.cpp) $(wildcard $(SRC)/**/*.cpp) $(wildcard $(LIB)/*.cpp))

# Create destination directories if they do not exist
DIRS := $(sort $(dir $(OBJS)))
$(shell mkdir -p $(DIRS) $(BIN))

# Generate object files
$(OBJ)/%.o: %.cpp
ifeq ($(OS),Windows_NT)
	@IF NOT EXIST $(subst /,,$(OBJ)) mkdir $(subst /,,$(OBJ))
else
	@mkdir -p $(OBJ)
endif
	@echo $(CYAN)Compiling: $(RED)$(@F)$(RESET)
	@$(CXX) -I $(INC) -c $(CFLAGS) $< -o $@

# Generate executable
$(BIN)/$(TARGET): $(OBJS)
ifeq ($(OS),Windows_NT)
	@IF NOT EXIST $(subst /,,$(BIN)) mkdir $(subst /,,$(BIN))
else
	@mkdir -p $(BIN)
endif
	@echo $(CYAN)Creating executable: $(GREEN)$(@F)$(RESET)
	@$(CXX) $(LFLAGS) $(OBJS) -o $@

.PHONY: run
run:
	@$(BIN)/$(TARGET)
