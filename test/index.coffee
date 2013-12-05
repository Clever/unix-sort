_           = require 'underscore'
assert      = require 'assert'
{Readable}  = require 'stream'
understream = require 'understream'
unix_sort   = require '../index'
_.mixin understream.exports()
understream.mixin unix_sort, 'unix_sort', true

describe 'sorting the input streams', ->
  _([
    name: 'sorts with a simple key'
    input: [
      { a: '5' }
      { a: '1' }
      { a: '3' }
    ]
    keys: ['a']
  ,
    name: 'sorts with a complex key'
    input: [
      { a: '5', b: '4' }
      { a: '1', b: '7' }
      { a: '1', b: '5' }
    ]
    keys: ['a', 'b']
  ,
    name: 'sorts stably'
    input: [
      { a: '1', b: '4' }
      { a: '1', b: '7' }
      { a: '1', b: '5' }
    ]
    keys: ['a']
  ,
    name: 'sorts with extra fields'
    input: [
      { a: '5', b: '4' }
      { a: '1', b: '7' }
      { a: '1', b: '5' }
    ]
    keys: ['b']
  ,
    name: 'sorts undefined keys to the beginning'
    input: [
      { a: '5', b: '4' }
      { b: '7' }
      { a: '3', b: '5' }
    ]
    keys: ['a']
  ,
    name: 'sorts undefined keys to the beginning when the first key is missing'
    input: [
      { a: '5', b: '4', c: '3' }
      { b: '7', c: '1' }
      { a: '3', b: '5', c: '4' }
      { b: '7', a: '3' }
    ]
    keys: ['a', 'b', 'c']
  ,
    name: 'sorts undefined keys to the beginning when a middle key is missing'
    input: [
      { a: '5', b: '4', c: '3' }
      { b: '7', a: '3', c: '1' }
      { b: '7', a: '3', c: '2' }
      { a: '3', b: '5', c: '4' }
      { b: '7', c: '8' }
    ]
    keys: ['b', 'a', 'c']
  ,
    name: 'sorts undefined as the empty string'
    input: [
      { a: '1' }
      { a: '' }
      {}
    ]
    expected: [
      { a: '' }
      {}
      { a: '1' }
    ]
    keys: ['a']
  ,
    name: 'sorts when keys have tabs in them'
    input: [
      { a: '5\t1'}
      { a: '7' }
      { a: '3' }
    ]
    keys: ['a']
  # For benchmarking:
  #,
  #  name: 'sorts a lotta semi-big objects'
  #  input: _(_.sample([0..100000], 10000)).map (i) -> { a: 'a', key: "#{i}", b: 'b', c: [1..100].join('') }
  #  keys: ['key']
  ]).each ({name, input, keys, expected}) ->
    # Sort once by each key, starting with the last. Since _.sortBy is stable,
    # this will result in a sort that gives precedence to the first key, then
    # the second, etc.
    expected ?= _.reduceRight keys, (acc, key) ->
      _.sortBy acc, (o) -> o[key] ? ''
    , input

    describe '', ->
      _.each
        'with json sort': ->
          r = new Readable objectMode: true
          _.each input, (o) -> r.push o
          r.push null
          _.stream(r).unix_sort(keys).stream()
      , (input_stream, stream_name) ->
        it "#{stream_name} #{name}", (done) ->
          start = process.hrtime()
          _.stream(input_stream()).run (err, result) ->
            finish = process.hrtime start
            console.log 'elapsed seconds %d.%d', finish[0], finish[1]
            assert.ifError err
            assert.deepEqual result, expected
            done()
