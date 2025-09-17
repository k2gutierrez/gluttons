-include .env

.PHONY:; all test deploy

build :; forge build

solxbuild :; FOUNDRY_PROFILE=solx forge build

test :; forge test

solxtest :; FOUNDRY_PROFILE=solx forge test

install :; forge install cyfrin/foundry-devops && forge install foundry-rs/forge-std && forge install openzeppelin/openzeppelin-contracts && forge install chiru-labs/ERC721A

solx-deploy-gluttons-curtis :
	@FOUNDRY_PROFILE=solx forge script script/DeployGluttons.s.sol:DeployGluttons --rpc-url $(CURTIS_RPC_URL) --account defaultk2 --broadcast -vvvv

deploy-gluttons-curtis :
	@forge script script/DeployGluttons.s.sol:DeployGluttons --rpc-url $(CURTIS_RPC_URL) --account defaultk2 --broadcast -vvvv

deploy-gluttons :
	@FOUNDRY_PROFILE=solx forge script script/DeployGluttons.s.sol:DeployGluttons --rpc-url $(APECHAIN_RPC_URL) --account defaultk2 --broadcast -vvvv

deploy-game-curtis :
	@forge script script/DeployGame.s.sol:DeployGameWithContracts --rpc-url $(CURTIS_RPC_URL) --account defaultk2 --broadcast -vvvv

sepolia-json :; forge verify-contract $(CAVA_CONTRACT_ADDRESS) src/Cava.sol:Cava --etherscan-api-key $(ETHERSCAN_API_KEY) --rpc-url $(SEPOLIA_RPC_URL) --show-standard-json-input > json.json

gluttons-verify-curtis :; forge verify-contract --constructor-args $(ENCODE_GLUTTONS_CONSTURCTOR) $(GLUTTONS_CURTIS) src/Gluttons.sol:Gluttons --chain-id 33111 --verifier-url $(APESCAN_CURTIS_API_KEY) # cast abi-encode "constructor(address,address)" 0xca067E20db2cDEF80D1c7130e5B71C42c0305529 0xbfAb062f38dd327c823e747C8Cd97853B7114241

gluttons-food-verify-curtis :; forge verify-contract --constructor-args $(ENCODE_GLUTTONS_FOOD_CONSTRUCTOR) $(GLUTTONS_FOOD_CURTIS) src/GluttonsFood.sol:GluttonsFood --chain-id 33111 --verifier-url $(APESCAN_CURTIS_API_KEY) # cast abi-encode "constructor(address,address)" 0xca067E20db2cDEF80D1c7130e5B71C42c0305529 0xbfAb062f38dd327c823e747C8Cd97853B7114241

gluttons-curtis-json :; forge verify-contract $(GLUTTONS_CURTIS) src/Gluttons.sol:Gluttons --etherscan-api-key $(APESCAN_API_KEY) --rpc-url $(CURTIS_RPC_URL) --watch #--show-standard-json-input > json.json

coverage-report :; forge coverage --report debug > coverage.txt

coverage :; forge coverage

set-traits-gluttons-curtis :
	@forge script script/Interactions.s.sol:SetTraits --rpc-url $(CURTIS_RPC_URL) --account defaultk2 --broadcast -vvvv

mint-gluttons-curtis :
	@forge script script/Interactions.s.sol:MintBasicNFT --rpc-url $(CURTIS_RPC_URL) --account defaultk2 --broadcast -vvv

mingle-balanceof :; cast call $(MINGLE_CURTIS) "balanceOf(address)(uint256)" 0xca067E20db2cDEF80D1c7130e5B71C42c0305529 --rpc-url $(CURTIS_RPC_URL) -vvvv