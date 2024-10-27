class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  #
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  #
  attr_accessor :remember_token
  before_save { email.downcase! }
  validates   :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates   :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  class << self
      # 渡された文字列のハッシュ値を返す
      def digest(string)
          cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
          BCrypt::Password.create(string, cost: cost)
      end

      # ランダムなトークンを返す
      def new_token
          SecureRandom.urlsafe_base64
      end
  end

  # 永続的セッションのためにユーザーをデータベースに記憶する
  def remember
      self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest(remember_token))
      remember_digest
  end

  # セッションハイジャック防止のためにセッショントークンを返す
  # この記憶ダイジェストを再利用しているのは単に利便性のため
  def session_token
    remember_digest || remember
  end

    # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  def feed
    Question.where("user_id = ?", id)
  end

  # コミュニティをフォローする
  def follow(community)
    following << community unless self == User.find(community.creator_id)
  end

  # コミュニティをフォロー解除する
  def unfollow(community)
    following.delete(community)
  end

  # 現在のユーザーがそのコミュニティをフォローしていればtrueを返す
  def following?(community)
    following.include?(community)
  end

  
end