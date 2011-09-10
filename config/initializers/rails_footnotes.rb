if defined?(Footnotes) && Rails.env.development?
  
  Footnotes.run! # first of all
  
  # add other init code
  
end
