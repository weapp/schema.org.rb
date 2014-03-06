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
  	str = str.read if str.respond_to? :read
    last_index = 0
    regex = regexp
    loop do
      str = str[last_index..-1] if last_index > 0
      break if str.length == 0
      match = regex.match(str)
      found match, &block
      last_index = match.offset(0).last
    end
    self
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
