require "./tokenizer"

class ModelParser
  include Tokenizer
  attr_accessor :visible, :buffer

  def initialize
    self.visible = 0
    self.buffer = ""
  end

  token td: /<td[^>]*>/ do
    buffer << "| "
  end

  token end_td: %r{</td>} do
  end

  token tr: /<tr[^>]*>/ do
    self.visible += 1
    buffer << "\n"
  end

  token end_tr: %r{</tr>} do
    self.visible -= 1
  end

  token end_html: %r{</html>} do
    buffer << "\n"
  end

  token tag: /<\/?[^>]*>/ do |value|
  end

  token dot: /[^<]+|./ do |value|
    buffer << "#{value.strip.gsub(/\s+/, " ")} " if !value.strip.empty? if visible > 0
  end

  def parse(text)
  	tokenize(text).buffer
  	post_process
  end

  def post_process
  	return {} if buffer.strip.empty?
  	hash = {}
  	last_key = nil
  	buffer.split("\n")[2..-1]
			.map do |line|
			  line = line.split(" | ")
			  if line.length == 1
			  	last_key = line.first.split(" ").last
			  	hash[last_key] = []
			  else
			  	line[1] = line[1].split(" or ")
			  	hash[last_key] << line
			  end
			end
		hash
  end
end
