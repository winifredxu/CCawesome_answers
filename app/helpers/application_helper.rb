module ApplicationHelper
	
	def stdDate
		date.strftime("%Y-%B-%d") if date
	end

end
