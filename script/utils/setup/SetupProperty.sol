// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {PropertyType} from "@enums/PropertyType.sol";
import {PropertyArgs} from "@utils/storage/PropertyArgs.sol";

contract SetupProperty is Script {
    PropertyArgs public propertyArgs;

    mapping(uint256 => PropertyArgs) public chainIdToNetworkConfig;

    constructor() {
        chainIdToNetworkConfig[383414847825] = getZeniqPropertyArgs();
        propertyArgs = chainIdToNetworkConfig[block.chainid];
    }

    function getZeniqPropertyArgs()
        internal
        pure
        returns (PropertyArgs memory zeniqPropertyArgs)
    {
        zeniqPropertyArgs = PropertyArgs({
            uri: "QmSnz3AgD8JACWCBnbob5UM3RSigLPaNSaiP2sWMUf4TPM",
            rentPerDay: 200, 
            description: "Room Size: 593 sq.ft. / 55 sq.m; Bed Type: One King Bed", 
            propertyOwner: 0xB847c0d4f2508373CdF06Cc1988a403C705aF6fb, 
            propertyType: PropertyType.HOUSE, 
            realWorldAddress: "Av. Atlantica, 4240 - Copacabana, Rio de Janeiro - RJ, 22070-002"
        });
    }
}
