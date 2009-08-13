require 'text-helpers'


# TODO
# * print "page" instead of "pages" for publications that have only a single page

def booktitle(p)
  return p.fields.find {|f| f.name == "Booktitle"}.value
end

# TODO: extend OSA::BibDesk::Publication with field method

def field(p,field_name)
  f = p.fields.find {|f| f.name == field_name}
  if f.nil? then
    return nil
  else
    return f.value
  end
end


def text_for_field(fieldname, p, params={})
  if field(p,fieldname) then
    return (params[:prefix] || "") + field(p,fieldname) + (params[:postfix] || "")
  else
    return ""
  end
end

def render_inproceedings(p)
  r = ""
  r += p.authors.map {|a| a.abbreviated_name}.joined_by_comma_and_and + ". "
  r += p.title.detex.titlecase + ". "
  r += "In "

  if p.editors.size > 0 then
    r += p.editors.map {|e| e.abbreviated_name}.joined_by_comma_and_and + ", editors, "
  end

  r += text_for_field("Booktitle", p, :postfix => ", ").detex
  r += text_for_field("Volume", p, :prefix => "volume ", :postfix => " ")
  r += text_for_field("Number", p, :prefix => "number ", :postfix => " ")
  r += text_for_field("Series", p, :prefix => "of ", :postfix => ", ")
  r += text_for_field("Pages", p, :prefix => "pages ", :postfix => ". ").detex
  r += text_for_field("Address", p, :postfix => ", ").detex
  r += text_for_field("Organization", p, :postfix => ", ").detex
  r += text_for_field("Publisher", p, :postfix => ". ").detex
  r += text_for_field("Month", p, :postfix => " ").detex
  r += text_for_field("Year", p, :postfix => ". ").detex
  r += text_for_field("Note", p, :postfix => ". ")
  return r
end

def render_article(p)
  r = ""
  r += p.authors.map {|a| a.abbreviated_name}.joined_by_comma_and_and + ". "
  r += p.title.detex.titlecase + ". "

  r += text_for_field("Journal", p, :postfix => ", ").detex
  r += text_for_field("Volume", p)
  r += text_for_field("Number", p, :prefix => "(", :postfix => "):").detex
  r += text_for_field("Pages", p, :postfix => ", ").detex
  r += text_for_field("Month", p, :postfix => " ").detex
  r += text_for_field("Year", p, :postfix => ". ").detex
  r += text_for_field("Note", p, :postfix => ". ")
  return r
end


# faithful port from BibDesk template
def render_book(p)
  r = ""
  if p.authors then
    r += p.authors.map {|a| a.abbreviated_name}.joined_by_comma_and_and + ". "
    if p.editors.size > 0 then
      r += p.editors.map {|e| e.abbreviated_name}.joined_by_comma_and_and + ", editors, "
    end
  end

  r += p.title.detex.titlecase

  if field(p,"Volume") then
    r += text_for_field("Volume", p, :prefix => ", volume ")
    r += text_for_field("Series", p, :prefix => " of ")
  elsif field(p,"Number") then
      r += text_for_field("Number", p, :prefix => ". Number ")
      r += text_for_field("Series", p, :prefix => " in ")
  elsif field(p,"Series") then
    r += text_for_field("Series", p, :prefix => ". ")
  end
  r += ". "

  r += text_for_field("Publisher", p, :postfix => ", ").detex
  r += text_for_field("Address", p, :postfix => ", ").detex
  r += text_for_field("Edition", p, :postfix => " edition, ").titlecase.detex

  r += text_for_field("Month", p, :postfix => " ").detex
  r += text_for_field("Year", p, :postfix => ". ").detex
  r += text_for_field("Note", p, :postfix => ". ")
  return r

end

# faithful port from BibDesk template
def render_phdthesis(p)
  r = ""
  if p.authors then
    r += p.authors.map {|a| a.abbreviated_name}.joined_by_comma_and_and + ". "
  end

  r += p.title.detex.titlecase + ". "

  if field(p,"Type") then
    r += text_for_field("Type", p).titlecase.detex + ", "
  else
    r += "PhD thesis, "
  end

  r += text_for_field("School", p, :postfix => ", ").detex
  r += text_for_field("Address", p, :postfix => ", ").detex
  r += text_for_field("Month", p, :postfix => " ").detex
  r += text_for_field("Year", p, :postfix => ". ").detex
  r += text_for_field("Note", p, :postfix => ". ").detex
  return r

end

# faithful port from BibDesk template
def render_mastersthesis(p)
  r = ""
  if p.authors then
    r += p.authors.map {|a| a.abbreviated_name}.joined_by_comma_and_and + ". "
  end

  r += p.title.detex.titlecase + ". "

  if field(p,"Type") then
    r += text_for_field("Type", p).titlecase.detex + ", "
  else
    r += "Master's thesis, "
  end

  r += text_for_field("School", p, :postfix => ", ").detex
  r += text_for_field("Address", p, :postfix => ", ").detex
  r += text_for_field("Month", p, :postfix => " ").detex
  r += text_for_field("Year", p, :postfix => ". ").detex
  r += text_for_field("Note", p, :postfix => ". ").detex
  return r

end

# faithful port from BibDesk template
def render_techreport(p)
  r = ""
  if p.authors then
    r += p.authors.map {|a| a.abbreviated_name}.joined_by_comma_and_and + ". "
  end

  r += p.title.detex.titlecase + ". "

  if field(p,"Type") then
    r += text_for_field("Type", p).titlecase.detex
  else
    r += "Technical Report"
  end
  r += text_for_field("Number", p, :prefix => " ", :postfix => ", ").detex
  r += text_for_field("Institution", p, :postfix => ", ").detex
  r += text_for_field("Address", p, :postfix => ", ").detex
  r += text_for_field("Month", p, :postfix => " ").detex
  r += text_for_field("Year", p, :postfix => ". ").detex
  r += text_for_field("Note", p, :postfix => ". ").detex
  return r

end

