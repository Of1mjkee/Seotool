class InterfaceStorage
  #set implementation type storage
  def set_implementation(type_storage)
    Object.const_get(type_storage).new
  end

  def set_config(config)
    #set config for storage
  end

  def all_reports
    #implementation sub classes
  end

  def save_report(report)
    #implementation sub classes
  end

  def find_report(domain, date)
    #implementation sub classes
  end
end