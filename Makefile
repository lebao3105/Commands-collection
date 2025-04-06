include vars.Makefile

# Targets

# Build everything
all: init_ src includes

includes:
	$(MAKE) -C include

src:
	$(MAKE) -C src

init_:
ifeq ($(DO_CLEAN), 1)
	$(MAKE) clean
endif

# Pack

# Clean
clean:
	$(RM) -rf $(wildcard $(build_obj)/*) $(wildcard $(build_progs)/*)
