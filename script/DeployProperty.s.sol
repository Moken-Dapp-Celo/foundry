// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Moken} from "@contracts/factory/Moken.sol";
import {SetupProperty} from "@setup/SetupProperty.sol";

contract DeployLilium is Script {
    SetupProperty helperConfig = new SetupProperty();

    function run() external {
        (
            string memory _uri,
            uint256 _rentPerDay,
            string memory _description,
            address _propertyOwner,
            string memory _propertyType,
            string memory _realWorldAddress
        ) = helperConfig.propertyArgs();

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Moken moken = new Moken();
        address property = moken.newProperty(
            _uri,
            _rentPerDay,
            _description,
            _propertyType,
            _propertyOwner,
            _realWorldAddress
        );
        vm.stopBroadcast();
        console.log("Moken address:", address(moken), "Property address:", property);
    }
}
