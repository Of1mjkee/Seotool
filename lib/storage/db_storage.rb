class DBStorage < InterfaceStorage

  attr_accessor :config

  def set_config(config)
    @config = config
  end


  #fetching all reports
  def all_reports
    conn = PG::Connection.open(@config)
    res = conn.exec_params('SELECT domain, date from reports;')

    _result = []
    res.each{ |row|
      _result << {
                  domain: row['domain'],
                  date: row['date']
                 }
    }
    _result
  end

  def save_report(report)

    _sql = "INSERT INTO reports( url, domain, ip, title, date) VALUES" \
    "('#{report.url}' , '#{report.domain}', '#{report.ip}', '#{report.title}', '#{report.date}') RETURNING id;"

    _conn = PG::Connection.open(@config)

    _res = _conn.exec_params(_sql)

    _id = _res[0]['id']

    report.links.each { |link|
      _sql_link = "INSERT INTO links( name, href, rel, target, report_id) VALUES "\
       "('#{link[:name]}', '#{link[:href]}','#{link[:rel]}', '#{link[:target]}', '#{_id}');"

      _conn.exec_params(_sql_link)
    }

    report.headers.each { |key, value|
      _sql_link = "INSERT INTO headers( name, value, report_id) VALUES "\
      "('#{key}', '#{value}', '#{_id}');"

      _conn.exec_params(_sql_link)
    }

  end

  def find_report(domain, date)

    _conn = PG::Connection.open(@config)

    _report = ReportObject.new

    _sql_reports = "SELECT * FROM reports where domain = '#{domain}' and date = '#{date}';"

    _result = _conn.exec(_sql_reports)

    _id = _result[0]['id']

    # Refactor this ReportObject -> Report, Link, Header Resourse
    _report.url = _result[0]['url']
    _report.domain = _result[0]['domain']
    _report.ip = _result[0]['ip']
    _report.title = _result[0]['title']
    _report.date = _result[0]['date']

    _sql_links = "SELECT * FROM links where report_id = '#{_id}';"
    _result_links = _conn.exec(_sql_links)

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

    _sql_headers = "SELECT * FROM headers where report_id = '#{_id}';"
    _result_headers = _conn.exec(_sql_headers)

    _headers = {}
    _result_headers.each{ |row|
      _headers[row['name']] = row['value']
    }
    _report.headers = _headers

    _report

  end

end