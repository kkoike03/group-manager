class SubRep < ActiveRecord::Base
  belongs_to :group
  belongs_to :department
  belongs_to :grade
  has_one :fes_year, through: :group

  # 必須入力
  validates :group_id, :name_ja, :name_en, :tel, :email, :department_id, :grade_id,
    presence: true

  # 半角英字と半角スペースのみ
  validates :name_en, format: { with: /\A[a-zA-Z\s]+\z/i }

  # tel -> 半角数字とハイフンのみ, ( [333-4444-4444, for 携帯], [4444-22-4444, for 固定] )
  validates :tel, format: { with: /(\A\d{3}-\d{4}-\d{4}+\z)|(\A\d{4}-\d{2}-\d{4})+\z/i }

  validates :email, :email_format => { :message => '有効なe-mailアドレスを入力してください' }
end
