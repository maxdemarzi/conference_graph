class CG::App
  module Helpers
  
    def current_user
      @current_user ||= User.find_by_uid(session[:uid]) if session[:uid]
    end

    def private_page!
      if current_user.nil?
        redirect to('/')
      end
    end
  
    def partial(name, options={})
      haml("_#{name.to_s}".to_sym, options.merge(:layout => false))
    end
    
  end
end