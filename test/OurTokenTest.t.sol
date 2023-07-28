// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;
  

    address heivans = makeAddr("heivans");
    address ezzy = makeAddr("ezzy");
    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() external {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);

        ourToken.transfer(heivans, STARTING_BALANCE);
    }

    function testHeivansBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(heivans));
    }
    function testAllowancesworks() public {
        uint256 initialAllowances = 1000;

        // heivans approves ezzy to spend tokens on hs behalf

        vm.prank(heivans);

        ourToken.approve(ezzy, initialAllowances);

        uint256  transferAmount = 500;
        vm.prank(ezzy);

        ourToken.transferFrom(heivans, ezzy, transferAmount );
        assertEq(ourToken.balanceOf(ezzy), transferAmount);
        assertEq(ourToken.balanceOf(heivans), STARTING_BALANCE - transferAmount);



    }
      function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(ourToken)).mint(address(this), 1);
    }

    
    
}
