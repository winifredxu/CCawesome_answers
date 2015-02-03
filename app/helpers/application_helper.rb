module ApplicationHelper
	
	def stdDate(date)
		date.strftime("%Y-%B-%d") if date
	end

end
