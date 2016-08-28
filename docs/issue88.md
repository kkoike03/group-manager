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

# 書類生成用メソッドの作成

scopeを作る
`app/models/assign_rental_item.rb`を編集

```diff
+  scope :year, -> (year) {joins(rental_order: [:group]).where(groups: {fes_year_id: year})}
```


pdf生成用メソッドを追加
`app/controllers/rental_item_pages_controller.rb`を編集

```diff
 class RentalItemPagesController < ApplicationController
+  def preview_pdf_page(template_name, output_file_name)
+    respond_to do |format|
+      format.pdf do
+        # 詳細画面のHTMLを取得
+        html = render_to_string template: "rental_item_pages/#{template_name}"
+
+        # PDFKitを作成
+        pdf = PDFKit.new(html, encoding: "UTF-8")
+
+        # 画面にPDFを表示する
+        # to_pdfメソッドでPDFファイルに変換する
+        # 他には、to_fileメソッドでPDFファイルを作成できる
+        # disposition: "inline" によりPDFはダウンロードではなく画面に表示される
+        send_data pdf.to_pdf,
+          filename:    "貸出物品書類_#{output_file_name}.pdf",
+          type:        "application/pdf",
+          disposition: "inline"
+      end
+    end
+  end
+
+  def for_pasting_room_sheet
+    this_year = FesYear.this_year()
+
+    @fes_date = FesDate.where(fes_year_id: this_year)
+
+    @rentables = RentableItem.year(this_year)
+    @assignments = AssignRentalItem.year(this_year)
+
+    preview_pdf_page('for_pasting_room_sheet', "物品貸出表(各部屋)")
+  end
 end
```

# 書類生成用のリンクを追加

`app/admin/dashboard.rb`を編集

```diff
+    columns do
+      column do
+        panel "物品貸出書類" do
+          li link_to("物品貸出票", rental_item_pages_for_pasting_room_sheet_path(format: 'pdf'))
+        end
+      end
+    end
+
```

ルーティングの設定
`config/routes.rb`を編集

```diff
+  get 'rental_item_pages/for_pasting_room_sheet'
```