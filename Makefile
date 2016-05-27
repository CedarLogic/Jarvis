TARGET = jarvis
PREFIX = /usr/local/bin

SRC = jarvis.d utils.d

all: jarvis clean

jarvis:
	dmd $(SRC)

clean:
	rm -rf *.o

install:
	./install.sh
	install $(TARGET) $(PREFIX)

uninstall:
	rm -rf $(PREFIX)/$(TARGET)
