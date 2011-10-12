# makefile in top project dir
#
sourcedir=src
subsystem:
	$(MAKE) -C $(sourcedir)

.PYONE: clean install

clean:
	-rm objs/*
	$(MAKE) clean -C $(sourcedir)

install:
	$(MAKE) install -C $(sourcedir)
