require "./ts3_connection"

module Ts3Crystal
  class ClientConnection < Ts3Query::Ts3Connection
    private def connect(params : Hash(Symbol, String))
      begin
        @connection = TCPSocket.new(params[:address], params[:port].to_i)

        @connection.try do |connection|
          unless connection.gets == "TS3 Client" # TODO check if this works
            connection.close
            raise Ts3Crystal::ConnectionRefused.new("No Teamspeak 3 server found.")
          end

          # TODO check if we need to remove some other lines from the connection
        end
      rescue
        raise Ts3Crystal::ConnectionRefused.new("Could not connect to the server.")
      end
    end
  end
end
