# メインのサンプルユーザーを1人作成する
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end


# ユーザーの一部を対象にクエスチョンを生成する
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.questions.create!(content: content) }
end

#メインのサンプルコミュニティを一つ作る
Community.create!(name: "Example Community", abstruct: "test", creator_id: 1)

#コミュニティを生成する
10.times do |n|
  name = Faker::Name.name
  abstruct = ""
  creator_id = n+1
  Community.create!(name: name, abstruct: abstruct, creator_id: creator_id)
end

# ユーザー->コミュニティなフォローのリレーションシップを作成する
users = User.all
user = User.first
communities = Community.all
community = Community.first
following = communities[2..10]
followers = users[2..30]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(community) }

#ドキュメントの中身を生成
Document.create!(content: "当社のプロジェクト管理方針として、タスクは週ごとに進捗確認を行い、各メンバーが担当分野に集中できるようにします。毎週月曜の定例会で進捗を報告することが求められます。")

Document.create!(content: "新入社員の研修は、3か月間にわたって行われ、社内の各部門をローテーションする形式で進められます。業務知識の理解度に応じて、フィードバックを受けることが重要です。")

Document.create!(content: "社内のリモートワークポリシーとして、週に3日までリモート勤務が可能です。ただし、会議日など重要な日程は出社が求められる場合があります。")