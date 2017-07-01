module Ts3Crystal
  module Escaping
    DECODER_PATTERNS = {
      "\\\\" => "\\",
      "\\/"   => "/",
      "\\s"   => " ",
      "\\p"   => "|",
      "\\a"   => "\\a",
      "\\b"   => "\\b",
      "\\f"   => "\\f",
      "\\n"   => "\\n",
      "\\r"   => "\\r",
      "\\t"   => "\\t",
      "\\v"   => "\\v",
    }

    ENCODER_PATTERNS = DECODER_PATTERNS.invert
    DECODER_REGEXP   = /\\[#{Regex.escape(DECODER_PATTERNS.keys.map{|k| k[1]}.join)}]/
    ENCODER_REGEXP   = /[#{Regex.escape(DECODER_PATTERNS.values.join)}]/

    def self.encode(str : String)
      str.gsub(ENCODER_REGEXP, ENCODER_PATTERNS)
    end

    def self.decode(str : String)
      str.gsub(DECODER_REGEXP, DECODER_PATTERNS)
    end
  end
end
