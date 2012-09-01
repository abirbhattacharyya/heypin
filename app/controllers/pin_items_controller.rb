require 'fileutils'
require 'RMagick'

class PinItemsController < ApplicationController
  include FileColumnHelper
  before_filter :check_login,:except => [:show]
  
  def get_images
    url = params[:pin_url].strip if params[:pin_url]
    begin
      url = smart_add_url_protocol(url)
      url = get_special_url(url)
      parse_url = URI.parse(url)
      res = Net::HTTP.start(parse_url.host, parse_url.port) {|http|
          http.get('/')
      }
      url =  res['location'] unless res['location'].blank?      
      if is_image_url?(url)
        @images = [url]
      else
        @images =fetch_images(url)
      end
    rescue => e
      puts "-"*40
      puts e
      puts "-"*40
      @images = 0
    end
    if @images == 0
      @message = "Invalid url"
    end
#    @pin_item = PinItem.new    
    render :update do |page|
      if @message
        page.replace_html :image_lists, @message
      else
        page.replace_html :image_lists, :partial => "/partials/images"
      end
#      page["find_imgs_submit"].disabled = false;
      page["spinner_span"].hide();
    end
  end

  def add_pin_item
    @pin_item = PinItem.new(params[:pin_image])
    @pin_item.image_remote_url = params[:image_url]
    @pin_item.user_id = current_user.id
    @pin_item.save!
    
    image_effects.each do |effect, value|
      image_path = url_for_file_column(@pin_item,:image_url)
      generate_preview_image(image_path, value, @pin_item)
    end
    flash[:notice] = "Hey! Thanks for creating"
    redirect_to pin_item_path(@pin_item.id)
#  rescue => e
#    puts "-"*50
#    puts @pin_item.errors.full_messages.inspect
#    puts e.message.inspect
#    puts "-"*50
  end

  def upload_pin
    file = params[:pin_item][:image_url]
    extension = File.extname(file.original_filename)
    temp_folder_path = "#{RAILS_ROOT}/public/tmp"
    puts File.directory?(temp_folder_path)
     unless File.directory?(temp_folder_path)
       FileUtils.mkdir_p temp_folder_path
     end
    new_file_name = "#{Time.now.to_i}#{extension}"
    new_file_path = File.join(temp_folder_path,new_file_name)
    File.open(new_file_path,"wb"){|f| f.write(file.read)}
    img = File.join(root_url,"tmp/#{new_file_name}")
    render :text => img
  rescue => e
    puts "-"*40
    puts e
    render :text => nil
  end

  
  def effects
    @pin_item = PinItem.find(params[:id])
    image_path = url_for_file_column(@pin_item,:image_url)
    @extension = File.extname(image_path)
    @basic_path = image_path.rpartition("/").first
  end
  
  def comment
    @pin_item = PinItem.find(params[:id])
    comment = params[:comment]
    if comment
      @comment = current_user.comments.new(:pin_item_id => @pin_item.id, :comment => comment.strip)
      if @comment.valid?
        @comment.save
        redirect_to root_path, :notice => "Comment submited successfully."
      else
        flash[:notice] = @comment.errors.first[1]
      end
    end
  end
  
  def show
    @pin_item = PinItem.find(params[:id])
  end

  def set_like
#    pin_item = PinItem.find(params[:id])
    pin_item_id = params[:id]

    user_point = UserPoint.new(:user_id => current_user.id,:pin_item_id => pin_item_id)
    user_point.point_type = UserPoint::POINT_TYPES[:like][:type]
    user_point.points = UserPoint::POINT_TYPES[:like][:points]
    user_point.save
#    flash.now[:notice] = "#{pin_item_id} is liked"

    render :update do |page|
      page.select("span#pin_like_#{pin_item_id}").each do |item|
        #page.replace_html item,(link_to_remote("Unlike",:url => set_unlike_pin_item_path(pin_item_id),:html => {:class => "like"}))
        page.call "showNotification", "Cool! Thanks for the love!", "notice"
        page.visual_effect :fade, item
        page.delay(5.seconds) do
          page.hide item
        end
      end
    end

  end

  def set_unlike
#    pin_item = PinItem.find(params[:id])
    pin_item_id = params[:id]

    user_like = UserLike.find(:first,:conditions => ["user_id = ? AND pin_item_id = ?",current_user.id,pin_item_id])

    user_like.destroy if user_like
    render :update do |page|
      page.select("span#pin_like_#{pin_item_id}").each do |item|
        page.replace_html item,(link_to_remote("Like",:url => set_like_pin_item_path(pin_item_id),:html => {:class => "like"}))
      end
    end

  end
  
  def apply_effect
#    render :text => params.inspect and return false
    pin_item = PinItem.find(params[:id])
    effect = params[:image_effect]
    image_path = url_for_file_column(pin_item,:image_url)
    extension = File.extname(image_path)
    basic_path = image_path.rpartition("/").first
    image_url = File.join(basic_path,"#{effect}_#{pin_item.id}" + extension)
#    render :text => image_url.inspect and return false
    
    @pin_item = PinItem.new
    @pin_item.description = pin_item.description
    @pin_item.pin_type = PinItem::TYPES[:distort]
    @pin_item.image_remote_url = File.join(root_url, image_url)
    @pin_item.user_id = current_user.id
    @pin_item.save!

    user_point = UserPoint.new(:user_id => pin_item.user_id)
    point_type = UserPoint::POINT_TYPES[PinItem::TYPES.index(@pin_item.pin_type)][:type]
    user_point.point_type = point_type
    points = UserPoint::POINT_TYPES[PinItem::TYPES.index(@pin_item.pin_type)][:points]
    user_point.points = -points
    user_point.pin_item_id = pin_item.id
    user_point.save!
    
    image_effects.each do |effect, value|
      image_path = url_for_file_column(@pin_item, :image_url)
      generate_preview_image(image_path, value, @pin_item)
    end
    
    redirect_to root_path
  end
  
  

  protected

  def get_special_url(url)
    spec_urls = {
      "http://www.bestbuy.com" => "http://www.bestbuy.com/site/index.jsp",
      "http://bestbuy.com" => "http://www.bestbuy.com/site/index.jsp"
    }
    new_url =spec_urls[url]
    if new_url
      url = new_url
    end
    return url
  end

  def is_image_url?(img_url)    
    return false if img_url.nil?
    img_data = open(img_url, "rb").read
    img_size = ImageSize.new(img_data).size
    if img_size.nil?
      return false
    else 
      return true
    end
  end

  private
  
  def fetch_images(url)
    return [] if url.nil?
      parse_url = URI.parse(url)

      host_name = parse_url.scheme + "://" +parse_url.host
      host_name += ":#{parse_url.port}" unless parse_url.port == 80
      url_content = open(url, 'User-Agent' => 'ruby').read
      url_data = Nokogiri::HTML(url_content)
      images = Array.new
      all_images = Array.new
      url_data.xpath("/html/body//img").each do |img|
       src = img["src"]
       full_img_src = src.match(/^(http|https):\/\//) ? src : File.join(host_name,src)
    #   puts "#{full_img_src}"
       next if all_images.include?(full_img_src)
       all_images.push(full_img_src)

#       puts "Imag : #{full_img_src}"

       images.push(full_img_src) if valid_image(full_img_src)
       #break if images.size > 3
     end
     return images.uniq
  rescue => e
      puts "Error: #{e}"
    return 0
  end

  def valid_image(img_url)
    return false if img_url.nil?
    valid_img = false
    img_data = open(img_url, "rb").read
    min_size  = [100,100]
    img_size = ImageSize.new(img_data).size
    if img_size[0] >= min_size[0] and img_size[1] >= min_size[1]
      valid_img = true
    end
    return valid_img
  rescue
    return false
  end

  def generate_preview_image(image_path,effect,pin_item)
    extension = File.extname(image_path)
    root_path = File.join(RAILS_ROOT,"public")
    basic_path = image_path.rpartition("/").first
    new_image_path = File.join(basic_path,"#{IMAGE_EFFECTS.index(effect)}_#{pin_item.id}" + extension) if effect != 0
    abs_image_path = File.join(root_path,image_path)
    @full_path = new_image_path
    case effect
      when 0
        @error = "Please select effect style."
      when IMAGE_EFFECTS["flip"]
        image = Magick::ImageList.new(abs_image_path)
        image.flip!
        image.write(File.join(root_path,new_image_path))
      when IMAGE_EFFECTS["add_text"]
        image = Magick::ImageList.new(abs_image_path)
        text = Magick::Draw.new
        text.annotate(image, 0, 0, 0, 60, "Sample Text") {
            self.gravity = Magick::SouthGravity
            self.pointsize = 30
            self.stroke = 'transparent'
            self.fill = '#0000A9'
            self.font_weight = Magick::BoldWeight
            }
        image.write(File.join(root_path,new_image_path))
      when IMAGE_EFFECTS["black_and_white"]
        image = Magick::ImageList.new(abs_image_path)
        image = image.quantize(256, Magick::GRAYColorspace)
        image.write(File.join(root_path,new_image_path))

      when IMAGE_EFFECTS["edges"]
        image = Magick::ImageList.new(abs_image_path)
        image = image.raise
        image.write(File.join(root_path,new_image_path))

      when IMAGE_EFFECTS["polaroid"]
        image = Magick::Image.read(abs_image_path).first
        cols, rows = image.columns, image.rows

        image[:caption] = "Hi!"
        image = image.polaroid { self.gravity = Magick::CenterGravity }

        image.change_geometry!("#{cols}x#{rows}") do |ncols, nrows, img|
            img.resize!(ncols, nrows)
        end
        image.write(File.join(root_path,new_image_path))
      when IMAGE_EFFECTS["emboss"]
        image = Magick::ImageList.new(abs_image_path)
        image = image.emboss
        image.write(File.join(root_path,new_image_path))

      when IMAGE_EFFECTS["implode"]
        image = Magick::ImageList.new(abs_image_path)
        image = image.implode(0.4)
        image.write(File.join(root_path,new_image_path))

      when IMAGE_EFFECTS["negate"]
        image = Magick::ImageList.new(abs_image_path)
        image = image.negate
        image.write(File.join(root_path,new_image_path))

      when IMAGE_EFFECTS["wave"]
        image = Magick::ImageList.new(abs_image_path)
        image = image.wave
        image.write(File.join(root_path,new_image_path))

      when IMAGE_EFFECTS["vignette"]
         image = Magick::Image.read(abs_image_path).first
        image = image.vignette
        image.write(File.join(root_path,new_image_path))

      when IMAGE_EFFECTS["oil_paint"]
        image = Magick::ImageList.new(abs_image_path)
        image = image.oil_paint
        image.write(File.join(root_path,new_image_path))

      when IMAGE_EFFECTS["spread"]
        image = Magick::ImageList.new(abs_image_path)
        image = image.spread
        image.write(File.join(root_path,new_image_path))

      when IMAGE_EFFECTS["spread"]
        image = Magick::ImageList.new(abs_image_path)
        image = image.spread
        image.write(File.join(root_path,new_image_path))

      when IMAGE_EFFECTS["rotate_90_degree"]
        image = Magick::ImageList.new(abs_image_path)
        image = image.rotate(90)
        image.write(File.join(root_path,new_image_path))
    end
  end
end
