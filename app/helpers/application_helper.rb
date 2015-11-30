module ApplicationHelper
	def full_title(title = "")
		title_default = "AondE"
		if not title.empty?
			return title_default + " - " + title
		else
			return title_default
		end
	end

end
