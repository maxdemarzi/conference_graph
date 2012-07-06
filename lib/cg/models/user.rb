module CG  
  class User < Neography::Node
    @neo_server = Neography::Rest.new
  
    def self.find_by_uid(uid)
      user = @neo_server.get_node_index("users_index", "uid", uid)
  
      if user && user.first["data"]["token"]
        self.new(user.first)
      else
        nil
      end
    end
  
    def self.create_with_omniauth(auth)
      node = @neo_server.create_unique_node("users_index", "uid", auth.uid)
      @neo_server.set_node_properties(node, 
                                      {"name"       => auth.info.name,
                                        "nickname"  => auth.info.nickname,
                                        "location"  => auth.info.location,
                                        "image_url" => auth.info.image,
                                        "uid"       => auth.uid,
                                        "token"     => auth.credentials.token, 
                                        "secret"    => auth.credentials.secret})
      
      Sidekiq::Client.enqueue(CG::Job::ImportTwitterFollows, auth.uid)
      User.load(node)
    end
  
    def client
      @client ||= Twitter::Client.new(
        :oauth_token        => self.token,
        :oauth_token_secret => self.secret
       )
    end
  
    def self.create_from_twitter(friend)
      user = @neo_server.create_unique_node("users_index", "uid", friend.id,
                         {"name"      => friend.name,
                          "nickname"  => friend.screen_name,
                          "location"  => friend.location,
                          "image_url" => friend.profile_image_url,
                          "uid"       => friend.id
                          })
      user
    end
end  
  end