.PHONY: help test build clean print-config

help:
	@echo "Targets:"
	@echo "  make test          Run lightweight installer sanity checks"
	@echo "  make build         Build dist/g5 and dist/g5-templates.tar.gz (requires bun)"
	@echo "  make print-config  Print the settings.json patch g5 would apply"
	@echo "  make clean         Remove build + temp artifacts"

test:
	@bash ./scripts/test.sh

build:
	@bash ./scripts/build-g5.sh

print-config:
	@bash ./bin/g5 print-config

clean:
	@rm -rf dist .tmp-claude .tmp-workspace .tmp-test-claude .tmp-test-workspace

