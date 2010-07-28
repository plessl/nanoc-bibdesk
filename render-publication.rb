#!/usr/bin/ruby

require 'rubygems'
require 'rbosa'
require 'render-bibliography'

def render_publication(key)

  bd = OSA.app('BibDesk')
#  puts "====> #{bd} <======="
#  puts "====> #{bd.search(bd.documents[0],key)} <====="
  p = bd.search(bd.documents[0],key)[0]
  raise "publication with key '#{key}' doesn't exist" if p.nil?

#  puts "====> #{p} <======="
  pubtype = p.type2
#  puts "====> #{pubtype} <======="

  case pubtype
  when "article"
    return render_article(p)
  when "book"
    return render_book(p)
  when "booklet"
    return render_booklet(p)
  when "conference"
    return render_conference(p)
  when "inbook"
    return render_inbook(p)
  when "inproceedings"
    return render_inproceedings(p)
  when "manual"
    return render_manual(p)
  when "mastersthesis"
    return render_mastersthesis(p)
  when "misc"
    return render_misc(p)
  when "phdthesis"
    return render_phdthesis(p)
  when "proceedings"
    return render_proceedings(p)
  when "techreport"
    return render_techreport(p)
  when "unpublished"
    return render_unpublished(p)
  else
    raise "not implemented"
  end

end

#puts render_publication(ARGV[0])


