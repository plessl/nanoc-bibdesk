#!/usr/bin/ruby

require 'rubygems'
require 'rbosa'

require 'render-bibliography'

key = ARGV[0]

puts "looking for publication with key: #{key}"



bd = OSA.app('BibDesk')
pubs = bd.documents[0].publications
p = pubs.find { |p| p.cite_key == key }

puts render_inproceedings(p)


#puts p.bibtex_string
#puts bd.documents[0].templated_text(:using => bd.template_names[0], :for => p)


