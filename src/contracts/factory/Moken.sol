// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Property} from "@contracts/nft/ERC721/Property.sol";

contract Moken {
    address[] public properties;

    event NewProperty(address indexed property, address indexed owner);

    function newProperty(
        string memory _name,
        string memory _symbol,
        string calldata _uri,
        address _token,
        uint256 _rentPerDay,
        address _owner
    ) public returns (address) {
        Property property = new Property(
            _name,
            _symbol,
            _uri,
            _token,
            _rentPerDay,
            _owner
        );
        properties.push(address(property));
        emit NewProperty(address(property), _owner);
        return address(property);
    }

    function getAllProperties() public view returns (address[] memory) {
        return properties;
    }
}
