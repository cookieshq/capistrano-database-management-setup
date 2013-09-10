namespace :db do

  desc <<-DESC
    Creates the database.yml configuration file in shared path.

    It uses a reference file config/database.yml.example file present on your code.

    When this recipe is loaded, db:setup is automatically configured
    to be invoked after deploy:setup. You can skip this task setting
    the variable :skip_db_setup to true. This is especially useful
    if you are using this recipe in combination with
    capistrano-ext/multistaging to avoid multiple db:setup calls
    when running deploy:setup for all stages one by one.
  DESC

  task :setup, :except => { :no_release => true } do

    require 'yaml'
    database_config = YAML::load_file("config/database.yml.example")
    set(:db_user, Capistrano::CLI.ui.ask("Database user: ") )
    set(:db_password, Capistrano::CLI.password_prompt("Database Password: ") )
    set(:db_name, Capistrano::CLI.ui.ask("Database name: ") )

    environment_database_config = {}
    environment_database_config[rails_env] = database_config[rails_env]

    environment_database_config[rails_env]['username'] = db_user.to_s
    environment_database_config[rails_env]['password'] = db_password.to_s
    environment_database_config[rails_env]['database'] = db_name.to_s


    run "mkdir -p #{shared_path}/config"

    database_yaml = environment_database_config.to_yaml

    put database_yaml, "#{shared_path}/config/database.yml"

  end

  desc <<-DESC
    [internal] Updates the symlink for database.yml file to the just deployed release.
  DESC
  task :symlink, :except => { :no_release => true } do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

end

after "deploy:setup",           "db:setup"   unless fetch(:skip_db_setup, false)
after "deploy:finalize_update", "db:symlink"
