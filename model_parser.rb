require "./tokenizer"

class ModelParser
  include Tokenizer
  attr_accessor :visible, :buffer, :hierarchy, :description

  def initialize
    self.visible = 0
    self.buffer = ""
    self.hierarchy = ""
    self.description = ""
    @is_hierarchy = false
    @is_descr = false
  end

  token h1: /<h1[^>]*>/ do
    @is_hierarchy = true
  end

  token end_h1: %r{</h1>} do
    @is_hierarchy = false
  end

  token descr: /<div property="rdfs:comment">/ do
    @is_descr = true
  end

  token end_descr: %r{</div>} do
    @is_descr = false
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
    hierarchy << "|#{value.strip.gsub(/\s+/, " ")}" if @is_hierarchy
    description << "#{value.strip.gsub(/\s+/, " ")}" if @is_descr
  end

  def parse(text)
    tokenize(text).buffer
    post_process
  end

  def post_process
    hierarchy = self.hierarchy.split("|")[3..-1].reject { |str| str == "&gt;" }
    hash = {
      hierarchy: hierarchy,
      description: description
    }
    return hash if buffer.strip.empty?
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
