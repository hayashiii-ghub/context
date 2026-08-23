SHELL_SCRIPTS := script/app_bundle.sh script/build_and_run.sh script/package.sh script/install_latest.sh script/test.sh script/test_install_latest.sh script/version.sh

.PHONY: build check run package install-latest release status

VERSION ?=

build:
	swift build

check:
	./script/test.sh
	./script/test_install_latest.sh
	@for script in $(SHELL_SCRIPTS); do \
		bash -n "$$script"; \
	done

run:
	./script/build_and_run.sh

package:
	CONTEXT_VERSION="$(VERSION)" ./script/package.sh

install-latest:
	./script/install_latest.sh

release:
	@if [ -z "$(VERSION)" ]; then \
		echo "usage: make release VERSION=v0.1.0" >&2; \
		exit 2; \
	fi
	@CONTEXT_VERSION="$(VERSION)" bash script/version.sh >/dev/null
	git tag "$(VERSION)"
	git push origin main
	git push origin "$(VERSION)"

status:
	git status -sb
