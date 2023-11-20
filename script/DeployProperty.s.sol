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
            string memory _name,
            string memory _symbol,
            string memory _uri,
            address _token,
            uint256 _rentPerDay,
            address _owner
        ) = helperConfig.propertyArgs();

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        Moken moken = new Moken();
        address property = moken.newProperty(
            _name,
            _symbol,
            _uri,
            _token,
            _rentPerDay,
            _owner
        );
        vm.stopBroadcast();
        console.log("Moken address:", address(moken), "Property address:", property);
    }
}
