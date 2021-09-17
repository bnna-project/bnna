# BNN Cache (also refered to as register)
## how to use
- Before giving it any input the cache should be reset by setting the reset bit to `1` for one clock (value in cache is `0` after the reset).
- As long as the reset bit is set to `1` the cache doesnt do anything.
- If the reset bit is `0`: For each clock (at rising edge) it adds the input to to the value already existing in the cache.
- If the cache detetects a reset signal it outputs its result in the next clock and resets its memory.