# issue90 実装ログ

# コントローラの生成

```sh
$ bundle exec rails g controller GroupInformationPages
Running via Spring preloader in process 35929
      create  app/controllers/group_information_pages_controller.rb
      invoke  erb
      create    app/views/group_information_pages
      invoke  helper
      create    app/helpers/group_information_pages_helper.rb
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/group_information_pages.coffee
      invoke    scss
      create      app/assets/stylesheets/group_information_pages.scss
```

# 書類生成用メソッドの作成

scopeを作る

`app/models/power_order.rb`を編集

```diff
+  scope :year, -> (year) {joins(:group).where(groups: {fes_year_id: year})}
```

pdf生成用メソッドを追加
`app/controllers/group_information_pages_controller.rb`を編集

```diff
 class GroupInformationPagesController < ApplicationController
+  def preview_pdf_page(template_name, output_file_name)
+    respond_to do |format|
+      format.pdf do
+        # 詳細画面のHTMLを取得
+        html = render_to_string template: "group_information_pages/#{template_name}"
+
+        # PDFKitを作成
+        pdf = PDFKit.new(html, encoding: "UTF-8")
+
+        # 画面にPDFを表示する
+        # to_pdfメソッドでPDFファイルに変換する
+        # 他には、to_fileメソッドでPDFファイルを作成できる
+        # disposition: "inline" によりPDFはダウンロードではなく画面に表示される
+        send_data pdf.to_pdf,
+          filename:    "物品貸出書類_#{output_file_name}.pdf",
+          type:        "application/pdf",
+          disposition: "inline"
+      end
+    end
+  end
+
+  def group_information_sheet
+    this_year = FesYear.this_year
+
+    @groups = Group.year(this_year)
+    @fes_date = FesDate.where(fes_year_id: this_year)
+    @rentables = RentableItem.year(this_year)
+    @assignment_items = AssignRentalItem.year(this_year)
+
+    preview_pdf_page('group_information_sheet', "物品持出し表（各団体向け）")
+  end
 end
```

# 書類生成用のリンクを追加

`app/admin/dashboard.rb`を編集

```diff
    columns do
      column do
        panel "物品貸出書類" do
          li link_to("物品貸出票", rental_item_pages_for_pasting_room_sheet_path(format: 'pdf'))
+          li link_to("参加団体情報管理表", group_information_pages_group_information_sheet_path(format: 'pdf'))
        end
      end
    end
```

ルーティングの設定
`config/routes.rb`を編集

```diff
+  get 'group_information_pages/group_information_sheet'
```