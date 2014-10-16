rubyproject2
============

Basic Mailcourier REST API for [Mailcourier](https://github.com/frankjdelgado/rubyproject1)

## Made by 
* Marvin Bernal
* Francisco Delgado

## API Documentation
* Directory: /doc/apidoc.html
* Route: http://localhost:3000/apipie

### Create  User

* create user 'ati'@localhost identified by 'ati';
* GRANT ALL PRIVILEGES ON rubyproject2_development.* TO 'ati'@'localhost';
* GRANT ALL PRIVILEGES ON rubyproject2_test.* TO 'ati'@'localhost';
* GRANT ALL PRIVILEGES ON rubyproject2_production.* TO 'ati'@'localhost';

### Create Database

* rake db:migrate
* rake db:seed

## Starting Server

* API without ssl: rails start 
* API though https: thin start --ssl (You will have to accept certificate manually) 

## License

Ruby on Rails is released under the [MIT License](http://www.opensource.org/licenses/MIT).
