TARGET = jarvis
PREFIX = /usr/local/bin

SRC = jarvis.d header.d

all: jarvis clean

jarvis:
	dmd $(SRC)

clean:
	rm -rf *.o

install:
	install $(TARGET) $(PREFIX)

uninstall:
	rm -rf $(PREFIX)/$(TARGET)
