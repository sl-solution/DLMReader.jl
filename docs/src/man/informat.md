# Informats

The `DLMReader` package uses `informat` to call a special type of functions on raw text before parsing its values. This gives a flexible feature to `DLMReader` and enables it to handle messy delimited files.

The package is shipped with some pre-registered `informat`s which are listed (new informats may be added to future releases) below:

* `STRIP!`: Remove leading and trailing blanks
* `COMMA`: Remove `$`, `£`, and `,`(thousands separators) from the numbers
* `COMMAX`: Treat `,` as decimal point, and removes `€`, and `.` (thousands separators) from numbers
* `NA!`: Treat `NA`, `na`, `Na`, `nA` as missing
* `BOOL!`: Convert any form of `True` and `False` to `1` and `0`, respectively
* `ACC!`: Treat numbers in parentheses (Accounting format) as negative values, i.e. it replaces `(` with `-` and `)` with blank.
* `COMPRESS!`: Remove all blanks (`0x20`)

Users can define their own informats, which is basically a function with one positional argument. The function must accept a special mutable string and return it (or a subset of it). To use the defined function as `informat`, user must register it by calling the `register_informat` function.

## Supported string manipulation functions

The function used for informat must accept a special mutable string type and return it. Thus, user must only modify the input argument in-place. Currently, few string manipulation functions are optimised for this purpose: (in the following paragraph `x` is referring to the argument passed to user defined informat)

* **isequal**: User can use `isequal` to check if the input function or a sub-string of it is equal to a string.
* **setindex!**: To assign a string to the input argument, use `setindex!(x, "newtext")` syntax. If the length of new text is smaller than `x`, it will be padded with blank (0x20), if it is longer than `x` it will be truncated.
* **replace!**: User can use `replace!` to replace part of the input argument. For instance `replace!(x, "12"=>"21")` replace every occurrence of "`12`" with "`21`". Note that shorter replacing text will be padded with blank and longer ones will be truncated.
* **occursin**: `occursin("text", x)` determines whether the first argument is a substring of the second.
* **contains**: `contains(x, "text")` determines whether the second argument is a substring of the first.
