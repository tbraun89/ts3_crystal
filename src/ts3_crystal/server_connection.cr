require "./ts3_connection"

module Ts3Crystal
  class ServerConnection < Ts3Query::Ts3Connection
    private def connect(params : Hash(Symbol, String))
      # TODO implement telnet interface
      puts "not implemented"
      @connection = nil
    end
  end
end
