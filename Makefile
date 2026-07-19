.PHONY: setup
setup:
	mise install
	mise exec -- dart pub global activate melos
	mise exec -- dart run melos bootstrap
