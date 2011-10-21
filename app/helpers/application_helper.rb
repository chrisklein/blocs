module ApplicationHelper
  
  # Return a title on a per-page basis.
  def title
    base_title = "Blocs"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}" 
    end   
  end
  
  def logo
    image_tag("blocs_logo.png", :alt => "Sample App", :class => "round")
  end  
  
  def google_api_img 
    image_tag("google_api.png", :class => "off-page")
  end
  
end
