ActiveAdmin.register Group do

  permit_params :user_id, :name, :group_category_id, :activity, :first_question,
                :fes_year_id

  index do
    selectable_column
    id_column
    column :fes_year
    column :user
    column :name
    column :group_category
    column :activity
    column :created_at
    actions
  end

  csv do
    column :id
    column :fes_year
    column :user do |group|
      group.user.user_detail.name_ja
    end
    column :user do |group|
      group.user.user_detail.name_en
    end
    column :name
    column :group_category do |group|
      group.group_category.name_ja
    end
    column :activity
    column :created_at
    column :updated_at
  end

  # csvダウンロードアクションを作成
  collection_action :download_group_list, :method => :get do
    groups = Group.where({ fes_year_id: FesYear.this_year() })
    csv = CSV.generate do |csv|
      csv << ['Name', 'E-mail Address']
      groups.each do |group|
        groupname = group.name + '( ' + group.user.user_detail.name_ja + ' )'
        csv << [
          groupname,
          group.user.email
        ]
      end
    end

    send_data csv.encode('Shift_JIS', :invalid => :replace, :undef => :replace), type: 'text/csv; charset=shift_jis; header=present', disposition: "attachment; filename=group_list.csv"
  end

end
