class Place < ActiveRecord::Base
  has_many :place_allow_lists

  # 団体カテゴリ毎に利用可能な場所を検索する
  scope :search_enable_place, ->(group_category_id){
    PlaceAllowList.where(group_category_id: group_category_id, enable: true).map {|allow_place|
      self.find(allow_place.place_id)
    }

  }

  def to_s # aciveAdmin, simple_formで表示名を指定する
      self.name_ja
  end

  # 選択肢の生成用，団体idで選択可能な場所を返す
  def self.collections(group_id)
    group_category_id = Group.find(group_id).group_category_id
    self.search_enable_place(group_category_id)
  end

  def self.usable_all_places
    Place.joins(:place_allow_lists) \
      .uniq.where(place_allow_lists:{enable:true}).order(:id)
  end
end
