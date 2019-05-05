# If you think this Makefile is poorly written, you are probably correct.
# I have no idea what I am doing when it comes to things like Make.
DISK_FILE = SLIDES.DSK
DOS_DISK_FILE = ./ESDOS.DSK
APPLE_II_FILE_NAME = SLIDES
BINARY_FILE = ./src/nruby_slides
ASSEMBLY_FILE = ./src/nruby_slides.s

# Get the start address from the assembly
HEX_ADDRESS=$(shell ruby -e 'print ARGF.read[/ *ORG *[^ ]+/][/\w+$$/]' $(ASSEMBLY_FILE))

AC = java -jar ./AppleCommander.jar
MERLIN = ./Merlin32

all: clean $(BINARY_FILE) $(DISK_FILE)
	# Append the binary file to the disk.
	$(AC) -p $(DISK_FILE) $(APPLE_II_FILE_NAME) B 0x$(HEX_ADDRESS) < $(BINARY_FILE)

	# List out the contents of the disk
	$(AC) -l $(DISK_FILE)

	# Show size of binary
	ls -lh $(BINARY_FILE)

$(DISK_FILE):
	# Create an Apple DOS disk image
	cp $(DOS_DISK_FILE) $(DISK_FILE)

$(BINARY_FILE):
	# Compile the assembly into a binary file
	$(MERLIN) dev/null $(ASSEMBLY_FILE)

clean:
	rm -f $(BINARY_FILE) \
	      $(DISK_FILE) \
	      _FileInformation.txt \
	      ./src/_FileInformation.txt \
	      error_output.txt \
	      ./src/error_output.txt
