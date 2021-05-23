## Exemplary make rules for BBS-Ruby

MRB_CONFIG_PATH != which mruby-config
MRB_CONFIG ?= $(MRB_CONFIG_PATH)

MRB_CFLAGS != "$(MRB_CONFIG)" --cflags
MRB_LDFLAGS != "$(MRB_CONFIG)" --ldflags
RUBY_CFLAGS = $(MRB_CFLAGS)
RUBY_LDFLAGS = $(MRB_LDFLAGS) mruby m

bbsruby.o: bbsruby.c
	$(CC) $(CFLAGS) $(RUBY_CFLAGS) -c $*.c

bbsruby.so: bbsruby.o
	$(CC) $*.o -o $*.so $(LDFLAGS) $(RUBY_LDFLAGS)
