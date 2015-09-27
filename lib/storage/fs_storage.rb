class FSStorage < InterfaceStorage

  attr_accessor :root, :report_folder, :file_extension, :file_splitter

  #Set configuration for file system storage

  def set_config(config)
    @root = config['root']
    @report_folder = config['report_folder']
    @file_extension = config['file_extension']
    @file_splitter = config['file_splitter']
  end

  #Save report on filesystem

  def save_report(report)
    _file = report.domain +
            @file_splitter +
            report.date +
            @file_extension

    _file = File.join(@root, @report_folder, _file)
    File.open(_file, 'w') { |f| f.write(YAML.dump(report)) }

  end


  #Fetching all reports only for VIEW (NOT OBJECTS Report)
  #
  # VIEW create link GET /report?domain=vk.com&date=23-09-2015 00:43:44
  #
  #Report file name consist of domain + splitter '_' + Date format %d-%m-%Y %H:%M:%S
  def all_reports

    _result = []

    Dir.glob(File.join(@root, @report_folder,'*'+@file_extension)) do |file|
      _tmp = File.basename(file, @file_extension).split(@file_splitter)


      _result << {
          domain: _tmp[0],
          date: _tmp[1]
      }

    end

    _result

  end


  def find_report(domain, date)

    _file = domain +
            @file_splitter +
            date +
            @file_extension

    _file = File.join(@root, @report_folder, _file)

    YAML.load(File.read(_file))
  end


end