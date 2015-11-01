module ProgramHelper
	def exibe_dados
		a = []
		Program.all.each do |p|
			a << p.id
		end
		return a
	end
end
