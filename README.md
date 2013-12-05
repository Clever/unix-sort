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

## Examples

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

Now for one a bit more complex:

```javascript
var dogs = [
    {
        name: 'Toto',
        owner: 'Dorothy',
        age: 23
    },
    {
        name: 'Lassie',
        owner: 'Timmy',
        age: 7,
        note: 'Lassie from the second movie'
    },
    {
        name: 'Lassie',
        owner: 'Timmy',
        age: 9,
        note: 'Lassie from the first movie'
    },
    {
        name: 'Old Yeller',
        owner: 'Travis Coates',
        age: 3
    },
    {
        name: 'Balto',
        owner: 'Gunnar Kaasen',
        age: 11
    }
];

var readable = new ArrayStream(dogs);
readable.pipe(unix_sort(['name', 'age']));
```
