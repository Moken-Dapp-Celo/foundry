// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {BookingData} from "@structs/BookingData.sol";

struct PropertyArgs {
    string name;
    string symbol;
    string uri;
    address token;
    uint256 rentPerDay;
    address owner;
}
