# Informats

The `DLMReader` package uses `informat` to call a special type of functions on raw text before parsing its values. This gives a flexible feature to `DLMReader` and enables it to handle messy delimited files.

The package is shipped with some predefined `informat`s which are listed (new informats may be added to future releases) below:

* `STRIP!`: Remove leading and trailing blanks
* `COMMA`: Remove `$`, `£`, and `,`(thousands separators) from the numbers
* `COMMAX`: Treat `,` as decimal point, and removes `€`, and `.` (thousands separators) from numbers
* `NA!`: Treat `NA`, `na`, `Na`, `nA` as missing
* `BOOL!`: Convert any form of `True` and `False` to `1` and `0`, respectively
* `ACC!`: Treat numbers in parentheses (Accounting format) as negative values, i.e. it replaces `(` with `-` and `)` with blank.
* `COMPRESS!`: Remove all blanks (`0x20`)

Use "`∘`" to combine multiple informats, e.g. `COMMA! ∘ NA! ∘ COMPRESS!`, i.e. compress the raw text first, remove `na` characters, and for the rest treat them as `COMMA!`.

Power users may define their own informats. To add a new `Informat` must define a function. The user defined functions must have three positional arguments. The first one is the input line buffer, and the second and the third one is the lower and upper bound of the line buffer which the functions have access to, respectively. The line buffer is an `AbstractString` and its `data` field is `UInt8`. The user defined function can replace any element of `data` but it can not resize it or go beyond the lower and upper bounds. It must return the original or adjusted lower and upper bounds (the adjusted value must be within the original bound). User must then wrap the defined function with `Informat` to register the new function as the `DLMReader` informat.
