class Article < ApplicationRecord
  include Visible

  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
  validates :youtube_url, format: { with: /\A(https?\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.+\z/, message: "有効なYouTube URLではありません" }, allow_blank: true
  after_initialize :set_default_status, if: :new_record?

  def youtube_id
    if youtube_url.present?
      extract_youtube_id(youtube_url)
    end
  end

  private

  def set_default_status
    self.status ||= 'public'
  end

  def extract_youtube_id(url)
    url[/(?<=v=)[\w-]+/] || url[/(?<=youtu.be\/)[\w-]+/]
  end
end
