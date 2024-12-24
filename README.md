# Device Readings Interview Project


## Summary
This app runs a API Rails 7 with Ruby 3.3 all running in Docker. It is structured a using classic MVC rails conventions. 
To avoid using any disk space, I used ActiveModel for models instead of ActiveRecord. I stored objects in memory using Redis (with only in memory caching).

## Assumptions
I assumed that the duplicates timestamps could come in the same request or over multiple requests. In the case where they came in the same request, the first occurrences of the timestamp are kept and all other occurrences are removed.  

## Improvements
Things I would have done given more time:
- Removed more parts of the boilerplate project that uses views. In hindsight, I should have found a boilerplate project that was for API specifically.
- Created more robust validation on Reading model. Right now, a bad timestamp or count field will through an unhandled error.
- Create more thorough specs. Could have used a Reading model spec, routing specs, more edge cases in existing specs.
- Fill out documentation with more explicit schemas and errors
## Setup

Please ensure you are using Docker Compose V2. This project relies on the `docker compose` command, not the previous `docker-compose` standalone program.

https://docs.docker.com/compose/#compose-v2-and-the-new-docker-compose-command

Check your docker compose version with:
```
% docker compose version
Docker Compose version v2.10.2
```

## Initial setup
```
cp .env.example .env
docker compose build
docker compose run --rm web bin/rails db:setup
```

## Running the Rails app
```
docker compose up
```

## Running tests
```
docker compose run --rm web bin/rspec
```

## Documentation
can be found at `docs/index.html`

## Credits
 Based on boilerplate app <https://github.com/ryanwi/rails7-on-docker>