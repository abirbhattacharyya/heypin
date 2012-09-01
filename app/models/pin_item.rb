class PinItem < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :include => :user
  
  attr_accessor :image_remote_url
  
  before_validation :download_remote_image, :if => :image_url_provided?
  file_column :image_url,:magick => {:versions => { "normal" => "190x" },
                                      :attributes => { :size => 100, :quality => 100 } 
                                    }
  TYPES ={
    :add_pin => 1,
    :upload_pin => 2,
    :distort  => 3
  }
  validates_presence_of :image_url
  validates_presence_of :description

  after_create :add_points
  
  def image_url_provided?
    !self.image_remote_url.blank?
  end

  def download_remote_image
    self.image_url = do_download_remote_image
    #self.image_remote_url = image_url
  end

  def do_download_remote_image
    io = open(URI.parse(image_remote_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  #rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)

  end

  def add_points
    user_point = UserPoint.new
    user_point.user_id = self.user_id
    point_type = UserPoint::POINT_TYPES[TYPES.index(self.pin_type)][:type]
    user_point.point_type = point_type
    points = UserPoint::POINT_TYPES[TYPES.index(self.pin_type)][:points]
    user_point.points = points
    user_point.pin_item_id = self.id
    user_point.save!
  end

end
