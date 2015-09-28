class Report
  include DataMapper::Resource

  #storage_name[:default] = 'reports'

  property :id,         Serial
  property :url,        String
  property :domain,     String
  property :ip,         String
  property :title,      String
  property :date,       DateTime

  has n,   :links, 'Link'
  has n,   :headers, 'Header'
end

class Link
  include DataMapper::Resource

  #storage_name[:default] = 'links'
  
  property   :id,         Serial
  property   :name,       String
  property   :href,       String
  property   :rel,        String
  property   :target,     String

  belongs_to :report, 'Report'
end

class Header
  include DataMapper::Resource

  #storage_name[:default] = 'headers'

  property   :id,         Serial
  property   :name,       String
  property   :value,      Text

  belongs_to :report, 'Report'
end