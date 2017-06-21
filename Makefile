# A simple makefile for packaging the:
# Report on liquid film flow over an inclined plate: effect of solvent properties
VERSION    := $(shell git describe --tags --dirty )
PRODUCT    := VOF Area Correlation
PROD_SNAME := VOF_Area_Correlation
LICENSE    := LICENSE.md
PKG_DIR    := CCSI_$(PROD_SNAME)_$(VERSION)
PACKAGE    := $(PKG_DIR).zip

PAYLOAD := docs/*.pdf \
     FluentFilmCase \
     FluentRivuletCase \
     OpenFoamCase \
     README.md \
     $(LICENSE)

# Get just the top part (not dirname) of each entry so cp -r does the right thing
PAYLOAD_TOPS := $(foreach v,$(PAYLOAD),$(shell echo $v | cut -d'/' -f1))
# And the payload with the PKG_DIR prepended
PKG_PAYLOAD := $(addprefix $(PKG_DIR)/, $(PAYLOAD))

# OS detection & changes
UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
  MD5BIN=md5sum
endif
ifeq ($(UNAME), Darwin)
  MD5BIN=md5
endif
ifeq ($(UNAME), FreeBSD)
  MD5BIN=md5
endif

.PHONY: all clean

all: $(PACKAGE)

$(PACKAGE): $(PAYLOAD)
	@mkdir $(PKG_DIR)
	@cp -r $(PAYLOAD_TOPS) $(PKG_DIR)
	@zip -qrX $(PACKAGE) $(PKG_PAYLOAD)
	@$(MD5BIN) $(PACKAGE)
	@rm -rf $(PKG_DIR)

clean:
	@rm -rf $(PACKAGE) $(PKG_DIR) *.zip
