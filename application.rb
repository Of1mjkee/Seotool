class Application < Sinatra::Application


  set :root, File.dirname(__FILE__)
  set :public_folder, File.join(root, 'public')
  #set :show_exceptions, false

  puts settings.root

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


end
