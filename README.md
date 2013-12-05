# unix-sort

Sort using the unix sort command.
This allows sorting of very large data sets in a stream interface that Node normally can't handle due to memory constraints.

## Install

Forthcoming:
```
npm install unix-sort
```

## Usage

`unix-sort` expects that you are streaming it JavaScript objects and takes a single argument:
an array of all the keys you want to sort by, in order.

*NOTE: The implementation of ArrayStream is left as an exercise to the reader*

```javascript
var _ = require('underscore');
var unix_sort = require('unix-sort');

var array = [1, 5, 2, 4, 5, 3];
var objects = _(array).map(function (el) {return {hash: 0, item: el}});

var readable = new ArrayStream(objects);
var sort_on_hash = unix_sort(['hash']);
readable.pipe(sort_on_hash); // 1, 2, 3, 4, 5, 5
```
