# Hivetec Code Exercise

## Requirements
- Ruby version 2.3 or above
- bundler
- PostgresSQL 9.6 or above

## Setup
- `bundle install` install necessary gems
- Add 'hivetec' role to PostgresSQL server (Check config/database.yml for more details)
- `rake db:setup` setup database

## Start app
`rails server -p 3000`

**NOTE**:
- WebUI Proxy is configured to work with API server [http://localhost:3000](http://localhost:3000)
