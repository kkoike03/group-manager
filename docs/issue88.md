# issue88 実装ログ

# コントローラの生成

```sh
$ bundle exec rails g controller RentalItemPages
Running via Spring preloader in process 25837
      create  app/controllers/rental_item_pages_controller.rb
      invoke  erb
      create    app/views/rental_item_pages
      invoke  helper
      create    app/helpers/rental_item_pages_helper.rb
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/rental_item_pages.coffee
      invoke    scss
      create      app/assets/stylesheets/rental_item_pages.scss
```

# 貸出返却日時を設定するカラムを作成する

```sh
$ bundle exec rails g migration AddRentalItemDatesToGroupManagerCommonOption rental_item_day:string rental_item_time:string return_item_day:string return_item_time:string
$ bundle exec rake db:migrate
```