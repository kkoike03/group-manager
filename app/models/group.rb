class Group < ActiveRecord::Base
  belongs_to :group_category
  belongs_to :user
  belongs_to :fes_year
  has_many :sub_reps
  has_many :food_products
  has_many :employees

  validates :name, presence: true, uniqueness: { scope: :fes_year }
  validates :user, presence: true
  validates :activity, presence: true
  validates :group_category, presence: true
  validates :fes_year, presence: true

  # simple_form, activeadminで表示するカラムを指定
  # 関連モデル.groupが関連モデル.group.nameと同等になる
  def to_s
    self.name
  end

  def self.year_groups(year_id)
    return Group.where(fes_years: {id: year_id})
  end

  # このメソッドselfいらないな...
  def self.init_rental_order(id) # RentalOrderのレコードが無ければ数量0で登録する
    items_ids = RentalItem.all.pluck('id')
    items_ids.each{ |item_id|
      order = RentalOrder.new( group_id: id, rental_item_id: item_id, num: 0)
      order.save
    }
  end

  def init_stage_order # StageOrderのレコードが無ければ登録
    return unless group_category_id == 3 # ステージ企画でなければ戻る
    # 1日目，晴れ
    order = StageOrder.new( group_id: id, fes_date_id: 2, is_sunny: true, time_point_start: '未回答', time_point_end: '未回答', time_interval: '未回答')
    order.save
    # 1日目，雨
    order = StageOrder.new( group_id: id, fes_date_id: 2, is_sunny: false, time_point_start: '未回答', time_point_end: '未回答', time_interval: '未回答')
    order.save
    # 2日目，晴れ
    order = StageOrder.new( group_id: id, fes_date_id: 3, is_sunny: true, time_point_start: '未回答', time_point_end: '未回答', time_interval: '未回答')
    order.save
    # 2日目，雨
    order = StageOrder.new( group_id: id, fes_date_id: 3, is_sunny: false, time_point_start: '未回答', time_point_end: '未回答', time_interval: '未回答')
    order.save
  end

  # ステージ企画の場所決定用のレコードを生成
  def init_assign_stage
    return unless group_category_id == 3 # ステージ企画でなければ戻る
    return unless orders = StageOrder.where(group_id: id)
    empty = "未回答"

    Stage.find_or_create_by(id: 0, name_ja:"未入力")

    orders.each do |ord|
      as = AssignStage.find_or_initialize_by(stage_order_id: ord.id)
      as.stage_id = 0
      as.time_point_start = empty
      as.time_point_end   = empty
      as.save(validate: false) if as.new_record?
    end
  end

  def init_place_order
    return if group_category_id == 3 # ステージ企画ならば戻る
    order = PlaceOrder.new( group_id: id )
    order.save
  end

  def init_stage_common_option # StageCommonOptionのレコードが無ければ登録
    return unless group_category_id == 3 # ステージ企画でなければ戻る
    order = StageCommonOption.new( group_id: id, own_equipment: false, bgm: false, camera_permittion: false, loud_sound: false, stage_content: '未回答' )
    order.save
  end

  def is_exist_subrep
    # 副代表の有無
    num_subrep = self.sub_reps.count
    return num_subrep > 0 ? true : false
  end

  def self.get_has_subreps(user_id)
    # 副代表が登録済みの団体を返す
    return Group.joins(:sub_reps).where(user_id: user_id)
  end
end
