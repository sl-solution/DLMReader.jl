# DLMReader

A high performance package for reading an ascii file. It designed as a file parser for `InMemoryDatasets.jl`. 

The package supports:
 
* alternative delimiter: e.g. reading `2,3;4,5` where `,` or `;` is the column separator
* string as delimiter: e.g. having `::` as column separator
* fixed width column: e.g. reading `2  3,4,5` where the first column is located at characters `1:3`, but the rest of columns are separated by `,`
* using different eol character: e.g. having `;` as eol and `\n` as the column separator
* ...
