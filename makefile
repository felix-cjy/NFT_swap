# Makefile for NFTswap contract

# Check for FOUNDRY_BIN environment variable
ifndef FOUNDRY_BIN
  # If not set, try to find forge in PATH
  FOUNDRY_BIN := $(shell which forge 2>/dev/null)
  ifndef FOUNDRY_BIN
    # If still not found, use a default path
    FOUNDRY_BIN := $(HOME)/.foundry/bin
  endif
endif

# Set the paths for Foundry tools
FORGE := $(FOUNDRY_BIN)/forge
ANVIL := $(FOUNDRY_BIN)/anvil
CAST := $(FOUNDRY_BIN)/cast

# Contract and test file paths
CONTRACT := src/NFTswap.sol
TEST_UNIT := test/NFTswapTest.t.sol
TEST_INTEGRATION := test/NFTswapIntegration.t.sol

# Default target
all: test

# Compile the contract
build:
	@echo "Compiling NFTswap contract..."
	@"$(FORGE)" build --contracts $(CONTRACT)

# Run unit tests
test-unit: build
	@echo "Running NFTswap unit tests..."
	@"$(FORGE)" test --match-contract NFTswapTest -vvv

# Run integration tests
test-integration: build
	@echo "Running NFTswap integration tests..."
	@"$(FORGE)" test --match-contract NFTswapIntegrationTest -vvv

# Run all tests
test: test-unit test-integration

# Run tests with gas report
test-gas: build
	@echo "Running NFTswap tests with gas report..."
	@"$(FORGE)" test --match-path "test/NFTswap*.t.sol" --gas-report

# Start Anvil node
anvil:
	@echo "Starting Anvil node..."
	@"$(ANVIL)" > anvil.log 2>&1 & echo $$! > anvil.pid

# Stop Anvil node
stop-anvil:
	@if [ -f anvil.pid ]; then \
		echo "Stopping Anvil node..."; \
		kill `cat anvil.pid`; \
		rm anvil.pid; \
	else \
		echo "Anvil is not running."; \
	fi

# Deploy to Anvil (local testnet)
deploy-anvil: build
	@echo "Deploying NFTswap to Anvil..."
	@"$(FORGE)" script script/DeployNFTswap.s.sol --rpc-url http://localhost:8545 --broadcast

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@"$(FORGE)" clean

# Help command
help:
	@echo "Available targets:"
	@echo "  build            - Compile the NFTswap contract"
	@echo "  test-unit        - Run unit tests for NFTswap"
	@echo "  test-integration - Run integration tests for NFTswap"
	@echo "  test             - Run all tests for NFTswap"
	@echo "  test-gas         - Run tests with gas report"
	@echo "  anvil            - Start Anvil node"
	@echo "  stop-anvil       - Stop Anvil node"
	@echo "  deploy-anvil     - Deploy NFTswap to Anvil"
	@echo "  clean            - Clean build artifacts"
	@echo ""
	@echo "Note: You can set the FOUNDRY_BIN environment variable to specify the Foundry binaries location."

.PHONY: all build test-unit test-integration test test-gas anvil stop-anvil deploy-anvil clean help