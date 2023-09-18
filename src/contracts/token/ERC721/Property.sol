// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {PropertyType} from "@enums/PropertyType.sol";
import {PropertyData} from "@structs/PropertyData.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyToken is ERC721, ERC721URIStorage, Ownable, AccessControl {
    using Counters for Counters.Counter;

    PropertyData public property;

    Counters.Counter private _tokenIdCounter;

    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

    error bookingFailed(uint256 day, address tenant);
    error invalidValueForRent(uint256 day, address tenant, uint256 value);

    constructor(string memory _uri, uint256 _rentPerDay, string memory _description, PropertyType _propertyType, address _propertyOwner, string memory _realWorldAddress) ERC721("MyToken", "MTK") {
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
            revert invalidValueForRent(_day, msg.sender, msg.value);
        }

        if (property.bookings[_day].status == true) {
            revert bookingFailed(_day, msg.sender);
        }

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, property.uri);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function updateUri(string memory _uri) public onlyRole(OWNER_ROLE) {
        property.uri = _uri;
    }

    function updateRentPerDay(uint256 _rentPerDay) public onlyRole(OWNER_ROLE) {
        property.rentPerDay = _rentPerDay;
    }

    function checkHosting(uint256 day, address _tenant) public view returns (bool) {
        if (property.bookings[day].tenant == _tenant){
            return true;
        } else {
            return false;
        }
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}