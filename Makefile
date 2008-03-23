DIRS	= server client

PROJ_DIR = . client server dp_server client/java_gui

CCFLAGS =
OCFLAGS =

INCDIR = $(PROJ_DIR:%=-I %)

CC = gcc $(CCFLAGS) $(INCDIR)
OC = ocamlc $(OCFLAGS) $(INCDIR)
JAVAC = javac

default : backend frontend

backend :
	cd utils ;\
	make; \

	cd language; \
	make; \

	cd compiler; \
	make; \

	cd servers; \
	make; \


frontend:
	cd client; \
	make; \


clean :
	cd utils; \
	make clean; \

	cd language; \
	make clean; \

	cd compiler; \
	make clean; \

	cd servers; \
	make clean; \

	cd client; \
	make clean; \
