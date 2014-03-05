module Tokenizer
  def self.included(klass)
    klass.extend(ClassMethods)
  end

	module ClassMethods
		def tokens
			@tokens ||= [] 
		end

		def token dic, &block
			dic[:block] = block if block
			tokens << dic
		end

		def hash_tokens
			tokens.inject({}){|memo, dic|
				k, v = dic.first 
				memo[k] = [v, dic[:block]]
				memo
			}
		end
	end

	def tokenize str, &block
		last_index = 0
		regex = regexp
		loop do
			str = str[last_index..-1] if last_index > 0
			break if str.length == 0
			match = regex.match(str)
			found match, &block
			last_index = match.offset(0).last
		end
	end

	private
	def found match

		token = Hash[[match.names, match.captures].transpose.select{|k,v|v}] 
		proc = self.class.hash_tokens[token.first.first.to_sym].last
		instance_exec(token.first.last, &proc) if proc
		yield token if block_given?
	end

	def regexp
		Regexp.new(self.class.tokens.map{ |dic|
			k, v = dic.first
			"(?<#{k.to_s}>#{v.to_s})"
		}.join "|")
	end
end



class Parser
	include Tokenizer
	attr_accessor :visible, :buffer

	def initialize
		self.visible = 0
	end

	token td: /<td[^>]*>/ do
		self.visible += 1
	end

	token end_td: %r{</td>} do
		self.visible -= 1
	end

	token tr: /<tr[^>]*>/ do
		puts
		print "=#{"=" * visible} "
		# puts "<-------------"
	end

	token end_tr: %r{</tr>} do
		# puts
		# puts "------------->"
	end

	token end_html: %r{</html>} do
		puts
	end

	# token space: /\s+/ do |value|
	# 	puts "it's a space value: #{value.inspect}"	if @visible > 0
	# end

	token tag: /<\/?[^>]*>/ do |value|
	end

	token dot: /[^<]+|./ do |value|
		print "#{value.strip}" if !value.strip.empty? if visible > 0
	end
end


require 'stringio'
 
def capture_stdout
  out = StringIO.new
  $stdout = out
  yield
  out.rewind
  return out
ensure
  $stdout = STDOUT
end



parser = Parser.new


text = open('full.html').read.to_s

out = capture_stdout{parser.tokenize text}
	
@attrs = []
@parents = []

puts out.readlines.map{|line|
	line = line.strip
	line if !line.gsub(/\=/, '').strip.empty?
}.select{|x| x }.map{ |value|
	value.split(/:? /,3)
}.map{ |depth, model, attrs|
	[depth.length, model, (attrs && attrs.split(/,\s*/))]
}.map{ |depth, model, attrs|
	@attrs = @attrs[0...depth]
	@parents = @parents[0...depth]
	@attrs[depth] = attrs if attrs
	@parents[depth] = model

	attrs = @attrs.select{|x| x}.flatten.map{|v| "- #{v}"}
	parents = @parents[1..-1].join ">"

	r = "#{parents}\n#{attrs.join "\n"}\n"
}.join "\n"
