class UserPoint < ActiveRecord::Base
  belongs_to :user
  belongs_to :pin_item

  POINT_TYPES ={
    :add_pin => {:type => 1, :points => 100},
    :upload_pin => {:type => 2, :points => 50},
    :comment => {:type => 3, :points => 0},
    :like => {:type => 4, :points => 10},
    :distort => {:type => 5, :points => 10},
  }

end
