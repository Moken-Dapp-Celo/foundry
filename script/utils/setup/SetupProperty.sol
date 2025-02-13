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
            uri: "https://ipfs.io/ipfs/QmXiQTGp9aKAVrvCF8U7X8dnytXvf5Z44EVA2UPeTEV9gT/5.json",
            token: 0x765DE816845861e75A25fCA122bb6898B8B1282a,
            rentPerDay: 340,
            owner: 0xFb05c72178c0b88BFB8C5cFb8301e542A21aF1b7
        });
    }
}
