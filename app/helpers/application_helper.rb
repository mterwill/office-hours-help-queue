module ApplicationHelper
  def gravatar_url_for(user)
    # This assumes the email has no whitespace to be trimmed
    email = user.email.downcase
    
    hash = Digest::MD5.new << email

    "https://www.gravatar.com/avatar/" + hash.hexdigest
  end
end
