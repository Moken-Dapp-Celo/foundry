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
        address moken = 0x0002Af258b86fAAC590630BB2a07740576E134b8;

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        address property = Moken(moken).newProperty(_name, _symbol, _uri, _token, _rentPerDay, _owner);
        console.log("Property address:", property);
    }
}
