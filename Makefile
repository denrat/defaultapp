CC = swiftc
EXE = defaultapp

.PHONY = all install clean

all: $(EXE)

$(EXE): main.swift
	$(CC) $< -o $@

install: $(EXE)
	cp $(EXE) /usr/local/bin/$(EXE)

clean:
	rm -f $(EXE)
