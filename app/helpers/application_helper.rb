# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def image_effects
    return IMAGE_EFFECTS.sort_by {|key, value| value}
  end
  
  def smart_add_url_protocol(url)
    url = 'http://' + url unless url[/^(http|https):\/\//]
    url = url.strip + ".com" unless url.include?(".")
    return url
  end

end
