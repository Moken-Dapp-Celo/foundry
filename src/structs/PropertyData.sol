// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {PropertyType} from "@enums/PropertyType.sol";
import {BookingData} from "@structs/BookingData.sol";

struct PropertyData {
    string uri;
    uint256 rentPerDay;
    string description;
    address propertyOwner;
    PropertyType propertyType;
    string realWorldAddress;
    address blockchainAddress;
    mapping(uint256 => BookingData) bookings;
}