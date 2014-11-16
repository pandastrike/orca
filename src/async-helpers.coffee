_when = require "when"
{promise} = _when
safely = _when.try
{lift, call} = require "when/generator"
async = lift
{lift} = require "when/node"
module.exports = {promise, async, lift, call, safely}
