# BNN Cache
## how to use
- Before giving it any input the cache should be reset by setting the reset bit to `1` for one clock (value in cache is `0` after the reset).
- For each clock it adds the input to to the value already existing in the cache (except when the reset value is `1`).
- The output always gives the result from the previous clock.
- The cache handles the zeros in the input as `-1`. The ones stay `1`.