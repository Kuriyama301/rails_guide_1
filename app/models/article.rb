class Article < ApplicationRecord
  include Visible

  has_many :comments, dependent: :destroy

  EMBED_TYPES = ['youtube', 'twitter']

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
  validates :embed_type, inclusion: { in: EMBED_TYPES }, allow_nil: true
  validate :embed_url_format

  after_initialize :set_default_status, if: :new_record?

  def youtube_id
    extract_youtube_id(embed_url) if embed_type == 'youtube'
  end

  def embed_content
    case embed_type
    when 'youtube'
      youtube_embed
    when 'twitter'
      twitter_embed
    end
  end

  private

  def set_default_status
    self.status ||= 'public'
  end

  def youtube_embed
    "<iframe width='560' height='315' src='https://www.youtube.com/embed/#{youtube_id}' frameborder='0' allowfullscreen></iframe>" if youtube_id
  end

  def twitter_embed
    "<blockquote class='twitter-tweet'><a href='#{embed_url}'></a></blockquote><script async src='https://platform.twitter.com/widgets.js' charset='utf-8'></script>" if embed_url
  end

  def extract_youtube_id(url)
    url[/(?<=v=)[\w-]+/] || url[/(?<=youtu.be\/)[\w-]+/] if url
  end

  def embed_url_format
    case embed_type
    when 'youtube'
      unless embed_url =~ /\A(https?\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.+\z/
        errors.add(:embed_url, "有効なYouTube URLではありません")
      end
    when 'twitter'
      unless embed_url =~ /\Ahttps?:\/\/twitter\.com\/(?:#!\/)?(\w+)\/status(es)?\/(\d+)\z/
        errors.add(:embed_url, "有効なTwitter URLではありません")
      end
    end
  end
end
