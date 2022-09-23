// SPDX-License-Identifier: NONE
pragma solidity 0.8.12;

contract KillMe {
    constructor(address payable _vault) payable {
        selfdestruct(_vault);
    }
}