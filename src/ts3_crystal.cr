require "./ts3_crystal/server_connection"
require "./ts3_crystal/client_connection"

module Ts3Crystal
  DEFAULT_SERVER_PARAMS = {
    :address  => "127.0.0.1",
    :port     => "10011",
    :username => "serveradmin"
  }

  DEFAULT_CLIENT_PARAMS = {
    :address  => "127.0.0.1",
    :port     => "25639"
  }

  def self.server_connect(params = {} of Symbol => String)
    ServerConnection.new DEFAULT_SERVER_PARAMS.merge(params)
  end

  def self.client_connect(params = {} of Symbol => String)
    ClientConnection.new DEFAULT_CLIENT_PARAMS.merge(params)
  end
end
