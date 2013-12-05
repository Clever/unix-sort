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
It assumes that all of the keys have a string value.

## Examples

*NOTE: The implementation of ArrayStream is left as an exercise to the reader*

```javascript
var unix_sort = require('unix-sort');

var array = ['a', 'e', 'b', 'd', 'e', 'c'];
var objects = array.map(function (el) {return {item: el}});

var readable = new ArrayStream(objects);
readable.pipe(unix_sort(['item'])); // 'a', 'b', 'c', 'd', 'e', 'e'
```

Now for one a bit more complex:

```javascript
var dogs = [
    {
        name: 'Toto',
        owner: 'Dorothy'
    },
    {
        name: 'Lassie',
        owner: 'Alex',
        notes: "Owned by Timmy's brother after he died in the well"
    },
    {
        name: 'Lassie',
        owner: 'Timmy'
    },
    {
        name: 'Old Yeller',
        owner: 'Travis Coates'
    },
    {
        name: 'Balto',
        owner: 'Gunnar Kaasen'
    }
];

var readable = new ArrayStream(dogs);
readable.pipe(unix_sort(['name', 'owner']));
```
