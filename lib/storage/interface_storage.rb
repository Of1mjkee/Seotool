class InterfaceStorage

  def set_implementation(type_storage)
    Object.const_get(type_storage).new
  end

  #fetching all reports
  def all_reports

  end

  # Report
  # url
  # domain
  # ip
  # headers
  # links


  def save_report(report)

  end

  def find_report(domain, date)

  end

end