module CG
  class Api < Sinatra::Base

    configure do
      set :session_secret, ENV['SESSION_SECRET']
      set :key, ENV['CONSUMER_KEY']
      set :secret, ENV['CONSUMER_SECRET']
      set :redis_url, ENV['REDISTOGO_URL']
      set :neo, Neography::Rest.new
    end

    configure :development do
      register Sinatra::Reloader
    end
        
    before do
      content_type :json
      headers \
        "Access-Control-Allow-Origin" => "*",
        "Access-Control-Allow-Methods" => "GET, POST, PUT, DELETE, OPTIONS, HEAD",
        "Access-Control-Allow-Headers" => "Content-Type"
    end
    set :environment, :production

    error do
      e = env['sinatra.error']
      message = e.message.nil? ? "Oh oh... something went wrong." : e.message

      status case e.class
             when CG::Error::User::OmniAuthHashRequired,
                  CG::Error::User::OmniAuthInvalidProvider,
                  CG::Error::User::OmniAuthHashCredentialsRequired,
                  CG::Error::User::OmniAuthHashInfoRequired,
                  CG::Error::User::OmniAuthHashInfoEmailRequired,
                  CG::Error::User::OmniAuthHashUIDRequired,
                  CG::Error::User::TokenRequired,
                  CG::Error::User::TokenInvalid

               401
             when CG::Error::User::AuthenticationError,
                  CG::Error::User::UnauthorizedToAddAccountError
               403
             when CG::Error::User::NotFoundError
               404  
             else
               400
             end
      Airbrake.notify(e) unless (development? || test?)
      {:error => message, :type => e.class.name}.to_json
    end

    options '*' do
      
    end

    def current_user
      token = params[:t] || params[:token]
      raise CG::Error::User::TokenRequired if token.nil? 
      user = CG::User.where(:token => token).first
      raise CG::Error::User::TokenInvalid if user.nil?

      user
    end

    def page
      (params[:p] || params[:page] || 1).to_i
    end

    get '/' do
      'CG API'
    end

  end
end
