// //SPDX-License-Identifier: MIT
// pragma solidity 0.8.19;

// import {Test} from "forge-std/Test.sol";
// import {BookingData} from "@structs/BookingData.sol";
// import {console} from "forge-std/console.sol";
// import {Property} from "@contracts/token/ERC721/Property.sol";


// contract PropertyTest is Test {

//     address guest = vm.addr(1);
//     Property property;

//     function setUp() public {
//         property = new Property("QmSnz3AgD8JACWCBnbob5UM3RSigLPaNSaiP2sWMUf4TPM", 1, "Room Size: 593 sq.ft. / 55 sq.m; Bed Type: One King Bed", "house",0xB847c0d4f2508373CdF06Cc1988a403C705aF6fb, "Av. Atlantica, 4240 - Copacabana, Rio de Janeiro - RJ, 22070-002");
//     }

//     function testCheckIn() public {
//         vm.prank(guest);
//         property.booking(8);


//         bool success = property.checkIn(8, guest);
//         BookingData memory result = property.bookings(8).tenant;
//         console.log(result);
//         assertTrue(success);
//     }
// }