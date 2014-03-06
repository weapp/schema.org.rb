require "./list_parser"
require "./model_parser"

models = ListParser.new.parse(open('full.html'))

puts models.map{ |depth, model, attrs, parents, all_attrs| 
  attrs = all_attrs.select{|x| x}.flatten.map{|v| "- #{v}"}
  parents = parents.join ">"

  r = "#{parents}\n#{attrs.join "\n"}\n"
}.join "\n"


require 'open-uri'

modelname = models[10..-1].sample[1].gsub(/\*/, "")

puts
puts
puts "#{modelname}"
puts "=" * 60


model = ModelParser.new.parse(open("https://schema.org/#{modelname}"))
model.map do |model, attrs|
  puts
  puts model
  puts "-" * 60
  attrs.map do |name, type, desc|
    puts "#{name.ljust(30)} #{type.join(" | ")}"
  end
end
