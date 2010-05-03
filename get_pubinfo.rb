#!/usr/bin/ruby

require 'rubygems'
require 'rbosa'

require 'render-bibliography'

key = ARGV[0]

puts "looking for publication with key: #{key}"



bd = OSA.app('BibDesk')
p = bd.search(bd.documents[0],key)[0]

pubtype = p.type2
puts "publication is of type #{pubtype}"

case pubtype
when "article"
  puts render_article(p)
when "book"
  puts render_book(p)
when "booklet"
  puts render_booklet(p)
when "conference"
  puts render_conference(p)
when "inbook"
  puts render_inbook(p)
when "inproceedings"
  puts render_inproceedings(p)
when "manual"
  puts render_manual(p)
when "mastersthesis"
  puts render_mastersthesis(p)
when "misc"
  puts render_misc(p)
when "phdthesis"
  puts render_phdthesis(p)
when "proceedings"
  puts render_proceedings(p)
when "techreport"
  puts render_techreport(p)
when "unpublished"
  puts render_unpublished(p)
else
  raise "not implemented"
end


#puts p.bibtex_string
#puts bd.documents[0].templated_text(:using => bd.template_names[0], :for => p)


