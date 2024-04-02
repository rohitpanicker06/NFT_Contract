// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
 * @title Counters
 * @dev Simple counter utility for incrementing and decrementing values.
 */
library Counters {
    struct Counter {
        // Counter value
        uint256 _value; // Using underscore to differentiate the internal variable.
    }

    /**
     * @dev Returns the current value of the counter.
     */
    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    /**
     * @dev Increments the counter value by 1. Can overflow.
     */
    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    /**
     * @dev Decrements the counter value by 1. Can underflow.
     */
    function decrement(Counter storage counter) internal {
        require(counter._value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value -= 1;
        }
    }

    /**
     * @dev Resets the counter to zero.
     */
    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}
