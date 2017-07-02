require "../spec_helper"

describe Ts3Crystal::Escaping do
  encode_example = {
    "TeamSpeak ]|[ Server" => "TeamSpeak\\s]\\p[\\sServer",
    "Test token with custom set" => "Test\\stoken\\swith\\scustom\\sset",
    "ident=forum_user value=Sven Paulsen|ident=forum_id value=123" => "ident=forum_user\\svalue=Sven\\sPaulsen\\pident=forum_id\\svalue=123",
    "\\/ |\f\n\r\t\v" => "\\\\\\/\\s\\p\\f\\n\\r\\t\\v"
  }
  decode_example = encode_example.invert

  context "#encode" do
    encode_example.each do |text, expected|
      it "encodeing should work with with '#{text}'" do
        Ts3Crystal::Escaping.encode(text).should eq(expected)
      end
    end
  end

  context "#decode" do
    decode_example.each do |text, expected|
      it "decodeing should work with '#{text}'" do
        Ts3Crystal::Escaping.decode(text).should eq(expected)
      end
    end
  end
end
