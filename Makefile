LOCAL_TUIST := .tuist-bin/tuist
SWIFTLINT := Tuist/.build/artifacts/swiftlintplugins/SwiftLintBinary/SwiftLintBinary.artifactbundle/macos/swiftlint

# Use local binary if available, otherwise fall back to global tuist on PATH
ifeq ($(wildcard $(LOCAL_TUIST)),)
TUIST := tuist
else
TUIST := $(LOCAL_TUIST)
endif

.DEFAULT_GOAL := generate

.PHONY: setup generate test lint lint-fix format install-tools clean bootstrap feature client help

## First-time setup: install tools, download/link Tuist, generate Xcode project
setup: install-tools bootstrap
	$(TUIST) install
	$(TUIST) generate --no-open

## Download or link Tuist binary to .tuist-bin/
bootstrap:
	@bash scripts/bootstrap.sh

## Scaffold a new feature: make feature NAME=Start  →  creates StartFeature
feature:
	@bash scripts/new-feature.sh $(NAME)

## Scaffold a new dependency client: make client NAME=Location [FEATURE=AppFeature]
client:
	@bash scripts/new-client.sh $(NAME) $(FEATURE)

## Regenerate Xcode project after any Project.swift or Package.swift change
generate:
	$(TUIST) generate

## Run all unit tests
test:
	$(TUIST) test

## Run tests for a specific scheme: make test-scheme SCHEME=AppFeatureTests
test-scheme:
	$(TUIST) test $(SCHEME)

## Run SwiftLint across the project (requires: make setup first)
lint:
	@$(SWIFTLINT) lint --strict

## Auto-fix SwiftLint violations
lint-fix:
	@$(SWIFTLINT) lint --fix

## Auto-format code with SwiftFormat (2-space indent)
format: install-tools
	swiftformat App Features

## Install development tools: SwiftFormat
install-tools:
	@command -v swiftformat &>/dev/null || brew install swiftformat

## Remove generated Xcode project and build artifacts
clean:
	$(TUIST) clean
	find . -maxdepth 4 \( -name "*.xcodeproj" -o -name "*.xcworkspace" \) \
		-not -path "*/.tuist-bin/*" -exec rm -rf {} + 2>/dev/null || true
	rm -rf .build

## Remove downloaded Tuist binary (forces re-download on next setup)
clean-tools:
	rm -rf .tuist-bin

help:
	@grep -E '^##' Makefile | sed 's/## //'
