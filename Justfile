root := justfile_directory()

export TYPST_ROOT := root
export TYPST_FONT_PATHS := root / 'assets' / 'fonts'

# list recipes
[private]
default:
	just --list

# run typst with the correct environment variables
typst *args:
	typst {{ args }}

# generate the manual
doc cmd='compile':
	typst {{ cmd }} doc/manual.typ doc/manual.pdf

# generate the example images
examples:
	typst compile examples/example.typ examples/example.png
	oxipng --opt max examples/example.png

# run the test suite
test filter='':
	typst-test run {{ filter }}

# update the tests
update filter='':
	typst-test update {{ filter }}

# run the ci test suite
ci: examples
	typst-test run
