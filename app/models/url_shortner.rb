class URLShortener
  
  def self.shorten( url )
    Bitly.use_api_version_3
    bitly = Bitly.new( BITLY_CONFIG[:login], BITLY_CONFIG[:api_key] )
    response = bitly.shorten( url )
    response.short_url || ''
  end
  
end