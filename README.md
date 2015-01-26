# Dixie application for job invoice generation

## Getting started

- Run `bundle`.
- Copy `.env.sample` to `.env` and configure it for your local system.
- Copy `config/database.yml.sample` to `config/database.yml` and configure it for your local system.
- Run `rake db:create db:migrate`.

## Inventory prices

Whenever pricing information changes do the following steps:

1. put updated Excel files into `data/`
2. update information in `spec/models/excel_inventory_spec.rb` test to reflect the new prices
3. run `rake load_excel_inventory` to update local prices database (make sure Redis is running first)
4. run `rspec` to make sure all tests pass
5. deploy the new code to Heroku
6. run `heroku run rake load_excel_inventory` to update prices on production
