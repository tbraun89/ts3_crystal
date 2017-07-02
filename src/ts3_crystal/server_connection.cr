require "./ts3_connection"

module Ts3Crystal
  class ServerConnection < Ts3Query::Ts3Connection
    private def connect(params : Hash(Symbol, String))
      begin
        @connection = TCPSocket.new(params[:address], params[:port].to_i)

        @connection.try do |connection|
          if connection.gets == "TS3"
            connection.gets
            connection << "login client_login_name=#{params[:username]} client_login_password=#{params[:password]}\n"
            response = connection.gets.unsafe_as(String).strip

            unless response == ERROR_OK
              connection.close
              raise Ts3Crystal::ConnectionRefused.new("Username and password do not match, login failed.")
            end
          else
            connection.close
            raise Ts3Crystal::ConnectionRefused.new("No Teamspeak 3 server found.")
          end
        end
      rescue
        raise Ts3Crystal::ConnectionRefused.new("Could not connect to the server.")
      end
    end
  end
end
