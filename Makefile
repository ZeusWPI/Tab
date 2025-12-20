dc = docker compose --file=compose.development.yml

build:
	$(dc) build

up:
	$(dc) up --build -t1 -d development
	$(dc) logs -f development

down:
	$(dc) down -t1

start:
	$(dc) start development

stop:
	$(dc) stop -t1 development

restart:
	$(dc) restart -t1 development

logs:
	$(dc) logs -f development

migrate:
	$(dc) exec development bundle exec rake db:setup
	$(dc) exec development bundle exec rake db:migrate

seed:
	$(dc) exec development bundle exec rake db:seed

webpack:
	$(dc) exec development bundle exec rake javascript:build

lint:
	$(dc) up --build -t1 -d development
	$(dc) exec development bundle exec rubocop -A

test:
	$(dc) up --build -t1 test

deploy:
	$(dc) up --build -t1 -d development
	$(dc) exec development bundle exec cap production deploy

shell:
	$(dc) exec development sh


.PHONY: build up down start stop restart logs seed webpack lint test deploy shell
