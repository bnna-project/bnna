# BNN Cache
## how to use
- Before giving it any input the cache should be reset by setting the reset bit to `1` for one clock (value in cache is `0` after the reset).
- As long as the reset bit is set to `1` the cache doesnt do anything.
- If the reset bit is `0`: For each clock (at rising edge) it adds the input to to the value already existing in the cache.
- At the falling edge the cache outputs the value that is currently in the cache (which is the result from the calculation from the previous rising edge).