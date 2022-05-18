# Informats

The `DLMReader` package uses `informat` to call a special type of functions on raw text before parsing its values. This gives a flexible feature to `DLMReader` and enables it to handle messy delimited files.

The package is shipped with some predefined `informat`s which are listed (new informats may be added to future releases) below:

* `STRIP!`: Removes leading and trailing blanks
* `COMMA`: Removes `$`, `£`, and `,`(thousands separators) from the numbers
* `COMMAX`: Treats `,` as decimal point, and removes `€`, and `.` (thousands separators) from numbers
* `NA!`: Treats `NA`, `na`, `Na`, `nA` as missing
* `BOOL!`: Converts any form of `True` and `False` to `1` and `0`, respectively

Use "`∘`" to combine multiple informats, e.g. `COMMA! ∘ NA!`.

Power users may define their own informats.
