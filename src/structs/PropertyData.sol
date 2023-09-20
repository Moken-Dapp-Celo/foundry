// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {BookingData} from "@structs/BookingData.sol";

struct PropertyData {
    string uri;
    uint256 rentPerDay;
    string description;
    address propertyOwner;
    string propertyType;
    string realWorldAddress;
    address blockchainAddress;
    mapping(uint256 => BookingData) bookings;
}
