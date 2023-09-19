// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {PropertyType} from "@enums/PropertyType.sol";
import {PropertiesData} from "@structs/PropertiesData.sol";
import {Property} from "@contracts/token/ERC721/Property.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";

contract Moken {
    using Counters for Counters.Counter;

    Counters.Counter public _propertyCounter;

    address[] public properties;

    event NewProperty(address indexed newMyTokenAddress, address indexed owner);

    function newProperty(
        string memory _uri,
        uint256 _rentPerDay,
        string memory _description,
        PropertyType _propertyType,
        address _propertyOwner,
        string memory _realWorldAddress
    ) public returns (address) {
        Property property = new Property(
            _uri,
            _rentPerDay,
            _description,
            _propertyType,
            _propertyOwner,
            _realWorldAddress
        );
        properties.push(address(property));
        _propertyCounter.increment();
        emit NewProperty(address(property), _propertyOwner);
        return address(property);
    }

    function getPropertyCounter() public view returns (uint256) {
        return _propertyCounter.current();
    }
}
