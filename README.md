# [Tab](https://zeus.ugent.be/tab) [![Analytics](https://ga-beacon.appspot.com/UA-25444917-6/ZeusWPI/Tab/README.md?pixel)](https://github.com/igrigorik/ga-beacon) [![Code Climate](https://codeclimate.com/github/ZeusWPI/Tab/badges/gpa.svg)](https://codeclimate.com/github/ZeusWPI/Tab) [![Coverage Status](https://coveralls.io/repos/ZeusWPI/Tab/badge.svg?branch=master&service=github)](https://coveralls.io/github/ZeusWPI/Tab?branch=master) [![Build Status](https://travis-ci.org/ZeusWPI/Tab.png?branch=master)](https://travis-ci.org/ZeusWPI/Tab)

## Deploy

Just run `cap production deploy`. You might need to edit some config files
on the server.

## Adding clients

A client can see and modify balances of other users.

To add a client, connect
to the server, `cd production/current`, then run `RAILS_ENV=production bundle exec rails console`.
Then you can add clients with `client = Client.create name: "Tap"`.

If you want the client to be able to make transactions, run: `client.add_role :create_transactions` in the console.
