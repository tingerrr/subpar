_doc := 'doc'
_assets := 'assets'
_showcase := _assets / 'showcase'

export TYPST_ROOT := justfile_directory()
export TYPST_FONT_PATHS := justfile_directory() / 'assets' / 'fonts'

# list recipes
[private]
default:
	@just --list --unsorted

# run the test suite
[positional-arguments]
test *args:
	tt run "$@"

# clean all output directories
clean:
	rm --recursive --force {{ _doc / 'out' }}
	rm --recursive --force {{ _showcase / 'out' }}
	tt util clean

# run the ci checks locally
ci: generate generate (test '--no-fail-fast' '--max-delta' '1')

# update all assets
update: update-showcase update-doc

# update the showcase image
update-showcase: generate-showcase
	oxipng --opt max {{ _showcase / 'out' / 'showcase.png' }}
	cp {{ _showcase / 'out' / 'showcase.png' }} {{ _assets / 'showcase.png' }}

# generate the showcase image
generate-showcase: (clear-directory (_showcase / 'out'))
	typst compile \
		{{ _showcase / 'showcase.typ' }} \
		{{ _showcase / 'out' / 'showcase.png' }}

# generate a new manual and update it
update-doc: generate-doc
	cp {{ _doc / 'out' / 'manual.pdf' }} {{ _assets / 'manual.pdf' }}

# generate all assets
generate: generate-showcase generate-doc

# generate the manual
generate-doc: (clear-directory (_doc / 'out'))
	typst compile \
		{{ _doc / 'manual.typ' }} \
		{{ _doc / 'out' / 'manual.pdf' }}

# watch the manual
watch-doc: (clear-directory (_doc / 'out'))
	typst watch \
		{{ _doc / 'manual.typ' }} \
		{{ _doc / 'out' / 'manual.pdf' }}

# ensure a directy exists and is empty
[private]
clear-directory dir:
	rm --recursive --force {{ dir }}
	mkdir {{ dir }}
