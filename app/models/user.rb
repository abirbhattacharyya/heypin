class User < ActiveRecord::Base
  has_many :pin_items
  has_many :comments
  has_many :user_points
  has_many :user_likes, :class_name => "UserPoint", :conditions => "point_type = #{UserPoint::POINT_TYPES[:like][:type]}"
  
  
  def display_name
    (self.name || self.email)
  end
  
  def points
    self.user_points.all.sum{|p| p.points}
  end
  
  def liked_pin_points
    self.user_points.count(:conditions => ["points > 0 AND point_type in (?)", [UserPoint::POINT_TYPES[:like][:type]]]).to_i
  end
  
  def inverted_pin_points
    self.user_points.count(:conditions => ["points > 0 AND point_type in (?)", [UserPoint::POINT_TYPES[:distort][:type]]]).to_i
  end
  
  def created_pin_points
    self.user_points.count(:conditions => ["points > 0 AND point_type in (?)", [UserPoint::POINT_TYPES[:add_pin][:type], UserPoint::POINT_TYPES[:upload_pin][:type]]]).to_i
  end
  
  def self.fb_omni(auth_token)
    @fb_user ||= FbGraph::User.me(auth_token).fetch
  end
end
