class Status < ActiveRecord::Base
  include PublicActivity::Model

  belongs_to :user
  belongs_to :group

  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :comments, allow_destroy: :true

  default_scope -> {order(created_at: :desc)}

  mount_uploader :picture_status, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 2000}
  validate  :picture_size

   # acts_as_votable

  scope :status_in_group, ->(group_id){where group_id: group_id}

  def name
    content.split(//).first(30).join
  end

  private
  # Validates the size of an uploaded picture.
  def picture_size
    if picture_status.size > 5.megabytes
      errors.add(:picture_status, "should be less than 5MB")
    end
  end

end
