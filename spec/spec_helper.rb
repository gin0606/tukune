$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'tukune'

if ENV["CI"]
  require 'coveralls'
  Coveralls.wear!
end
