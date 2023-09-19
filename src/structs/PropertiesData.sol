// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {PropertyType} from "@enums/PropertyType.sol";

struct PropertiesData {
    string uri;
    uint256 rentPerDay;
    string description;
    address propertyOwner;
    PropertyType propertyType;
    string realWorldAddress;
    address blockchainAddress;
}
