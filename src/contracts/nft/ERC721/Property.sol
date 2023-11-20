// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {BookingData} from "@structs/BookingData.sol";
import {PropertyData} from "@structs/PropertyData.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Property is ERC721, ERC721URIStorage, Ownable, AccessControl {
    using Counters for Counters.Counter;

    PropertyData public property;

    Counters.Counter private _tokenIdCounter;

    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");

    event NewBooking(uint256 day, address tenant);
    event CheckIn(uint256 day, address tenant);

    error WithdrawFailed(address owner, uint256 amount);
    error GrantAllowanceFailed(address sender, uint256 amount);
    error CheckInFailed(uint256 day, address tenant);
    error BookingFailed(address tenant, uint256 day, uint256 amount);

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _uri,
        address _token,
        uint256 _rentPerDay,
        address _owner
    ) ERC721(_name, _symbol) {
        property.uri = _uri;
        property.token = _token;
        property.rentPerDay = _rentPerDay;
        _grantRole(DEFAULT_ADMIN_ROLE, _owner);
        _grantRole(OWNER_ROLE, _owner);
    }

    function updateUri(string memory _uri) public onlyRole(OWNER_ROLE){
        property.uri = _uri;
    }

    function updateRentPerDay(uint256 _rentPerDay) public onlyRole(OWNER_ROLE){
        property.rentPerDay = _rentPerDay;
    }

    function addNewOwner(address _newOwner) public onlyRole(OWNER_ROLE) {
        _grantRole(DEFAULT_ADMIN_ROLE, _newOwner);
        _grantRole(OWNER_ROLE, _newOwner);
    }

    function booking(uint256 _day, uint256 _amount) public {
        if (property.bookings[_day].status == true || _amount < property.rentPerDay) {
            revert BookingFailed(msg.sender, _day, _amount);
        }

        bool success = IERC20(property.token).transferFrom(
            msg.sender,
            address(this),
            _amount
        );

        if (!success) {
            revert BookingFailed(msg.sender, _day, _amount);
        } else {
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(msg.sender, tokenId);
            _setTokenURI(tokenId, property.uri);
            property.bookings[_day] = BookingData({
                tenant: msg.sender,
                status: true
            });
            emit NewBooking(_day, msg.sender);
        }
    }

    function checkIn(uint256 day, address _tenant) public view returns (bool) {
        return property.bookings[day].tenant == _tenant;
    }

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
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

    function withdraw() public onlyRole(OWNER_ROLE) {
        uint256 _balance = IERC20(property.token).balanceOf(address(this));
        bool success = IERC20(property.token).transfer(msg.sender, _balance);
        if (!success) {
            revert WithdrawFailed(msg.sender, _balance);
        }
    }
}
