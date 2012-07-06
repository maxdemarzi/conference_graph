server: bundle exec thin start -p $PORT
workers: bundle exec sidekiq -q high,15 -q low,10 -q distributor,5 -r ./pry.rb
