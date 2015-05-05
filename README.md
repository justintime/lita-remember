# lita-remember

[![Build Status](https://travis-ci.org/justintime/lita-remember.png?branch=master)](https://travis-ci.org/justintime/lita-remember)
[![Coverage Status](https://coveralls.io/repos/justintime/lita-remember/badge.png)](https://coveralls.io/r/justintime/lita-remember)

lita-remember is a plugin that allows users to have Lita memorize terms and their definitions.  This handler was
inspired and influenced by [lita-key-value](https://github.com/jimmycuadra/lita-key-value), 
[lita-wtf](https://github.com/esigler/lita-wtf), and Hubot's 
[hubot-remember](https://github.com/github/hubot-scripts/blob/master/src/scripts/remember.coffee).

## Installation

Add lita-remember to your Lita instance's Gemfile:

``` ruby
gem "lita-remember"
```

## Usage

Lita can remember, forget, search, and list terms and definitions.

```
# Lita can remember terms:
[You]: Lita, remember May 4th is Star Wars Day
[Lita]: OK, I'll remember May 4th is Star Wars Day
# Lita can recall terms:
[You]: Lita, what is May 4th?
[Lita]: May 4th is Star Wars Day (answered 1 times, defined by Justin Ellison)
# Lita can list all terms it knows about:
[You]: Lita, what do you remember?
[Lita]: These are all the terms I remember:
[Lita]:  - may 4th
# Lita can search terms:
[You]: Lita, search terms for May
[Lita]: The following terms matched your query:
[Lita]:  - may 4th
# Lita can search definitions:
[You]: Lita, search terms for Star Wars
[Lita]: The following terms matched your query:
[Lita]:  - may 4th
# Lita can forget about terms:
[You]: Lita, forget about May 4th
[Lita]: What is this May 4th you speak of? ;)

