export const GluttonsABI = [
        {
            "type": "constructor",
            "inputs": [
                {
                    "name": "_dev1",
                    "type": "address",
                    "internalType": "address"
                },
                {
                    "name": "_dev2",
                    "type": "address",
                    "internalType": "address"
                }
            ],
            "stateMutability": "nonpayable"
        },
        {
            "type": "receive",
            "stateMutability": "payable"
        },
        {
            "type": "function",
            "name": "approve",
            "inputs": [
                {
                    "name": "to",
                    "type": "address",
                    "internalType": "address"
                },
                {
                    "name": "tokenId",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "outputs": [],
            "stateMutability": "payable"
        },
        {
            "type": "function",
            "name": "balanceOf",
            "inputs": [
                {
                    "name": "owner",
                    "type": "address",
                    "internalType": "address"
                }
            ],
            "outputs": [
                {
                    "name": "",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "buyFoodPackMonth",
            "inputs": [
                {
                    "name": "_user",
                    "type": "address",
                    "internalType": "address"
                }
            ],
            "outputs": [],
            "stateMutability": "payable"
        },
        {
            "type": "function",
            "name": "buyFoodPackWeek",
            "inputs": [
                {
                    "name": "_user",
                    "type": "address",
                    "internalType": "address"
                }
            ],
            "outputs": [],
            "stateMutability": "payable"
        },
        {
            "type": "function",
            "name": "castVote",
            "inputs": [
                {
                    "name": "voteToEnd",
                    "type": "bool",
                    "internalType": "bool"
                },
                {
                    "name": "tokenId",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "outputs": [],
            "stateMutability": "nonpayable"
        },
        {
            "type": "function",
            "name": "changeGameStatus",
            "inputs": [],
            "outputs": [],
            "stateMutability": "nonpayable"
        },
        {
            "type": "function",
            "name": "checkIdTokenHasVoted",
            "inputs": [
                {
                    "name": "_token",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "outputs": [
                {
                    "name": "",
                    "type": "bool",
                    "internalType": "bool"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "executeReaper",
            "inputs": [],
            "outputs": [],
            "stateMutability": "nonpayable"
        },
        {
            "type": "function",
            "name": "feedPet",
            "inputs": [
                {
                    "name": "_user",
                    "type": "address",
                    "internalType": "address"
                },
                {
                    "name": "petId",
                    "type": "uint256",
                    "internalType": "uint256"
                },
                {
                    "name": "foodId",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "outputs": [],
            "stateMutability": "nonpayable"
        },
        {
            "type": "function",
            "name": "getAlivePetCount",
            "inputs": [],
            "outputs": [
                {
                    "name": "",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "getApproved",
            "inputs": [
                {
                    "name": "tokenId",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "outputs": [
                {
                    "name": "",
                    "type": "address",
                    "internalType": "address"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "getFoodContract",
            "inputs": [],
            "outputs": [
                {
                    "name": "",
                    "type": "address",
                    "internalType": "address"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "getGameActiveStatus",
            "inputs": [],
            "outputs": [
                {
                    "name": "",
                    "type": "bool",
                    "internalType": "bool"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "getGluttonsContractBalance",
            "inputs": [],
            "outputs": [
                {
                    "name": "",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "getLasSurvivorsRecord",
            "inputs": [],
            "outputs": [
                {
                    "name": "",
                    "type": "tuple",
                    "internalType": "struct Gluttons.SurvivorRecord",
                    "components": [
                        {
                            "name": "survivors",
                            "type": "address[]",
                            "internalType": "address[]"
                        },
                        {
                            "name": "timestamp",
                            "type": "uint256",
                            "internalType": "uint256"
                        }
                    ]
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "getMaxSupply",
            "inputs": [],
            "outputs": [
                {
                    "name": "",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "stateMutability": "pure"
        },
        {
            "type": "function",
            "name": "getOracle",
            "inputs": [],
            "outputs": [
                {
                    "name": "",
                    "type": "address",
                    "internalType": "address"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "getPetInfo",
            "inputs": [
                {
                    "name": "_token",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "outputs": [
                {
                    "name": "",
                    "type": "tuple",
                    "internalType": "struct Gluttons.Pet",
                    "components": [
                        {
                            "name": "fed",
                            "type": "bool",
                            "internalType": "bool"
                        },
                        {
                            "name": "alive",
                            "type": "bool",
                            "internalType": "bool"
                        },
                        {
                            "name": "timesFed",
                            "type": "uint256",
                            "internalType": "uint256"
                        },
                        {
                            "name": "claim",
                            "type": "bool",
                            "internalType": "bool"
                        }
                    ]
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "getPetPrice",
            "inputs": [],
            "outputs": [
                {
                    "name": "",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "stateMutability": "pure"
        },
        {
            "type": "function",
            "name": "getTotalPrizePool",
            "inputs": [],
            "outputs": [
                {
                    "name": "",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "getTotalVotes",
            "inputs": [],
            "outputs": [
                {
                    "name": "",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "getlastReaperCall",
            "inputs": [],
            "outputs": [
                {
                    "name": "",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "isApprovedForAll",
            "inputs": [
                {
                    "name": "owner",
                    "type": "address",
                    "internalType": "address"
                },
                {
                    "name": "operator",
                    "type": "address",
                    "internalType": "address"
                }
            ],
            "outputs": [
                {
                    "name": "",
                    "type": "bool",
                    "internalType": "bool"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "mintPet",
            "inputs": [
                {
                    "name": "_amount",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "outputs": [],
            "stateMutability": "payable"
        },
        {
            "type": "function",
            "name": "name",
            "inputs": [],
            "outputs": [
                {
                    "name": "",
                    "type": "string",
                    "internalType": "string"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "owner",
            "inputs": [],
            "outputs": [
                {
                    "name": "",
                    "type": "address",
                    "internalType": "address"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "ownerOf",
            "inputs": [
                {
                    "name": "tokenId",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "outputs": [
                {
                    "name": "",
                    "type": "address",
                    "internalType": "address"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "renounceOwnership",
            "inputs": [],
            "outputs": [],
            "stateMutability": "nonpayable"
        },
        {
            "type": "function",
            "name": "safeTransferFrom",
            "inputs": [
                {
                    "name": "from",
                    "type": "address",
                    "internalType": "address"
                },
                {
                    "name": "to",
                    "type": "address",
                    "internalType": "address"
                },
                {
                    "name": "tokenId",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "outputs": [],
            "stateMutability": "payable"
        },
        {
            "type": "function",
            "name": "safeTransferFrom",
            "inputs": [
                {
                    "name": "from",
                    "type": "address",
                    "internalType": "address"
                },
                {
                    "name": "to",
                    "type": "address",
                    "internalType": "address"
                },
                {
                    "name": "tokenId",
                    "type": "uint256",
                    "internalType": "uint256"
                },
                {
                    "name": "_data",
                    "type": "bytes",
                    "internalType": "bytes"
                }
            ],
            "outputs": [],
            "stateMutability": "payable"
        },
        {
            "type": "function",
            "name": "setApprovalForAll",
            "inputs": [
                {
                    "name": "operator",
                    "type": "address",
                    "internalType": "address"
                },
                {
                    "name": "approved",
                    "type": "bool",
                    "internalType": "bool"
                }
            ],
            "outputs": [],
            "stateMutability": "nonpayable"
        },
        {
            "type": "function",
            "name": "setFoodContract",
            "inputs": [
                {
                    "name": "_foodContract",
                    "type": "address",
                    "internalType": "address"
                }
            ],
            "outputs": [],
            "stateMutability": "nonpayable"
        },
        {
            "type": "function",
            "name": "setOracle",
            "inputs": [
                {
                    "name": "_oracle",
                    "type": "address",
                    "internalType": "address"
                }
            ],
            "outputs": [],
            "stateMutability": "nonpayable"
        },
        {
            "type": "function",
            "name": "supportsInterface",
            "inputs": [
                {
                    "name": "interfaceId",
                    "type": "bytes4",
                    "internalType": "bytes4"
                }
            ],
            "outputs": [
                {
                    "name": "",
                    "type": "bool",
                    "internalType": "bool"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "symbol",
            "inputs": [],
            "outputs": [
                {
                    "name": "",
                    "type": "string",
                    "internalType": "string"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "tokenURI",
            "inputs": [
                {
                    "name": "tokenId",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "outputs": [
                {
                    "name": "",
                    "type": "string",
                    "internalType": "string"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "totalSupply",
            "inputs": [],
            "outputs": [
                {
                    "name": "result",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "stateMutability": "view"
        },
        {
            "type": "function",
            "name": "transferFrom",
            "inputs": [
                {
                    "name": "from",
                    "type": "address",
                    "internalType": "address"
                },
                {
                    "name": "to",
                    "type": "address",
                    "internalType": "address"
                },
                {
                    "name": "tokenId",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ],
            "outputs": [],
            "stateMutability": "payable"
        },
        {
            "type": "function",
            "name": "transferOwnership",
            "inputs": [
                {
                    "name": "newOwner",
                    "type": "address",
                    "internalType": "address"
                }
            ],
            "outputs": [],
            "stateMutability": "nonpayable"
        },
        {
            "type": "function",
            "name": "withdrawDevShare",
            "inputs": [],
            "outputs": [],
            "stateMutability": "nonpayable"
        },
        {
            "type": "event",
            "name": "Approval",
            "inputs": [
                {
                    "name": "owner",
                    "type": "address",
                    "indexed": true,
                    "internalType": "address"
                },
                {
                    "name": "approved",
                    "type": "address",
                    "indexed": true,
                    "internalType": "address"
                },
                {
                    "name": "tokenId",
                    "type": "uint256",
                    "indexed": true,
                    "internalType": "uint256"
                }
            ],
            "anonymous": false
        },
        {
            "type": "event",
            "name": "ApprovalForAll",
            "inputs": [
                {
                    "name": "owner",
                    "type": "address",
                    "indexed": true,
                    "internalType": "address"
                },
                {
                    "name": "operator",
                    "type": "address",
                    "indexed": true,
                    "internalType": "address"
                },
                {
                    "name": "approved",
                    "type": "bool",
                    "indexed": false,
                    "internalType": "bool"
                }
            ],
            "anonymous": false
        },
        {
            "type": "event",
            "name": "ConsecutiveTransfer",
            "inputs": [
                {
                    "name": "fromTokenId",
                    "type": "uint256",
                    "indexed": true,
                    "internalType": "uint256"
                },
                {
                    "name": "toTokenId",
                    "type": "uint256",
                    "indexed": false,
                    "internalType": "uint256"
                },
                {
                    "name": "from",
                    "type": "address",
                    "indexed": true,
                    "internalType": "address"
                },
                {
                    "name": "to",
                    "type": "address",
                    "indexed": true,
                    "internalType": "address"
                }
            ],
            "anonymous": false
        },
        {
            "type": "event",
            "name": "Dead",
            "inputs": [
                {
                    "name": "petId",
                    "type": "uint256",
                    "indexed": true,
                    "internalType": "uint256"
                }
            ],
            "anonymous": false
        },
        {
            "type": "event",
            "name": "Fed",
            "inputs": [
                {
                    "name": "petId",
                    "type": "uint256",
                    "indexed": true,
                    "internalType": "uint256"
                }
            ],
            "anonymous": false
        },
        {
            "type": "event",
            "name": "GameEndedByExtinction",
            "inputs": [
                {
                    "name": "amountUsers",
                    "type": "uint256",
                    "indexed": false,
                    "internalType": "uint256"
                }
            ],
            "anonymous": false
        },
        {
            "type": "event",
            "name": "GameEndedBySingleSurvivor",
            "inputs": [
                {
                    "name": "users",
                    "type": "address",
                    "indexed": false,
                    "internalType": "address"
                }
            ],
            "anonymous": false
        },
        {
            "type": "event",
            "name": "GameEndedByVote",
            "inputs": [
                {
                    "name": "amountUsers",
                    "type": "uint256",
                    "indexed": false,
                    "internalType": "uint256"
                }
            ],
            "anonymous": false
        },
        {
            "type": "event",
            "name": "OwnershipTransferred",
            "inputs": [
                {
                    "name": "previousOwner",
                    "type": "address",
                    "indexed": true,
                    "internalType": "address"
                },
                {
                    "name": "newOwner",
                    "type": "address",
                    "indexed": true,
                    "internalType": "address"
                }
            ],
            "anonymous": false
        },
        {
            "type": "event",
            "name": "PrizeClaimed",
            "inputs": [
                {
                    "name": "winner",
                    "type": "address",
                    "indexed": true,
                    "internalType": "address"
                },
                {
                    "name": "amount",
                    "type": "uint256",
                    "indexed": false,
                    "internalType": "uint256"
                }
            ],
            "anonymous": false
        },
        {
            "type": "event",
            "name": "Starved",
            "inputs": [
                {
                    "name": "petId",
                    "type": "uint256",
                    "indexed": true,
                    "internalType": "uint256"
                }
            ],
            "anonymous": false
        },
        {
            "type": "event",
            "name": "SurvivorRecordUpdated",
            "inputs": [],
            "anonymous": false
        },
        {
            "type": "event",
            "name": "Transfer",
            "inputs": [
                {
                    "name": "from",
                    "type": "address",
                    "indexed": true,
                    "internalType": "address"
                },
                {
                    "name": "to",
                    "type": "address",
                    "indexed": true,
                    "internalType": "address"
                },
                {
                    "name": "tokenId",
                    "type": "uint256",
                    "indexed": true,
                    "internalType": "uint256"
                }
            ],
            "anonymous": false
        },
        {
            "type": "event",
            "name": "VoteReset",
            "inputs": [],
            "anonymous": false
        },
        {
            "type": "error",
            "name": "ApprovalCallerNotOwnerNorApproved",
            "inputs": []
        },
        {
            "type": "error",
            "name": "ApprovalQueryForNonexistentToken",
            "inputs": []
        },
        {
            "type": "error",
            "name": "BalanceQueryForZeroAddress",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__AddressAlreadyClaimed",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__AlreadyClaimedPrice",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__AlreadyVoted",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__FeedingFailed",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__FoodContractAddressAlreadySet",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__FoodPurchaseFailed",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__GameEnded",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__GameStillActive",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__IncorrectEthAmount",
            "inputs": [
                {
                    "name": "amount",
                    "type": "uint256",
                    "internalType": "uint256"
                }
            ]
        },
        {
            "type": "error",
            "name": "Gluttons__InsuficientBalanceInContract",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__MaxSupplyReachedOrAmountExceeds",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__MintedAmountNotReached",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__NoSurvivors",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__NotASurvivor",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__NotInLastSurvivorsSet",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__NotOracleCalling",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__NotTheOwnerOfTheToken",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__PetAlreadyFed",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__PetIsDead",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__ThereAreMoreOrNoSurvivors",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__ThereAreSurvivors",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__TooEarly",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__TraitsAlreadyLocked",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__WithdrawTransferFailed",
            "inputs": []
        },
        {
            "type": "error",
            "name": "Gluttons__ZeroValueToTransfer",
            "inputs": []
        },
        {
            "type": "error",
            "name": "MintERC2309QuantityExceedsLimit",
            "inputs": []
        },
        {
            "type": "error",
            "name": "MintToZeroAddress",
            "inputs": []
        },
        {
            "type": "error",
            "name": "MintZeroQuantity",
            "inputs": []
        },
        {
            "type": "error",
            "name": "NotCompatibleWithSpotMints",
            "inputs": []
        },
        {
            "type": "error",
            "name": "OwnableInvalidOwner",
            "inputs": [
                {
                    "name": "owner",
                    "type": "address",
                    "internalType": "address"
                }
            ]
        },
        {
            "type": "error",
            "name": "OwnableUnauthorizedAccount",
            "inputs": [
                {
                    "name": "account",
                    "type": "address",
                    "internalType": "address"
                }
            ]
        },
        {
            "type": "error",
            "name": "OwnerQueryForNonexistentToken",
            "inputs": []
        },
        {
            "type": "error",
            "name": "OwnershipNotInitializedForExtraData",
            "inputs": []
        },
        {
            "type": "error",
            "name": "ReentrancyGuardReentrantCall",
            "inputs": []
        },
        {
            "type": "error",
            "name": "SequentialMintExceedsLimit",
            "inputs": []
        },
        {
            "type": "error",
            "name": "SequentialUpToTooSmall",
            "inputs": []
        },
        {
            "type": "error",
            "name": "SpotMintTokenIdTooSmall",
            "inputs": []
        },
        {
            "type": "error",
            "name": "TokenAlreadyExists",
            "inputs": []
        },
        {
            "type": "error",
            "name": "TransferCallerNotOwnerNorApproved",
            "inputs": []
        },
        {
            "type": "error",
            "name": "TransferFromIncorrectOwner",
            "inputs": []
        },
        {
            "type": "error",
            "name": "TransferToNonERC721ReceiverImplementer",
            "inputs": []
        },
        {
            "type": "error",
            "name": "TransferToZeroAddress",
            "inputs": []
        },
        {
            "type": "error",
            "name": "URIQueryForNonexistentToken",
            "inputs": []
        }
    ]