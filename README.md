# [Tab](https://tab.zeus.gent)

💰 Yes. We have to drink. But we also have to pay. This does the paying part.

Not to be confused with [Tap](https://github.com/ZeusWPI/Tap).

## Development

To provide a consistent experience on every system, docker compose is used.

### Using Docker and Make *(recommended)*

#### Linux/Unix

1. Install [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) (if not already included).
2. Start the development server.
    ```sh
    make up
    ```
    > This will start a development server on http://localhost:3000.
    > Cancelling this command will leave tab running in the background.
    > You can stop it using `make down`.
3. Create the database.
    ```sh
    make migrate
    ```
    > The development setup uses a SQLite 3 database, which can be found under `/db/development.sqlite3`.
4. Generate openapi spec.
    ```sh
    make swagger
    ```
    > Required for the http://localhost:3000/api-docs page.
4. Start a development shell.
    ```sh
    make shell
    ```
    > Here you can invoke `./bin/rails` or `./bin/rake` for e.g. code generation.

See the `Makefile` for all commands.

## Adding clients

A client can see and modify balances of other users.

To add a client, connect
to the server, `cd production/current`, then run `RAILS_ENV=production bundle exec rails console`.
Then you can add clients with `client = Client.create name: "Tap"`.

If you want the client to be able to make transactions, run: `client.add_role :create_transactions` in the console.
