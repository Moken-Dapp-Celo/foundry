// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {PropertyType} from "@enums/PropertyType.sol";
import {PropertyData} from "@structs/PropertyData.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Property is ERC721, ERC721URIStorage, Ownable, AccessControl {
    using Counters for Counters.Counter;

    PropertyData public property;

    Counters.Counter private _tokenIdCounter;

    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

    event NewBooking(uint256 day, address tenant);
    event BookingError(uint256 day, address tenant);

    event CheckIn(uint256 day, address tenant);
    event CheckInError(uint256 day, address tenant);

    error CheckInFailed(uint256 day, address tenant);
    error BookingFailed(uint256 day, address tenant);
    error InvalidValueForRent(uint256 day, address tenant, uint256 value);

    constructor(
        string memory _uri,
        uint256 _rentPerDay,
        string memory _description,
        PropertyType _propertyType,
        address _propertyOwner,
        string memory _realWorldAddress
    ) ERC721("MyToken", "MTK") {
        property.uri = _uri;
        property.rentPerDay = _rentPerDay;
        property.description = _description;
        property.propertyOwner = _propertyOwner;
        property.propertyType = _propertyType;
        property.realWorldAddress = _realWorldAddress;
        property.blockchainAddress = address(this);
        _grantRole(DEFAULT_ADMIN_ROLE, _propertyOwner);
        _grantRole(OWNER_ROLE, _propertyOwner);
    }

    function addNewOwner(address _newOwner) public onlyRole(OWNER_ROLE) {
        _grantRole(OWNER_ROLE, _newOwner);
    }

    function booking(uint256 _day) public payable {
        if (msg.value != property.rentPerDay) {
            emit BookingError(_day, msg.sender);
            revert InvalidValueForRent(_day, msg.sender, msg.value);
        }

        if (property.bookings[_day].status == true) {
            emit BookingError(_day, msg.sender);
            revert BookingFailed(_day, msg.sender);
        }

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, property.uri);

        emit NewBooking(_day, msg.sender);
    }

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function updateUri(string memory _uri) public onlyRole(OWNER_ROLE) {
        property.uri = _uri;
    }

    function updateRentPerDay(uint256 _rentPerDay) public onlyRole(OWNER_ROLE) {
        property.rentPerDay = _rentPerDay;
    }

    function checkIn(uint256 day, address _tenant) public {
        if (property.bookings[day].tenant == _tenant) {
            emit CheckIn(day, _tenant);
        } else {
            emit CheckInError(day, _tenant);
            revert CheckInFailed(day, _tenant);
        }
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
