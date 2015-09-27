class Analyzer

  # 1. Check url -> http https?
  # 2. Check status response 200?

  def initialize(url)

    # if all is OK fetch and parse data from response
    if url =~ /\A#{URI::regexp(['http', 'https'])}\z/ && HTTParty.get(url).code == 200
      @url = url
      @response = HTTParty.get(url)
    else
      raise StandardError, 'URL is wrong ~= https? or code != 200'
    end


  end

  #Generate new report
  def generate

    # create new empty report
    _report = ReportObject.new

    # create new DOM Structure
    _dom = Nokogiri::HTML(@response)

    _report.headers = @response.headers

    # Get title and links from DOM
    @title = get_title(_dom)
    @links = get_links(_dom)

    # Get DOM Structure
    _dom = Nokogiri::HTML(@response)


    #Fill REPORT

    _report.url = @url
    _report.domain = URI(@url).host
    _report.ip = '255.255.255.255'
    _report.title = get_title(_dom)
    _report.headers = @response.headers
    _report.links = get_links(_dom)
    _report.date = Time.now.strftime('%d-%m-%Y %H:%M:%S') # DAY-MONTH-YEAR HOUR:MIN:SEC

    _report

  end


  ### PRIVATE METHODS

  def get_title(dom)
    @title = dom.css('title').text
  end

  def get_links(dom)
    _links = []
    dom.css('a').each do |node|
      _links << {
                  name: node.text.chomp ||= '<empty>',
                  href: create_full_href(node[:href]),
                  rel: node['rel'] ||= '<empty>',
                  target: node['target'] ||= '<empty>'
                }
    end
    _links
  end

  def create_full_href(href)

    if href =~ (/http(s?):\/\/(www\.)?/)
      href
    else
      @url.to_s + href.to_s
    end


  end


end