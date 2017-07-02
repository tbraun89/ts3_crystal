require "socket"

require "./errors"
require "./escaping"

module Ts3Query
  abstract class Ts3Connection
    abstract def connect(params : Hash(Symbol, String))

    ERROR_OK = "error id=0 msg=ok"

    def initialize(params : Hash(Symbol, String))
      connect(params)
    end

    def disconnect
      @connection.try do |connection|
        connection.close
      end
    end

    macro method_missing(call)
      {% if call.args.empty? %}
        exec_command({{call.name.id.stringify}})
      {% else %}
        arguments = {{call.args}}

        if arguments.size == 1
          if arguments[0].is_a?(Hash(Symbol, String))
            exec_command({{call.name.id.stringify}}, arguments[0])
          elsif arguments[0].is_a?(Array(Symbol))
            exec_command({{call.name.id.stringify}}, {} of Symbol => String, arguments[0])
          else
            raise Ts3Crystal::WrongArgumentType.new("This method accepts either Hash(Symbol, String) or Array(Symbol).")
          end
        elsif arguments.size == 2
          if arguments[0].is_a?(Hash(Symbol, String)) && arguments[1].is_a?(Array(Symbol))
            exec_command({{call.name.id.stringify}}, arguments[0], arguments[1])
          elsif arguments[0].is_a?(Array(Symbol)) && arguments[1].is_a?(Hash(Symbol, String))
            exec_command({{call.name.id.stringify}}, arguments[1], arguments[0])
          else
            raise Ts3Crystal::WrongArgumentType.new("This method accepts either Hash(Symbol, String) or Array(Symbol).")
          end
        elsif arguments.size > 2
          raise Ts3Crystal::WrongArgumentCount.new("This method accepts none, one or tow arguments.")
        end
      {% end %}
    end

    private def exec_command(command : String, arguments = {} of Symbol => String, options = [] of Symbol)
      query_string : String = command

      (arguments.unsafe_as(Hash(Symbol, String))).each do |key, value|
        query_string += " #{key}=#{Ts3Crystal::Escaping.encode(value)}"
      end

      options.each do |value|
        query_string += " -#{value}"
      end

      (@connection.unsafe_as(TCPSocket)).try do |connection|
        connection << "#{query_string}\n"
        data : String = connection.gets.unsafe_as(String).strip
        error : String = connection.gets.unsafe_as(String).strip

        if error == ERROR_OK && !data.empty?
          parse_result("#{error}|#{data}")
        else
          parse_result(error)
        end
      end
    end

    private def parse_result(data : String)
      result = [] of Hash(String, String)

      data.split("|").each do |row|
        row_result = {} of String => String

        row.split(" ").each do |element|
          element_result = element.split("=")
          row_result[element_result[0]] = element_result[1] if element_result.size > 1
        end

        result << row_result
      end

      result
    end
  end
end
