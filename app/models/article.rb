class Article < ApplicationRecord
  include Visible

  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }

  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= 'public'
  end
end
