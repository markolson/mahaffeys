class ClubStatus
	def self.convert(beers)
		case beers
		when 100..299 then 
			[100, '#41444D'.to_color]
		when 300..399 then
			[300, '#9DA7A8'.to_color]
		when 400..499 then
			[400, '#026475'.to_color]
		when 500..999 then
			[500, '#B7974C'.to_color]
		when 1000..1999 then
			[1000, '#7B6035'.to_color]
		when 2000..2499 then
			[2000, '#989483'.to_color]
		when 2500..2**32
			[2500, '#FBB829'.to_color]
		else 
			nil
		end
	end
end