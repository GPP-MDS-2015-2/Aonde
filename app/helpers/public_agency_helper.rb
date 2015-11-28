module PublicAgencyHelper
	
	def facebook_share_amount(url_shared)
		url = URI.parse("http://graph.facebook.com/?ids=#{URI.escape(url_shared)}")
		
		data = Net::HTTP.get(url)

	    data = JSON.parse(data)	

    	if data[url_shared]['shares']
    		return data[url_shared]['shares']
    	else
    		return 0
    	end
	end
end	
