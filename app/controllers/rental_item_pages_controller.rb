class RentalItemPagesController < ApplicationController
  def preview_pdf_page(template_name, output_file_name)
    respond_to do |format|
      format.pdf do
        # 詳細画面のHTMLを取得
        html = render_to_string template: "rental_item_pages/#{template_name}"

        # PDFKitを作成
        pdf = PDFKit.new(html, encoding: "UTF-8")

        # 画面にPDFを表示する
        # to_pdfメソッドでPDFファイルに変換する
        # 他には、to_fileメソッドでPDFファイルを作成できる
        # disposition: "inline" によりPDFはダウンロードではなく画面に表示される
        send_data pdf.to_pdf,
          filename:    "貸出物品書類_#{output_file_name}.pdf",
          type:        "application/pdf",
          disposition: "inline"
      end
    end
  end

  def for_pasting_room_sheet
    this_year = FesYear.this_year()

    @rentables = RentableItem.year(this_year)
    @assignments = AssignRentalItem.year(this_year)

    preview_pdf_page('for_pasting_room_sheet', "物品貸出表(各部屋)")
  end
end
