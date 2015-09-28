class DBStorage < InterfaceStorage

  attr_accessor :config

  def set_config(config)
    @config = config
  end

  #fetching all reports
  def all_reports
    _conn = get_connection
    _reports = _conn.exec_params('SELECT domain, date from reports;')

    _result = []
    _reports.each{ |row|
      _result << {
                  domain: row['domain'],
                  date: row['date']
                 }
    }
    _result
  end

  def save_report(report)
    _conn = get_connection

    #save report
    _res = _conn.exec_params("INSERT INTO reports( url, domain, ip, title, date) VALUES
    ('#{report.url}' , '#{report.domain}', '#{report.ip}', '#{report.title}', '#{report.date}') RETURNING id;")

    #fetching id from insert report
    _id = _res[0]['id']

    #save links
    report.links.each { |link|
      _conn.exec_params("INSERT INTO links( name, href, rel, target, report_id) VALUES
      ('#{link[:name]}', '#{link[:href]}','#{link[:rel]}', '#{link[:target]}', '#{_id}');")
    }

    #save headers
    report.headers.each { |key, value|
      _conn.exec_params("INSERT INTO headers( name, value, report_id) VALUES
      ('#{key}', '#{value}', '#{_id}');")
    }

  end

  def find_report(domain, date)
    _conn = PG::Connection.open(@config)

    _report = ReportObject.new

    _result = _conn.exec("SELECT * FROM reports where domain = '#{domain}' and date = '#{date}';")

    _id = _result[0]['id']

    # ReportObject -> Report, Link, Header Resourse ???
    _report.url = _result[0]['url']
    _report.domain = _result[0]['domain']
    _report.ip = _result[0]['ip']
    _report.title = _result[0]['title']
    _report.date = _result[0]['date']

    #receive all links
    _result_links = _conn.exec("SELECT * FROM links where report_id = '#{_id}';")
    _links = []
    _result_links.each{ |row|
      _links << {
                  name: row['name'],
                  href: row['href'],
                  rel: row['rel'],
                  target: row['target']
                }
    }
    _report.links = _links

    #receive all headers
    _result_headers = _conn.exec("SELECT * FROM headers where report_id = '#{_id}';")
    _headers = {}
    _result_headers.each{ |row|
      _headers[row['name']] = row['value']
    }
    _report.headers = _headers

    _report
  end

  private # all methods that follow will be made private: not accessible for outside objects

  def get_connection
    PG::Connection.open(@config)
  end

end