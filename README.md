# Tukune
[![Gem Version](https://badge.fury.io/rb/tukune.svg)](https://badge.fury.io/rb/tukune)
[![Build Status](https://travis-ci.org/gin0606/tukune.svg?branch=master)](https://travis-ci.org/gin0606/tukune)
[![Coverage Status](https://coveralls.io/repos/github/gin0606/tukune/badge.svg?branch=master)](https://coveralls.io/github/gin0606/tukune?branch=master)

Create a pull request if there is a difference via Github API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tukune'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install tukune
```

## Required ENV variables

`OCTOKIT_ACCESS_TOKEN`

Please set your [Githu API Token](https://github.com/settings/tokens)

## Usage
All commands does not do anything if nothing to commit.

`tukune --title "Pull Request Title" --body "Pull Request Body"`

Create Pull Request

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


### TODO
- [ ] testing
- [ ] refactoring

## Contributing
1. Fork it ( https://github.com/gin0606/tukune/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
