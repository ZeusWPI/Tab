# [Tab](https://zeus.ugent.be/tab)
Not to be confused with [Tap](https://zeus.ugent.be/tap). 

## Get started

1. Run `bundle`
2. Run `npm i`
3. Setup the database with `bundle exec rails db:setup`
4. Execute all migrations with `bundle exec rails db:migrate`
5. Seed the database with `bundle exec rails db:seed`
6. Run `./bin/dev`
7. Browse to [http://localhost:3000](http://localhost:3000)

Or, run ./setup.sh and go to step 6.

## Adding clients

A client can see and modify balances of other users.

To add a client, connect
to the server, `cd production/current`, then run `RAILS_ENV=production bundle exec rails console`.
Then you can add clients with `client = Client.create name: "Tap"`.

If you want the client to be able to make transactions, run: `client.add_role :create_transactions` in the console.

## Troubleshooting

### My CSS classes aren't rendered

This probably is a missing entry in Tailwinds configuration. Make sure your file path is included in the `content` array in `tailwind.config.js`.

When Tailwind compiles CSS, it scans all files matching the `content` array to know which CSS classes to include.
