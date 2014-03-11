require "active_support/inflector"

def generate_active_attr_model modelname, model = nil
	ret = [{}]
	model = ModelParser.new.parse(open("https://schema.org/#{modelname}")) unless model
	hierarchy = model[:hierarchy]
	hierarchy = hierarchy[0..hierarchy.index(modelname)]
	base = hierarchy.size == 1
	
	ret.first[:filename] = "#{modelname.underscore}.rb"
	content = ""
	content << "class #{modelname}#{" < #{hierarchy[-2]}" unless base}\n"
	content << "  include ActiveAttr::Attributes\n\n" if base
	(model[:attributes][modelname] || {}).each do |attr|
		content << "  attribute :#{attr[:name].underscore}\n"
	end
	content << "end\n"

	ret.first[:content] = content
	ret.concat(generate_active_attr_model hierarchy[-2], model) unless base
	ret
end
