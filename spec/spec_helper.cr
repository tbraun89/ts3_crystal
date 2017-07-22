require "spec"
require "../src/ts3_crystal"

Spec.before_each do
  @@server = Ts3Crystal.server_connect({:username => "serveradmin", :password => "password"})
end

Spec.after_each do
  @@server.disconnect
end
