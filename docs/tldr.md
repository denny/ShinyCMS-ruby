# ShinyCMS Documentation

## Installation: the tl,dr version

```bash
git clone https://github.com/denny/ShinyCMS-ruby
cd ShinyCMS-ruby
cp docs/env.sample .env.development.local
# Edit .env.development.local in case you want/need to change anything
bundle install
yarn install
rails db:setup
rails shiny:demo:load     # if you want the demo data loaded
rails shiny:admin:create  # if you didn't load the demo data
rails s
```

You should now have a ShinyCMS site at http://localhost:3000, with an admin area at http://localhost:3000/admin
