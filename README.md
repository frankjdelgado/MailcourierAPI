rubyproject2
============

Mailcourier API. Based on rubyproject1

## Made by 
* Marvin Bernal
* Francisco Delgado

## API Documentation
* Directory: /docs/

### Create  User

* create user 'ati'@localhost identified by 'ati';
* GRANT ALL PRIVILEGES ON rubyproject2_development.* TO 'ati'@'localhost';
* GRANT ALL PRIVILEGES ON rubyproject2_test.* TO 'ati'@'localhost';
* GRANT ALL PRIVILEGES ON rubyproject2_production.* TO 'ati'@'localhost';

### Create Database

* rake db:migrate
* rake db:seed

## Starting Server

* rails start: api without ssl
* thin start --ssl : api though https