

BINS := gnome-sort stooge-sort

all: $(BINS)

gnome-sort: gnome-sort.c
	gcc -o $@ $<

stooge-sort: stooge-sort.c
	gcc -o $@ $<

test:
	perl test.pl

clean:
	rm -f $(BINS)


