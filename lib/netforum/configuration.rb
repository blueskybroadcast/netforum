module Netforum
  class Configuration
    def self.authentication_wsdl(value=nil)
      @authentication_wsdl = value || @authentication_wsdl || 'https://uat.netforumpro.com/xWeb/Signon.asmx?WSDL'
    end

    def self.on_demand_wsdl(value=nil)
      @on_demand_wsdl = value || @on_demand_wsdl || 'https://uat.netforumpro.com/xweb/netFORUMXMLONDemand.asmx?WSDL'
    end

    def self.client_options(value=nil)
      #@client_options = value || @client_options || {log: true, log_level: :info, logger: DebugLogger}
      @client_options = value || @client_options || {}
    end

    def self.reset(*properties)
      reset_variables = properties.empty? ? instance_variables : instance_variables.map { |p| p.to_s} & \
                                                                 properties.map         { |p| "@#{p}" }
      reset_variables.each { |v| instance_variable_set(v.to_sym, nil) }
    end
  end
end

module DebugLogger
  def self.level=(level)
  end

  def self.debug(message)
    puts message
  end

  def self.info(message)
    puts message
  end
end
