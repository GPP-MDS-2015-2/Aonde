module ProgramHelper
=begin
	def exibe_dados
		a = []
		Program.all.each do |p|
			a << p.id
		end
		return a
	end
=end
end
