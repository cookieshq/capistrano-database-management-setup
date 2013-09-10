# Capistrano database setup management

## Usage

This recipe assumes you have a config/database.yml.example present on your Rails code.

Then when you do your cap [environment] deploy:setup it will ask for database username, password, and database name.

It will then store a database.yml file in your shared_path/config/

## Deployment

On every deploy the recipe is creating a sym link to from the shared config to your application database.yml file.
