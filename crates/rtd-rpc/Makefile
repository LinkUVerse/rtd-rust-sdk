# Set the default target of this Makefile
.PHONY: all
all:: clippy test

.PHONY: check-features
check-features:
	cargo hack check --feature-powerset --no-dev-deps

.PHONY: clippy
clippy:
	cargo clippy --all-features --all-targets

.PHONY: test
test:
	cargo nextest run --all-features
	cargo test --doc

# Update vendored protos from rtd-apis master branch.
.PHONY: update-protos
update-protos:
	@rm -rf vendored/rtd-apis
	@rm -rf vendored/proto
	@git clone -q --depth=1 https://github.com/LinkUVerse/rtd-apis.git vendored/rtd-apis
	@mv vendored/rtd-apis/proto vendored/
	@rm -rf vendored/rtd-apis

# Update vendored protos from a local clone of rtd-apis.
# Example invocation:
#     make -C crates/rtd-rpc update-protos-local /path/to/rtd-apis
.PHONY: update-protos-local
update-protos-local:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Path not provided. Usage: make update-protos-local /path/to/rtd-apis"; \
		exit 1; \
	fi
	@if [ ! -d "$(filter-out $@,$(MAKECMDGOALS))/proto" ]; then \
		echo "Error: $(filter-out $@,$(MAKECMDGOALS))/proto does not exist"; \
		exit 1; \
	fi
	@rm -rf vendored/proto
	@cp -r "$(filter-out $@,$(MAKECMDGOALS))/proto" vendored/
	@echo "Updated protos from $(filter-out $@,$(MAKECMDGOALS))"

.PHONY: diff-protos
diff-protos:
	@rm -rf vendored/rtd-apis
	@git clone -q --depth=1 https://github.com/LinkUVerse/rtd-apis.git vendored/rtd-apis
	git diff --no-index vendored/rtd-apis/proto vendored/proto
	@rm -rf vendored/rtd-apis

.PHONY: proto
proto:
	cargo run -p proto-build

%:
	$(MAKE) -C ../.. $@
