class Application < Sinatra::Application

  # WARDEN SECTION ################################
  enable :sessions
  register Sinatra::Flash
  set :session_secret, "supersecret"

  use Warden::Manager do |config|
    # Tell Warden how to save our User info into a session.
    # Sessions can only take strings, not Ruby code, we'll store
    # the User's `id`
    config.serialize_into_session{|user| user.id }
    # Now tell Warden how to take what we've stored in the session
    # and get a User from that information.
    config.serialize_from_session{|id| User.get(id) }

    config.scope_defaults :default,
                          # "strategies" is an array of named methods with which to
                          # attempt authentication. We have to define this later.
                          strategies: [:password],
                          # The action is a route to send the user to when
                          # warden.authenticate! returns a false answer. We'll show
                          # this route below.
                          action: 'auth/unauthenticated'
    # When a user tries to log in and cannot, this specifies the
    # app to send the user to.
    config.failure_app = self
  end

  Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:password) do
    def valid?
      params['user'] && params['user']['username'] && params['user']['password']
    end

    def authenticate!
      user = User.first(username: params['user']['username'])

      if user.nil?
        throw(:warden, message: 'The username you entered does not exist.')
      elsif user.authenticate(params['user']['password'])
        success!(user)
      else
        throw(:warden, message: 'The username and password combination.')
      end
    end
  end


  # WARDEN END ###################################


  set :root, File.dirname(__FILE__)
  set :public_folder, File.join(root, 'public')
  #set :show_exceptions, false

  #CONFIGURATION
  #1. FSStorage - file system storage
  #2. DBStorage - database storage
  #3. ORMDMStorage - ORM database storage

  set :implementation, 'ORMDMStorage'

  storage_config = YAML.load(File.read(File.join(File.dirname(__FILE__), 'lib/configure/storage_config.yml')))


  get '/' do

    # _storage = InterfaceStorage.new.set_implementation(settings.implementation)
    # _storage.set_config(storage_config[settings.implementation])
    #
    #
    # @reports = _storage.all_reports

    _storage = InterfaceStorage.new.set_implementation(settings.implementation)
    _storage.set_config(storage_config[settings.implementation])

    @reports = _storage.all_reports

    slim :index
  end

  get '/report' do

    _storage = InterfaceStorage.new.set_implementation(settings.implementation)
    _storage.set_config(storage_config[settings.implementation])

    @report_data = _storage.find_report(params[:domain], params[:date])

    puts @report_data.inspect

    slim :report
  end
  
  post '/report' do




    _analyzer = Analyzer.new(params[:url])
    _report = _analyzer.generate

    _storage = InterfaceStorage.new.set_implementation(settings.implementation)
    _storage.set_config(storage_config[settings.implementation])

    puts _report.inspect

    _storage.save_report(_report)

    redirect '/'

  end


  # WARDEN

  get '/auth/login' do
    slim :login
  end

  post '/auth/login' do
    env['warden'].authenticate!

    flash[:success] = env['warden'].message

    if session[:return_to].nil?
      redirect '/'
    else
      redirect session[:return_to]
    end
  end

  get '/auth/logout' do
    env['warden'].raw_session.inspect
    env['warden'].logout
    flash[:success] = 'Successfully logged out'
    redirect '/'
  end

  post '/auth/unauthenticated' do
    session[:return_to] = env['warden.options'][:attempted_path] if session[:return_to].nil?

    # Set the error and use a fallback if the message is not defined
    flash[:error] = env['warden.options'][:message] || "You must log in"
    redirect '/auth/login'
  end

  get '/protected' do
    env['warden'].authenticate!

    slim :protected
  end


end
