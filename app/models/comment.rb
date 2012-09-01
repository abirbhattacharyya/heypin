class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :pin_item

  validates_presence_of :comment, :message => "Hey, comment can't be blank!"

  after_create :add_points

  def add_points
    user_point = UserPoint.new
    user_point.user_id = self.user_id
    user_point.point_type = UserPoint::POINT_TYPES[:comment][:type]
    user_point.points = UserPoint::POINT_TYPES[:comment][:points]
    user_point.pin_item_id = self.pin_item_id
    user_point.save
  end

end
