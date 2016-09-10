### ページネーションを追加する

### Gemの追加
Gemfileにページネーションを行うGemを追加する.
```
# Gemfile
# ページネーションを追加
gem 'kaminari'
```

### Gemをインストール
```sh
$ bundle install
```

### kaminari用のconfigファイルを生成

```sh
$ bundle exec rails g kaminari:config
Running via Spring preloader in process 15472
      create  config/initializers/kaminari_config.rb
```

``config/initializers/kaminari_config.rb``が生成されたコンフィグファイル.  
設定に関しては, [amatsuda/kaminari | github](https://github.com/amatsuda/kaminari#general-configuration-options)を参照.  

### Controllerの編集
ページネーションの対象となる変数を追加する.  
今回は, ``assign_rental_item/item_list.html.erb``に対して  
ページネーションを追加するため, 
``aassign_rental_item#item_list``アクションを編集する. 

``orders``がページネーションの対象となる変数であるため,  
``orders``を``kaminari``が要求する形に修正する.  

```diff
-    @orders = RentalOrder.year(this_year).where(rental_item_id: rental_item)
+    @orders = RentalOrder.year(this_year).where(rental_item_id: rental_item).page(params[:page]
```

### Viewの編集

``app/views/assign_rental_items/item_list.html.erb``を編集  

```diff
     <% end %>
   </tbody>
 </table>
+<%= paginate @orders %> # ここにページネーションを表示
```

### BootStrap3の適応
``kaminari``はBootstrap3に対応している.  
以下のコマンドを打つとページネーションにBootstrap3を適応する.  
※ ネットに繋がっている必要あり

```
$ bundle exec rails g kaminari:views bootstrap3
Running via Spring preloader in process 18143
      downloading app/views/kaminari/_first_page.html.erb from kaminari_themes...
      create  app/views/kaminari/_first_page.html.erb
      downloading app/views/kaminari/_gap.html.erb from kaminari_themes...
      create  app/views/kaminari/_gap.html.erb
      downloading app/views/kaminari/_last_page.html.erb from kaminari_themes...
      create  app/views/kaminari/_last_page.html.erb
      downloading app/views/kaminari/_next_page.html.erb from kaminari_themes...
      create  app/views/kaminari/_next_page.html.erb
      downloading app/views/kaminari/_page.html.erb from kaminari_themes...
      create  app/views/kaminari/_page.html.erb
      downloading app/views/kaminari/_paginator.html.erb from kaminari_themes...
      create  app/views/kaminari/_paginator.html.erb
      downloading app/views/kaminari/_prev_page.html.erb from kaminari_themes...
      create  app/views/kaminari/_prev_page.html.erb
```


