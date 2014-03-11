require 'open-uri'

require "./list_parser"
require "./model_parser"

models = ListParser.new.parse(open('full.html'))

depth, modelname, attrs, parents, all_attrs = models[10..-1].sample # skip DataTypes

# Print data from "https://schema.org/docs/full.html"

attrs = all_attrs.select{|x| x}.flatten.map{|v| "- #{v}"}
parents = parents.join ">"

puts "#{parents}\n#{attrs.join "\n"}\n"


# Get more accurate data from their page

modelname = modelname.gsub(/\*/, "")

puts
puts
puts "#{modelname}"

model = ModelParser.new.parse(open("https://schema.org/#{modelname}"))
puts model[:description]
puts "=" * 60
puts model[:hierarchy].join " > "

model[:attributes].map do |model, attrs|
  puts
  puts model
  puts "-" * 60
  attrs.map do |attr|
    puts "#{attr[:name].ljust(30)} #{attr[:types].join(" | ")}"
  end
end


require './generators/active_attr_model'
generate_active_attr_model(modelname, model).each do |generated|
	puts
	puts "# #{generated[:filename]}"
	puts "#{generated[:content]}"
end
