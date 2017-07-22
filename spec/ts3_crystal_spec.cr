require "./spec_helper"

describe Ts3Crystal do
  context "#server_connect" do
    it "should not fail with a valid connection" do
      server = Ts3Crystal.server_connect({:username => "serveradmin", :password => "password"})
      server.disconnect
    end

    it "should fail with an invalid password" do
      expect_raises(Ts3Crystal::ConnectionRefused, "Username and password do not match, login failed.") do
        Ts3Crystal.server_connect({:username => "serveradmin", :password => "wrong_password"})
      end
    end

    # TODO add more specs
  end

  context "#client_connect" do
    # TODO test client connection
  end
end
