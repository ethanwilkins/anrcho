class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :security_token, :paginate, :page_size, :reset_page, :char_codes
  
  # still needs to account for ip in case of bots
  def security_token
    if cookies[:token].nil? or \
      cookies[:token_birthdate].to_date != Date.today
      cookies.permanent[:token] = SecureRandom.urlsafe_base64
      cookies.permanent[:token_birthdate] = Date.today
    end
    return cookies[:token].to_s
  end
  
  def paginate items, _page_size=page_size
    return items.
      # drops first several posts if :feed_page
      drop((session[:page] ? session[:page] : 0) * _page_size).
      # only shows first several posts of resulting array
      first(_page_size)
  end

  def page_size
    @page_size = 5
  end
  
  def reset_page
    # resets back to top
    unless session[:more]
      session[:page] = nil
    end
  end
  
  def char_codes items
    codes = []; for item in items
      for char in item.body.split("")
        codes << char.codepoints.first * 0.01
      end
    end
    return codes
  end
end
