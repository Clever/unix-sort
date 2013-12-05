_           = require 'underscore'
{Transform} = require 'stream'
understream = require 'understream'
_.mixin understream.exports()

class JSONParser extends Transform
  constructor: (@options) ->
    super @options
  _transform: (chunk, encoding, cb) ->
    return cb() unless chunk.length # Ignore blank lines
    setImmediate -> cb null, JSON.parse chunk
understream.mixin JSONParser, 'parseJSON'

module.exports = (keys, options={}) ->
  _(options).defaults
    delim: '\t'
  _.stream()
    .map (obj) ->
      vals = _.chain(keys)
        .map((key) -> obj[key])
        .map((val) -> val ? '') # Replace undefined with the empty string
        # Stringifying the values escapes any control characters, which makes it
        # safe to use tab as the delimiter
        .map(JSON.stringify)
        .map((val_str) -> val_str[1...-1]) # Trim off quotes produced by stringify
        .value()
      vals.join(options.delim) + options.delim + JSON.stringify(obj) + '\n'
    .spawn('sort', do ->
      key_opts = _.flatten _([1..keys.length]).map (i) -> ['-k', "#{i},#{i}"]
      [ '-s'            # stable sort
        '-t', options.delim     # column separator
      ].concat key_opts # which columns to sort by
    )
    .spawn('cut', ['-d', options.delim, '-f', keys.length + 1])
    .split('\n')
    .parseJSON()
    .duplex()
