require "./tokenizer"

class ListParser
  include Tokenizer
  attr_accessor :visible, :buffer

  def initialize
    self.visible = 0
    self.buffer = ""
  end

  token td: /<td[^>]*>/ do
    self.visible += 1
  end

  token end_td: %r{</td>} do
    self.visible -= 1
  end

  token tr: /<tr[^>]*>/ do
    buffer << "\n#{"=" * visible} "
  end

  token end_tr: %r{</tr>} do
  end

  token end_html: %r{</html>} do
    buffer << "\n"
  end

  token tag: /<\/?[^>]*>/ do |value|
  end

  token dot: /[^<]+|./ do |value|
    buffer << "#{value.strip}" if !value.strip.empty? if visible > 0
  end

  def parse(text)
  	tokenize(text)
  	post_process
  end

  def post_process
		@attrs = []
		@parents = []
  	buffer.split("\n")
	  	.reject{|line| line.gsub(/\=/, '').strip.empty?}
			.map do |line|
			  depth, model, attrs = line.split(/:? /,3)
			  depth = depth.length
			  attrs = (attrs && attrs.split(/,\s*/))
			  @attrs = @attrs[0...depth]
			  @parents = @parents[0...depth]
			  @attrs[depth] = attrs
			  @parents[depth] = model
			  [depth, model, attrs, @parents[0..-1], @attrs]
			end
  end
end
