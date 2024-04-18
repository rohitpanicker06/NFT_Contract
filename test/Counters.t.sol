// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counters.sol";

contract CountersTest is Test {
    using Counters for Counters.Counter;
    Counters.Counter private counter;

    function setUp() public {
        counter.reset();
    }

    function testInitialValue() public {
        assertEq(counter.current(), 0, "Initial counter value should be 0");
    }

    function testIncrement() public {
        counter.increment();
        assertEq(counter.current(), 1, "Counter should be incremented to 1");

        counter.increment();
        assertEq(counter.current(), 2, "Counter should be incremented to 2");
    }

    function testDecrement() public {
        counter.increment();
        counter.increment();
        counter.decrement();
        assertEq(counter.current(), 1, "Counter should be decremented to 1");
    }

    function testFailDecrementFromZero() public {
        counter.decrement();
    }

    function testReset() public {
        counter.increment();
        counter.reset();
        assertEq(counter.current(), 0, "Counter should be reset to 0");
    }


    function testUncheckedIncrementOverflow() public {
        uint256 max = type(uint256).max;
        counter._value = max;  // Directly setting for test scenario
        counter.increment();
        assertEq(counter.current(), 0, "Counter should overflow to 0");
    }
}
