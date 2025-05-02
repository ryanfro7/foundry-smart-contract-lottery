-include .env
.PHONY: all test deploy fund help install snapshot format anvil

help:
	@echo "Usage:"
	@echo " make deploy [ARGS=...]"

build:; forge build

test:; forge test

install:; forge install Cyfrin/foundry-devops@0.1.0 --no-commit && forge install smartcontractkit/chainlink@42c74fcd30969bca26a9aadc07463d1c2f473b8c --no-commit && forge install foundry-rs/forge-std@v1.7.0 --no-commit && forge install transmissions11/solmate@v6 --no-commit

deploy-sepolia:
	 @dotenv forge script script/DeployRaffle.s.sol:DeployRaffle --rpc-url $(SEPOLIA_RPC_URL) --account default --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

deploy-anvil:
    @anvil --chain-id 31337 --silent & \
    sleep 2 && \
    dotenv forge script script/DeployRaffle.s.sol:DeployRaffle --rpc-url http://127.0.0.1:8545 --broadcast -vvvv