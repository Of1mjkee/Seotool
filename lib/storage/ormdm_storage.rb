class ORMDMStorage < InterfaceStorage

  attr_accessor :config

  def set_config(config)
    @config = config
  end


  def connect

    DataMapper.setup(:default, 'postgres://ofim:bond007@localhost/seodb')
    DataMapper.finalize       # set up all relationships properly
    DataMapper.auto_upgrade! # create database table if it doesn't exist

    # # DOESNT WORK =======================================
    # # Enable custom table name in mappings
    # adapter.resource_naming_convention[:default] = lambda do |name|
    #   name.downcase.singularize
    # end

  end


  def all_reports

    connect

    _result = []

    _reports = Report.all

    _reports.each { |report|
      _result << {
           domain: report.domain,
           date: report.date.strftime('%d-%m-%Y %H:%M:%S')
      }
    }

    _result

  end

  def save_report(report)

    connect

    _report = Report.new(   url: report.url,
                            domain: report.domain,
                            ip: report.ip,
                            title: report.title,
                            date: report.date)

    report.links.each{ |link|

      _link = _report.links.new(
          name: link[:name],
          href: link[:href],
          rel: link[:rel],
          target: link[:target]
      )

      _link.save

    }

    report.headers.each{ |key, value|

      _header = _report.headers.new(
                                   name: key,
                                   value: value
      )

      _header.save

    }

    _report.save

  end



end

