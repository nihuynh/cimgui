#
# Cross Platform Makefile
# Compatible with Ubuntu 14.04.1 and macOS

SRC =	cimgui.cpp 					\
		./imgui/imgui.cpp 			\
		./imgui/imgui_draw.cpp 		\
		./imgui/imgui_demo.cpp 		\
		./imgui/imgui_widgets.cpp

OBJS = $(SRC:.cpp=.o)

CXXFLAGS= -O2 -Wall

UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S), Linux) #LINUX
	ECHO_MESSAGE = "Linux"

	OUTPUTNAME = cimgui.so
	CXXFLAGS += -I./imgui/ -I includes
	CXXFLAGS += -shared -fPIC
	CFLAGS = $(CXXFLAGS)
endif

ifeq ($(UNAME_S), Darwin) #APPLE
	ECHO_MESSAGE = "macOS"

	OUTPUTNAME	=	cimgui.dylib
	CXXFLAGS	+=	-Wextra -Werror -Wno-return-type-c-linkage
	CXXFLAGS	+=	-I/usr/local/include -I includes
	LINKFLAGS	=	-dynamiclib
	CFLAGS		=	$(CXXFLAGS)
endif

ifeq ($(OS), Windows_NT)
	ECHO_MESSAGE = "Windows"

	OUTPUTNAME = cimgui.dll
	CXXFLAGS += -I./imgui/ -I includes
	CXXFLAGS += -shared
	LINKFLAGS = -limm32
	CFLAGS = $(CXXFLAGS)
endif

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

all:$(OUTPUTNAME)
	@echo Build complete for $(ECHO_MESSAGE)

$(OUTPUTNAME):$(OBJS)
	$(CXX) -o $(OUTPUTNAME) $(OBJS) $(CXXFLAGS) $(LINKFLAGS)

libcimgui.a:$(OBJS)
	ar rc $@ $(OBJS) && ranlib $@

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f libcimgui.a
	rm -f $(OUTPUTNAME)

re: fclean all

.PHONY: all clean fclean re
