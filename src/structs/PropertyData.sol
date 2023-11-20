// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {BookingData} from "@structs/BookingData.sol";

struct PropertyData {
    string uri;
    address token;
    uint256 rentPerDay;
    mapping(uint256 => BookingData) bookings;
}
