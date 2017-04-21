PlaceAllowList.seed( :id,
  # 模擬店(食品販売)
  { id: 1,  place_id: 1,  group_category_id: 1, enable: true  }, #事務棟エリア
  { id: 2,  place_id: 2,  group_category_id: 1, enable: true  }, #図書館エリア
  { id: 3,  place_id: 3,  group_category_id: 1, enable: true  }, #福利棟エリア
  { id: 4,  place_id: 4,  group_category_id: 1, enable: true  }, #ステージエリア
  { id: 5,  place_id: 5,  group_category_id: 1, enable: true  }, #体育館エリア
  { id: 6,  place_id: 6,  group_category_id: 1, enable: false }, #セコムホール
  { id: 7,  place_id: 7,  group_category_id: 1, enable: false }, #電気棟204
  { id: 8,  place_id: 8,  group_category_id: 1, enable: false }, #電気棟206
  { id: 9,  place_id: 9,  group_category_id: 1, enable: false }, #電気棟208
  { id: 10, place_id: 10, group_category_id: 1, enable: false }, #電気棟212
  { id: 11, place_id: 11, group_category_id: 1, enable: false }, #電気棟310
  { id: 12, place_id: 12, group_category_id: 1, enable: false }, #講義棟部屋A
  { id: 13, place_id: 13, group_category_id: 1, enable: false }, #講義棟部屋B
  { id: 14, place_id: 14, group_category_id: 1, enable: false }, #マルチメディア
  { id: 15, place_id: 15, group_category_id: 1, enable: false }, #グラウンド
  { id: 16, place_id: 16, group_category_id: 1, enable: true  }, #規定外の場所
  # 模擬店(物品販売)
  { id: 17,  place_id: 1,  group_category_id: 2, enable: true  }, #事務棟エリア
  { id: 18,  place_id: 2,  group_category_id: 2, enable: true  }, #図書館エリア
  { id: 19,  place_id: 3,  group_category_id: 2, enable: true  }, #福利棟エリア
  { id: 20,  place_id: 4,  group_category_id: 2, enable: true  }, #ステージエリア
  { id: 21,  place_id: 5,  group_category_id: 2, enable: true  }, #体育館エリア
  { id: 22,  place_id: 6,  group_category_id: 2, enable: false }, #セコムホール
  { id: 23,  place_id: 7,  group_category_id: 2, enable: false }, #電気棟204
  { id: 24,  place_id: 8,  group_category_id: 2, enable: false }, #電気棟206
  { id: 25,  place_id: 9,  group_category_id: 2, enable: false }, #電気棟208
  { id: 26,  place_id: 10, group_category_id: 2, enable: false }, #電気棟212
  { id: 27,  place_id: 11, group_category_id: 2, enable: false }, #電気棟310
  { id: 28,  place_id: 12, group_category_id: 2, enable: true  }, #講義棟部屋A
  { id: 29,  place_id: 13, group_category_id: 2, enable: true  }, #講義棟部屋B
  { id: 30,  place_id: 14, group_category_id: 2, enable: false }, #マルチメディア
  { id: 31,  place_id: 15, group_category_id: 2, enable: false }, #グラウンド
  { id: 32,  place_id: 16, group_category_id: 2, enable: false }, #規定外の場所
  # 展示
  { id: 33,  place_id: 1,  group_category_id: 4, enable: false }, #事務棟エリア
  { id: 34,  place_id: 2,  group_category_id: 4, enable: false }, #図書館エリア
  { id: 35,  place_id: 3,  group_category_id: 4, enable: false }, #福利棟エリア
  { id: 36,  place_id: 4,  group_category_id: 4, enable: false }, #ステージエリア
  { id: 37,  place_id: 5,  group_category_id: 4, enable: false }, #体育館エリア
  { id: 38,  place_id: 6,  group_category_id: 4, enable: true  }, #セコムホール
  { id: 39,  place_id: 7,  group_category_id: 4, enable: false }, #電気棟204
  { id: 40,  place_id: 8,  group_category_id: 4, enable: false }, #電気棟206
  { id: 41,  place_id: 9,  group_category_id: 4, enable: false }, #電気棟208
  { id: 42,  place_id: 10, group_category_id: 4, enable: false }, #電気棟212
  { id: 43,  place_id: 11, group_category_id: 4, enable: false }, #電気棟310
  { id: 44,  place_id: 12, group_category_id: 4, enable: true  }, #講義棟部屋A
  { id: 45,  place_id: 13, group_category_id: 4, enable: true  }, #講義棟部屋B
  { id: 46,  place_id: 14, group_category_id: 4, enable: true  }, #マルチメディア
  { id: 47,  place_id: 15, group_category_id: 4, enable: true  }, #グラウンド
  { id: 48,  place_id: 16, group_category_id: 4, enable: true  }, #規定外の場所
  # その他
  { id: 49,  place_id: 1,  group_category_id: 5, enable: true }, #事務棟エリア
  { id: 50,  place_id: 2,  group_category_id: 5, enable: true }, #図書館エリア
  { id: 51,  place_id: 3,  group_category_id: 5, enable: true }, #福利棟エリア
  { id: 52,  place_id: 4,  group_category_id: 5, enable: true }, #ステージエリア
  { id: 53,  place_id: 5,  group_category_id: 5, enable: true }, #体育館エリア
  { id: 54,  place_id: 6,  group_category_id: 5, enable: true }, #セコムホール
  { id: 55,  place_id: 7,  group_category_id: 5, enable: false}, #電気棟204
  { id: 56,  place_id: 8,  group_category_id: 5, enable: false}, #電気棟206
  { id: 57,  place_id: 9,  group_category_id: 5, enable: false}, #電気棟208
  { id: 58,  place_id: 10, group_category_id: 5, enable: false}, #電気棟212
  { id: 59,  place_id: 11, group_category_id: 5, enable: false}, #電気棟310
  { id: 60,  place_id: 12, group_category_id: 5, enable: true }, #講義棟部屋A
  { id: 61,  place_id: 13, group_category_id: 5, enable: true }, #講義棟部屋B
  { id: 62,  place_id: 14, group_category_id: 5, enable: true }, #マルチメディア
  { id: 63,  place_id: 15, group_category_id: 5, enable: true }, #グラウンド
  { id: 64,  place_id: 16, group_category_id: 5, enable: true }, #規定外の場所
)
