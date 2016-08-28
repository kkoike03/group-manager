ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    columns do
      column do
        panel "物品担当者向けリンク" do
          text_node "[step1] まずは必要な物品がシステムに登録済みかをチェックせよ！"
          li link_to("物品の一覧", admin_rental_items_path)
          #
          text_node "[step2] 各物品の保管場所と数量を入力せよ！「年度別」です"
          li link_to("物品の在庫一覧・編集", admin_stocker_items_path)
          #
          text_node "[step3] 在庫のうち，貸し出せる数量とその貸出場所を設定せよ！「年度別」です"
          li link_to("貸出可能物品の一覧・編集", admin_rentable_items_path)
          #
          text_node "[step4] 貸出物品の募集が終わるまで休み (以降は未実装)"
        end

      end
    end

    columns do
      column do
        panel "保健所関連書類" do
          li link_to("参加団体 調理有り 書類一覧", health_check_pages_cooking_path(format: 'pdf'))
          li link_to("参加団体 調理無し 書類一覧", health_check_pages_no_cooking_path(format: 'pdf'))
        end

      end
    end
    columns do
      column do
        panel "検便対象者書類" do
          li link_to("検便回収確認用書類", stool_test_pages_check_sheet_path(format: 'pdf'))
          li link_to("検便業者提出用書類", stool_test_pages_for_examiner_sheet_path(format: 'pdf'))
          li link_to("保険所提出用書類", stool_test_pages_for_health_center_sheet_path(format: 'pdf'))
        end
      end
    end

    columns do
      column do
        panel "物品貸出書類" do
          li link_to("物品貸出票", rental_item_pages_for_pasting_room_sheet_path(format: 'pdf'))
        end
      end
    end

  end # content

end
