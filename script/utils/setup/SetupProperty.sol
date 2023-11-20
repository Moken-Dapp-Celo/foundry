// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {PropertyArgs} from "@utils/storage/PropertyArgs.sol";

contract SetupProperty is Script {
    PropertyArgs public propertyArgs;

    mapping(uint256 => PropertyArgs) public chainIdToNetworkConfig;

    constructor() {
        chainIdToNetworkConfig[44787] = getCeloPropertyArgs();
        propertyArgs = chainIdToNetworkConfig[block.chainid];
    }

    function getCeloPropertyArgs()
        internal
        pure
        returns (PropertyArgs memory celoPropertyArgs)
    {
        celoPropertyArgs = PropertyArgs({
            name: "Moken Property",
            symbol: "MKP",
            uri: "QmSnz3AgD8JACWCBnbob5UM3RSigLPaNSaiP2sWMUf4TPM",
            token: address(0),
            rentPerDay: 1000,
            owner: 0xFb05c72178c0b88BFB8C5cFb8301e542A21aF1b7
        });
    }
}
