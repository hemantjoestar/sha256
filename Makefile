.PHONY: default

# Default target
default: test format

# Test the project
test:
	cairo-test .

test_with_args:
	cairo-test . $(ARGS)

format:
	cairo-format --recursive src/*
