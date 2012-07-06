# encoding: utf-8
require 'sinatra/assetpack'
require 'rack-flash'

module CG
  class App < Sinatra::Base

    configure do
      set :session_secret, ENV['SESSION_SECRET']
      set :key, ENV['CONSUMER_KEY']
      set :secret, ENV['CONSUMER_SECRET']
    end

    configure :development do
      register Sinatra::Reloader
    end

    register Sinatra::AssetPack
    
    use Rack::Session::Cookie , :secret => CG::App.settings.session_secret
    
    use OmniAuth::Builder do
      provider :twitter, CG::App.settings.key, CG::App.settings.secret
    end

    use Rack::Flash

    Dir.glob(File.dirname(__FILE__) + '/helpers/*', &method(:require))
    helpers CG::App::Helpers

    assets {
      serve '/js/app', from: '/assets/coffee'
      serve '/css', from: '/assets/css'

      js :lib, '/js/lib.js', [
        '/js/lib/jquery.js',
        '/js/lib/jquery-ui-custom.js'
      ]
      
      js :app, '/js/app.js', [
        '/js/app/app.js',
        '/js/app/helpers.js',
        '/js/app/master.js'
      ]

      css :app, '/css/app.css', [
        '/css/reset.css',
        '/css/style.css'
      ]
      
      css :ie, '/css/ie.css', [
        '/css/ie.css'
      ]

      js_compression :uglify
    }

    before do
      if request.path_info.index("/css") == 0 || request.path_info.index("/js") == 0
        #disable session and delete all request cookies for js/css - allows proxy caching
        disable :sessions
        request.cookies.clear
      else
      end
    end

    # Homepage
    get '/' do
      if current_user.nil?
        haml :index, :layout => :layout
      else
        redirect to('/conferences')
      end
    end

    # View Current and Upcoming Conferences
    get '/conferences/?' do
      haml :conferences
    end

    # View Twitter Friends
    get '/friends/?' do
      private_page!
      
      haml :friends
    end

    # Authentication
    ['get', 'post'].each do |method|
      send(method, "/auth/:provider/callback") do
        user = CG::User.create_with_omniauth(env['omniauth.auth'])
        session[:user_id] = user.id.to_s

        redirect to(session[:redirect_url] || '/conferences')
        session[:redirect_url] = nil
      end
    end

    get '/auth/failure/?' do
      raise 'auth error'
    end

    get '/logout/?' do
      session.clear
      redirect to('/')
    end

    # Static Pages
    get '/welcome/?' do
      private_page!

      @start_url = session[:redirect_url] || '/conferences'
      session[:redirect_url] = nil

      haml :welcome
    end

    get '/about/?' do
      haml :about
    end

    get '/contact/?' do
      haml :contact
    end

    get '/terms' do
      haml :terms
    end

    get '/privacy' do
      haml :privacy
    end

  end
end
