require "./list_parser"

models = ListParser.new.parse(open('full.html'))


puts models.map{ |depth, model, attrs, parents, all_attrs| 
  attrs = all_attrs.select{|x| x}.flatten.map{|v| "- #{v}"}
  parents = parents.join ">"

  r = "#{parents}\n#{attrs.join "\n"}\n"
}.join "\n"
