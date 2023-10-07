# the variables below are for a use case that we can include the environment
# variable in the Makefile. For the production, you don't need to create
# new variable in Makefile if you have already had in your environment.
# In this file, we are using "include ./.env" to include the variables

include ./.env

db-image := ${DB-IMAGE}
db-port := ${DB-PORT}
db-name := ${DB-NAME}
db-user := ${DB-USER}
db-password := ${DB-PASSWORD}

## ----------------------------------------------------------------------
## The purpose of this Makefile is to demonstrate a simple help mechanism
## for running docker container.
## ----------------------------------------------------------------------

help: ## Show this help.
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

db-build: ## Build database image.
	echo "Pulling database image..."
	docker pull ${db-image}
	echo "Checking ${db-image} image vulnerabilities..."
	docker scout cves ${db-image}

db-run: ## Run database container.
	echo "Running database on port ${db-port}..."
	docker run --name my-db-postgres -p ${db-port}:5432 -e POSTGRES_DB=${db-name} -e POSTGRES_USER=${db-user} -e POSTGRES_PASSWORD=${db-password} -d postgres

setup-env: ## Create environment and install dependencies
	# You can also use Pipfile if you want to.
	python3 -m venv .venv && source .venv/bin/activate
	pip install --upgrade pip && pip install -r requirements.txt

migration-init: ## Initialise the migration with Flask_Migrate
	flask db init

migration-create: ## Create new migration file against based on the model and existing database schema.
	@read -p "Enter your migration message:" message;\
	flask db migrate -m "$$message"

migration-list: ## Show migration versions.
	flask db history
