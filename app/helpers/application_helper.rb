module ApplicationHelper
	def full_title(title = "")
		title_default = "AondE"
		if not title.empty?
			return title_default + " - " + title
		else
			return title_default
		end
	end
=begin
#Define how flash messages will work
  def flash_message
    messages = ""
    [:notice, :info, :warning, :error].each {|type|
      if flash[type]
        messages += "<p class=\"#{type}\">#{flash[type]}</p>"
      end
    }

    messages
  end
=end
end
