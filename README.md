# Group Maneger

ユーザ登録 + 参加団体登録

`git@github.com:NUTFes/sample_admin_roles.git`
`210465e4f714148b3a8f91ed6c908407517654a7`
よりアプリ名を変更

# 実装した機能

* 1ユーザ, 1権限
    - UserモデルとRoleモデルを紐付け
* ユーザ登録時 -> `devise`
    - メール送信, URLを踏むと認証完了(メールアドレス確認)
    - デフォルトroleを設定
* 管理画面 -> `ActiveAdmin`
* アクセス, 機能制限 -> `cancancan`

# 主なgem

```
gem 'rails', '4.2.1'
gem 'pg'

gem 'devise'
gem 'activeadmin', github: 'activeadmin'
gem 'cancancan', '~> 1.10'
```

# 必要な環境変数

```
#Gmailの例
export SMTP_ADRESS=smtp.gmail.com
export SMTP_PORT=587
export EMAIL_DOMAIN=gmail.com
export SMTP_AUTH=plain
export SMTP_TLS=false
export EMAIL_USERNAME=ユーザ@gmail.com
export EMAIL_BCC='sample@example.com'
export EMAIL_PASSWORD=パスワード
export EMAIL_SENDER='送信者名 <ユーザ@gmail.com>'

# local環境で動作させる例
export DEFAULT_URL='localhost:3000'
```

stnを利用する場合
※ パスワードは絶対にgithub上にあげないこと
パスワードを含む環境設定ファイルは別に切り分けて``source``コメンドで読む込むことをおすすめします

```
export SMTP_ADRESS=stn.nagaokaut.ac.jp
export SMTP_PORT=465
export EMAIL_DOMAIN=stn.nagaokaut.ac.jp
export SMTP_AUTH=plain
export SMTP_TLS=true
export DEFAULT_URL=https://nutfes-group-manager.herokuapp.com
export RAILS_SERVE_STATIC_FILES=true

export EMAIL_USERNAME='s******'
export EMAIL_BCC='sample@example.com'
export EMAIL_PASSWORD=stnパスワード
export EMAIL_SENDER='送信者名 <ユーザ@gmail.com>'
```

# Setup方法

`docs/setup.md`を参照

# 作業記録

`docs/log.md`

# データバックアップ方法

[参考 Heroku PGBackups](https://devcenter.heroku.com/articles/heroku-postgres-backups#scheduling-backups)

```
# 一覧
heroku pg:backups
# 必要なバックアップをダウンロード
heroku pg:backups public-url a022
```

### 開発環境リポジトリ

https://github.com/NUTFes/group_manager_env
