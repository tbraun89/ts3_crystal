require "./spec_helper"

describe Ts3Crystal do
  context "#server_connect" do
    it "this test should fail" do
      server = Ts3Crystal.server_connect({:username => "serveradmin", :password => "password"})
      puts server.version
      server.disconnect
      true.should eq(false)
    end
  end

  context "#client_connect" do
  end
end
