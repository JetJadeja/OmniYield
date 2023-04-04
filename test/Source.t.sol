// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "../src/Source.sol";
import "solmate/test/utils/mocks/MockERC20.sol";

import "./mocks/MockStargateRouter.sol";
import "./mocks/MockLzEndpoint.sol";

contract SourceTest {
    Source source;
    MockERC20 token;
    MockStargateRouter stargateRouter;
    MockLzEndpoint lzEndpoint;

    /// @dev Deploy the Source contract before running tests
    function beforeEach() public {
        token = new MockERC20("Mock Token", "MTK", 18);
        stargateRouter = new MockStargateRouter();
        lzEndpoint = new MockLzEndpoint();
        source = new Source(address(lzEndpoint), 1, 1, 1, address(this), token, stargateRouter);
    }

    /// @dev Test that depositing tokens works as expected
    function testDeposit() public {
        // Set up
        uint256 depositAmount = 100 * (10 ** 18);
        token.mint(address(this), depositAmount);
        token.approve(address(source), depositAmount);

        // Deposit
        source.deposit{value: 1 ether}(depositAmount);

        // Assertions
        Assert.equal(token.balanceOf(address(source)), depositAmount, "Token balance should be updated");
    }

    /// @dev Test that depositing without enough tokens fails
    function testDepositFail() public {
        // Set up
        uint256 depositAmount = 100 * (10 ** 18);
        token.mint(address(this), depositAmount / 2);
        token.approve(address(source), depositAmount);

        // Expect a revert due to insufficient balance
        try source.deposit{value: 1 ether}(depositAmount) {
            Assert.ok(false, "Expected deposit to fail");
        } catch Error(string memory reason) {
            Assert.equal(reason, "ERC20: transfer amount exceeds balance", "Unexpected error reason");
        }
    }

    /// @dev Test that withdrawing tokens works as expected
    function testWithdraw() public {
        // Set up
        uint256 depositAmount = 100 * (10 ** 18);
        token.mint(address(this), depositAmount);
        token.approve(address(source), depositAmount);
        source.deposit{value: 1 ether}(depositAmount);

        // Withdraw
        source.withdraw{value: 1 ether}(depositAmount);

        // Assertions
        // Add assertions based on the expected outcome of the withdrawal operation
    }

    /// @dev Test that estimating fees works correctly
    function testEstimateFee() public {
        // Set up
        bytes memory payload = "";
        bytes memory adapterParams = "";

        // Call estimateFee
        (uint256 nativeFee, uint256 zroFee) = source.estimateFee(1, false, payload, adapterParams);

        // Assertions
        // Add assertions based on the expected fees returned by the mocked lzEndpoint contract
    }
}