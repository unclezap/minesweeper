minesweeper is a Minesweeper board generation app, created using Ruby 2.7.3 and PostgreSQL.  The app can be viewed at https://minesweeper-gen.herokuapp.com/ and can also be run on your local Mac machine.

To run on your local machine:

* Make sure you have installed both Postgres and Ruby (2.7.0 or higher\*).

* Clone this repository.

* Make sure you run bundle install, fire up Postgres, and run rails db:create and rails db:migrate.

* Once all these steps are completed, the app can be run by firing up a rails server and navigating in a web browser to http://localhost:3000 (or whatever port you choose).

At the homepage, users are given the option to create Minesweeper boards and to view recently created boards, as well as access to a page showing all boards created by the app.

\* note: This app is currently configured to be Heroku-deployable and as such uses Ruby 2.7.3.  To use earlier versions of Ruby, change the version of Ruby specified in the Gemfile to be Ruby 2.7.0.
