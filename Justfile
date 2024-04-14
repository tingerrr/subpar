export TYPST_ROOT := justfile_directory()

# list recipes
[private]
default:
	just --list

# generate the manual
doc:
	typst compile doc/manual.typ doc/manual.pdf

# generate the example images
examples:
	# TODO

# run the test suite
test filter='':
	typst-test run {{ filter }}

# update the tests
update filter='':
	typst-test update {{ filter }}

# run the ci test suite
ci:
	# run one single test first to avoid a race condition on package downloads
	typst-test run example
	typst-test run
