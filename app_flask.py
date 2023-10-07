"""Simple implementation of Flask Migrate
see: https://flask-migrate.readthedocs.io/en/latest/#alembic-configuration-options
"""

import os
from dotenv import load_dotenv
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate


# We store the database URI in the .env file. We load the environment variables
# with load_dotenv
load_dotenv('./.env')

# Create simple flask app instance
app = Flask(__name__)

# This is the way we define, which database that we want to connect to.
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DB-URI', 'sqlite:///app.db')

# Create an SQLAlchemy instance that associate with the app (flask instance).
# Later on we define the database schema in a Class model that inherit
# from db.Model (SQLAlchemy instance)
db = SQLAlchemy(app)

# Create the alembic (SQLAlchemy) configuration
Migrate(app, db)


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(128))
