.PHONY: setup
setup:
	mise exec -- dart pub global activate melos
	mise exec -- dart pub global activate mason
	mason get
	mason list
	melos bs
