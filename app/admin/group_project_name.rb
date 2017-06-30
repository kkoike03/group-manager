ActiveAdmin.register GroupProjectName do
  permit_params :project_name

  index do
    selectable_column
    id_column
    column :group
    column :project_name
    actions
  end

  form do |f|
    year_id = FesYear.where(fes_year: Time.now.year).first.id

    f.inputs do
      input :group, :as => :select, :collection => Group.where(fes_year_id: year_id)
      input :project_name
    end
    actions
  end

  preserve_default_filters!
  filter :fes_year

end
