class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    #

    user ||= User.new # guest user (not logged in)
    cannot :manage, :all

    if user.role_id == 1 then # for developer
      # 全てOK
      can :manage, :all
    end
    if user.role_id == 2 then # for manager
      can :manage, :all # 下記以外の全てOK
      cannot [:create, :update, :destroy], Role # roleの作成と編集, 編集, 削除は不可
      cannot [:create, :update, :destroy], User # roleを含むため, Userの作成, 編集, 削除は不可
      cannot [:create, :update, :destroy], RentalItem  # 不用意な増殖・変更を抑止
      cannot [:create, :destroy], RentalOrder # 数量0で対応する．
      cannot [:create, :destroy], StageOrder
      cannot [:create, :destroy], PlaceOrder
      cannot [:destroy], Place # PlaceOrderからfindで引いている．削除は禁止
      cannot [:destroy], Shop, :id => [*(1..23)]  # Shopは1-23のデフォルトの削除禁止
      cannot [:create, :update, :destroy], StockerPlace # 貸出場所は編集不可
      cannot [:destroy], StockerItem  # 貸出物品在庫は削除不可，0で対応
      cannot [:destroy], RentableItem  # 削除不可，0で対応
      cannot [:create,:destroy], PlaceAllowList #場所の許可に関して編集不可
      cannot [:create, :destroy], ConfigUserPermission  # 作成・削除不可
      cannot [:create, :destroy], GroupProjectName # 作成・削除不可
      cannot [:create, :destroy], Stage # 作成・削除不可
      cannot [:create, :destroy], GroupManagerCommonOption # 作成・削除不可
      cannot [:create, :destroy], RentalItemAllowList # 作成・削除不可
      cannot [:destroy], AssignStage # 作成・削除不可
    end
    if user.role_id == 3 then # for user (デフォルトのrole)
      can :manage, :welcome
      #
      # TODO: emailのconfirmで判定する
      # confirmした後のみ各種CURDできるようにさせたい．
      #
      # UserDetailの自分のレコードは作成, 更新, 読みが可能. 削除はだめ.
      can [:read, :create, :update], UserDetail, :user_id => user.id
      # ユーザに紐付いている参加団体
      groups = Group.where( user_id: user.id ).pluck('id')
      # ユーザに紐付き & 副代表が登録済みの団体
      groups_with_subrep = get_groups_with_subrep(groups)

      # 団体 (ConfigUserPermission.id = 1)
      if ConfigUserPermission.find(1).is_accepting
        # 所有するGroupのレコードは自由に触れる
        can :manage, Group, :user_id => user.id
      elsif ConfigUserPermission.find(1).is_only_show
        can :read, Group, :user_id => user.id
      end

      # 企画名
      # ConfigUserPermissionの制御は誰か書いてください
      can :manage, GroupProjectName, :user_id => user.id

      # 副代表 (ConfigUserPermission.id = 2)
      if ConfigUserPermission.find(2).is_accepting
        # 副代表は自分の団体のみ自由に触れる．
        # だたしnewはidに無関係に許可
        can :manage, SubRep, :group_id => groups
        can :new, SubRep
      elsif ConfigUserPermission.find(2).is_only_show
        can :read, SubRep, :group_id => groups
      end

      # 物品貸出 (ConfigUserPermission.id = 3)
      set_noncreate_form(3, RentalOrder, groups_with_subrep)
      # 電力申請 (ConfigUserPermission.id = 4)
      set_create_form(4, PowerOrder, groups_with_subrep)
      # 実施場所 (ConfigUserPermission.id = 5)
      set_noncreate_form(5, PlaceOrder, groups_with_subrep)
      # ステージ (ConfigUserPermission.id = 6)
      set_noncreate_form(6, StageOrder, groups_with_subrep)
      set_noncreate_form(6, StageCommonOption, groups_with_subrep)
      # 従業員 (ConfigUserPermission.id = 7)
      set_create_form(7, Employee, groups_with_subrep)
      # 販売食品 (ConfigUserPermission.id = 8)
      set_create_form(8, FoodProduct, groups_with_subrep)

      # 購入リスト (ConfigUserPermission.id = 9)
      # ユーザの全登録団体のもつ全販売食品
      food_ids = FoodProduct.where( group_id: groups ).pluck('id')
      if ConfigUserPermission.find(9).is_accepting
        # 自分が持つ販売食品に紐付いたもののみ自由に触れる
        can :manage, PurchaseList, :food_product_id => food_ids
      elsif ConfigUserPermission.find(9).is_only_show
        can :read, PurchaseList, :food_product_id => food_ids
      end

      # 店舗リストは読みを許可
      can :read, Shop
    end
  end

  def get_groups_with_subrep(group_ids)
    # 副代表が登録済みのgroup_idsを返す
    subrep_groups = []
    for id in group_ids do
      if Group.find(id).is_exist_subrep
        subrep_groups.push(id)
      end
    end
    return subrep_groups
  end

  # createを必要としないモデル制御
  def set_noncreate_form(form_id, model, groups_with_subrep)
    if ConfigUserPermission.find(form_id).is_accepting
      # 自分の団体 かつ 副代表登録済みなら 読み，更新を許可
      can [:read, :update], model, :group_id => groups_with_subrep
    elsif ConfigUserPermission.find(form_id).is_only_show
      can :read, model, :group_id => groups_with_subrep
    end
  end

  # createが必要なモデル制御
  def set_create_form(form_id, model, groups_with_subrep)
    if ConfigUserPermission.find(form_id).is_accepting
      # 自分の団体 かつ 副代表登録済みなら 全て許可
      # ただしnewはidに無関係に許可 (ページが開けないため)
      can :manage, model, :group_id => groups_with_subrep
      can :new, model
    elsif ConfigUserPermission.find(form_id).is_only_show
      can :read, model, :group_id => groups_with_subrep
    end
  end

end
