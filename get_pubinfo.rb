#!/usr/bin/ruby

require 'rubygems'
require 'rbosa'

require 'render-bibliography'

key = ARGV[0]

puts "looking for publication with key: #{key}"



bd = OSA.app('BibDesk')
pubs = bd.documents[0].publications
p = pubs.find { |p| p.cite_key == key }

pubtype = p.type2
puts "publication is of type #{pubtype}"

case pubtype
when "article"
  puts render_article(p)
when "book"
  puts render_book(p)
when "inproceedings"
  puts render_inproceedings(p)
when "phdthesis"
  puts render_phdthesis(p)
else
  raise "not implemented"
end


#puts p.bibtex_string
#puts bd.documents[0].templated_text(:using => bd.template_names[0], :for => p)


