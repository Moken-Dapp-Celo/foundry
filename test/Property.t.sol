//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {TokenMock} from "@mocks/TokenMock.sol";
import {BookingData} from "@structs/BookingData.sol";
import {Property} from "@contracts/nft/ERC721/Property.sol";

contract PropertyTest is Test {
    TokenMock token;
    Property property;
    address owner = vm.addr(1);
    address tenant = vm.addr(4);

    function setUp() public {
        token = new TokenMock();
        token.mint(tenant, 1000000000000000000000);
        vm.prank(owner);
        property = new Property(
            "name",
            "symbol",
            "uri",
            address(token),
            100,
            owner
        );
    }

    function testUpdateUri() public {
        string
            memory newUri = "QmSnz3AgD8JACWCBnbob5UM3RSigLPaNSaiP2sWMMANUMANU";
        vm.prank(owner);
        property.updateUri(newUri);
        (string memory uri, , ) = property.property();
        assertEq(uri, newUri);
    }

    function testUpdateRentPerDay() public {
        uint256 newRentPerDay = 200;
        vm.prank(owner);
        property.updateRentPerDay(newRentPerDay);
        (, , uint256 rentPerDay) = property.property();
        assertEq(rentPerDay, newRentPerDay);
    }

    function testAddNewOwner() public {
        vm.prank(owner);
        property.addNewOwner(tenant);
        bool status = property.hasRole(property.OWNER_ROLE(), tenant);
        assertTrue(status);
    }

    function testCheckIn() public {
        uint256 day = 8;
        uint256 amount = 110;
        uint256 previousBalance = token.balanceOf(tenant);

        vm.prank(tenant);
        token.approve(address(property), amount);
        console.log(token.allowance(tenant, address(property)));

        vm.prank(tenant);
        property.booking(day, amount);

        bool success = property.checkIn(8, tenant);

        assertTrue(success);
        assertEq(token.balanceOf(tenant), previousBalance - amount);
    }
}
