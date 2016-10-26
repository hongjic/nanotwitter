helpers do
  def protected!
    @users = User.all
    return if authorized! == true
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end


    def authorized!

    #@auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth = Rack::Auth::Basic::Request.new(request.env)
    #byebug
    #@auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [@users.find_by(email: @auth.credentials[0]).email, @users.find_by(email: @auth.credentials[0]).password]
        if @auth.provided? == false

          return false
        elsif @users.find_by(email: @auth.credentials[0]) == nil
          return false
        elsif @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [@users.find_by(email: @auth.credentials[0]).email, @users.find_by(email: @auth.credentials[0]).password]
          true
        end

    end

    def terminate!
      @auth = nil
      byebug
      "aldskas"
    end
end