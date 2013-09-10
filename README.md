# Capistrano database setup management

## Usage

This recipe assumes you have a config/database.yml.example present on your Rails code.

Then when you do your cap [environment] deploy:setup it will ask for database username, password, and database name.

It will then store a database.yml file in your shared_path/config/

## Deployment

On every deploy the recipe is creating a sym link to from the shared config to your application database.yml file.

## Capistrano recipe

For maintenability you can copy the database_recipe.rb file in your deploy/recipes/ folder then load it in your deploy.rb with

    load 'config/deploy/recipes/database'

