CC = swiftc
EXE = defaultapp

.PHONY = all install clean

all: $(EXE)

ifndef LOCATION
LOCATION = /usr/local/bin/
endif

$(EXE): main.swift
	$(CC) $< -o $@

install: $(EXE)
	cp $(EXE) $(LOCATION)

clean:
	rm -f $(EXE)
