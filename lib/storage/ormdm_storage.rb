class ORMDMStorage < InterfaceStorage

  attr_accessor :config

  def set_config(config)
    @config = config
  end


  def client

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

    client

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

    client

    _report = Report.new( url: report.url,
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

  def find_report(domain, date)
    _result  = Report.first(domain: domain, date: date)

    _links = []
    _result.links.each{ |row|
      _links << {
          name: row['name'],
          href: row['href'],
          rel: row['rel'],
          target: row['target']
      }
    }

    _headers = {}
    _result.headers.each{ |row|
      _headers[row['name']] = row['value']
    }

    #Fill reportobject
    _report = ReportObject.new
    _report.links = _links
    _report.headers = _headers
    _report.url = _result.url
    _report.domain = _result.domain
    _report.ip = _result.ip
    _report.title = _result.title
    _report.date = _result.date

    _report
  end
end

