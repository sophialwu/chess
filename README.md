# Chess

This is a game of chess that is playable on the command line interface for two players.

Chess is a two-player strategy board game played on an 8x8 grid. Each player has 16 pieces: one king, one queen, two rooks, two knights, two bishops, and eight pawns. Each piece can move in different ways. The objective of the game is to essentially ‘checkmate’ the opponent’s king by placing it under threat of capture that is inescapable.

If you would like more detail on the rules of chess, click [here](http://www.chessvariants.com/d.chess/chess.html).

The following game functionalities are still in progress:
- Castling
- Ability to move piece in between king and checking piece to avoid check
- Stalemate/Draw

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chess'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chess

## Usage

To start the game, execute:

    $ ruby play_game.rb

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/chess. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

