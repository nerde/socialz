# README

Socialz groups tweets, status updates and photos from https://takehome.io and present them in a JSON format.

## Installation

1. Clone this project
2. Go into the project folder and make sure you have the required Ruby version installed
  1. Check `.ruby-version` to know which version is currently being used
  2. If you use rbenv, just call `rbenv install` and it will install the right version
3. Install Bundler with `gem install bundler`
4. Install all dependencies with `bundle`

## Keep in Mind

* https://takehome.io is not stable. It is slow and sometimes it just fails the request.
  * When a request fails we retry it for up to 5 times. If that is not enough, we just return an empty array.
* Successful responses from https://takehome.io are cached for 15 minutes to provide a better performance to clients.

## Usage

To start the project, simply call `rails s`. Then you can test it by calling `curl localhost:3000`.

If you want to enable caching in development mode, you need to `touch tmp/caching-dev.txt`, `bin/spring stop`
and restart your server. To disable caching `rm tmp/caching-dev.txt`, `bin/spring stop` and restart your server.

## How it Works

In order to provide an acceptable performance, we have a few classes that collaborate together through dependency
injection:

* `TakeHome`: This is the base wrapper for Take Home API. It simply calls the endpoints and wraps known errors in
  a `TakeHome::Error` object to allow custom error handling.
* `RetriableTakeHome`: This class takes a `TakeHome` as an injected dependency and in case of a `TakeHome::Error` it
  retries the request until a successful response is obtained or `max_retries` is reached, in which case the
  exception is raised again.
* `CachedTakeHome`: This class takes a `TakeHome` as an injected dependency and caches a successful response
  for the given `ttl` (time to live).
* `SafeTakeHome`: This class takes a `TakeHome` as an injected dependency and returns a default value when a request
  fails.
* `ConcurrentTakeHome`: This class takes a `TakeHome` as an injected dependency and eagerly and concurrently hits
  all Take Home API endpoints that we need using Futures. This makes all requests run in parallel so we don't have
  to wait for the first one to finish before we trigger the second one and so on.

Since these classes work with dependency injection and all of them offer the same API as `TakeHome`, they can be
used interchangeably where a `TakeHome` object is expected, allowing to use composition to customize the desired
behavior.
