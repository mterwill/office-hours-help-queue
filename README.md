# classroom-help-queue

[![Build Status](https://travis-ci.org/mterwill/classroom-help-queue.svg?branch=master)](https://travis-ci.org/mterwill/classroom-help-queue)

A help queue for office hours written in Ruby on Rails. The frontend uses
[Semantic UI](http://semantic-ui.com/). We use
[Action Cable](http://guides.rubyonrails.org/action_cable_overview.html) to
manage WebSockets.

## Documentation

Queue documentation is maintained on the [GitHub Wiki](https://github.com/mterwill/classroom-help-queue/wiki) for this project.

Anyone can make changes to the wiki, so please feel free to improve it.

## Contributing

Pull requests are welcome. There are quite a few
[open issues](https://github.com/mterwill/classroom-help-queue/issues). If you
are developing something that is not already an open issue, please open one.

## Development

The easiest way to spin up a development environment is to use
[Docker](https://docker.com).

```bash
$ docker-compose up -d

# Create tables and seed a first course and queue
$ docker-compose run web rake db:migrate db:seed
```

Now add an entry for `dev.eecs.help` to `127.0.0.1` in your `/etc/hosts` file.
Google OAuth2 behaves a little weirdly when the callback URI is `localhost`.

The app should now be accessible at http://dev.eecs.help:3000.
