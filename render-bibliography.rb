require 'text-helpers'


# TODO
# * print "page" instead of "pages" for publications that have only a single page
# * implement detex method that converts \url macros to links?


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

def month_for_field(fieldname, p, params={})
  if field(p,fieldname) then
    return (params[:prefix] || "") + abbrev_month_name(field(p,fieldname)) + (params[:postfix] || "")
  else
    return ""
  end
end


def text_for_string(str, params={})
  if str then
    return (params[:prefix] || "") + str + (params[:postfix] || "")
  else
    return ""
  end
end

def abbrev_month_name(month)
  return nil if month.nil?

  abbrev_month = case month
    when "January|Januar" then "Jan."
    when "February|Februar" then "Feb."
    when "March|März" then "Mar."
    when "April" then "Apr."
    when "May|Mai" then "Mai"
    when "June|Juni" then "Jun."
    when "July|Juli" then "Jul."
    when "August" then "Aug."
    when "September" then "Sep."
    when "October|Oktober" then "Oct."
    when "November" then "Nov."
    else "Dec."
  end
  return abbrev_month
end



# faithful port from BibDesk template
def render_booklet(p)
  r = ""
  if p.authors.size > 0 then
    r += p.authors.map {|a| a.abbreviated_name}.joined_by_comma_and_and + ". "
  end
  r += p.title.detex.titlecase + ". "
  r += text_for_field("Howpublished", p, :postfix => ", ")
  r += text_for_field("Address", p, :postfix => ", ")
  r += month_for_field("Month", p, :postfix => " ")
  r += text_for_field("Year", p, :prefix => " ", :postfix => ". ")
  r += text_for_field("Note", p, :prefix => " ", :postfix => ". ").detex
  return r
end

# faithful port from BibDesk template
def render_inbook(p)
  r = ""
  if p.authors.size > 0 then
    r += p.authors.map {|a| a.abbreviated_name}.joined_by_comma_and_and
  else
    r += p.editors.map {|e| e.abbreviated_name}.joined_by_comma_and_and + ", editor"
  end
  r += ". "

  r += p.title.detex.titlecase

  if field(p,"Volume") then # <$fields.Volume?>
    r += text_for_field("Volume", p, :prefix => ", volume ") #, volume <$fields.Volume/>
    if field(p,"Series") then # <$fields.Series?>
      r += text_for_field("Series", p, :prefix => " of ", :postfix => "") # <$fields.Series/>
    end # </$fields.Series?>
  end # </$fields.Volume?>

  if field(p,"Chapter") then # <$fields.Chapter?>, 
    r += ", "
    if field(p,"Type") then # <$fields.Type?>
      r += text_for_field("Type", p, :postfix => " ") # <$fields.Type/>
    else
      r += "chapter" # <?$fields.Type?>chapter
    end # </$fields.Type?>
     r += text_for_field("Chapter", p) # <$fields.Chapter/>
     # <$fields.Pages.stringByPrependingCommaAndSpaceIfNotEmpty/>
     if field(p,"Pages") then
       r += text_for_field("Pages", p, :prefix => ", pages ", :postfix => ". ").detex
     end
  else # <?$fields.Chapter?>
    # <$fields.Pages?>, page <$fields.Pages/>
    if field(p,"Pages") then
      r += text_for_field("Pages", p, :prefix => ", pages ", :postfix => ". ").detex
    end # </$fields.Pages?>
  end # </$fields.Chapter?>

  if field(p,"Volume") then #<$fields.Volume?>
    # empty
  else # <?$fields.Volume?>
    if field(p,"Number") then # <$fields.Number?>. Number
      r += text_for_field("Number", p, :prefix => ". Number ", :postfix => "") #<$fields.Number/>
      if field(p,"Series") then # <$fields.Series?>
         r += text_for_field("Series", p, :prefix => " in ", :postfix => "") # <$fields.Series/>
      end #</$fields.Series?>
    else # <?$fields.Number?>
      # <$fields.Series.stringByPrependingCommaAndSpaceIfNotEmpty/>
      r += text_for_field("Series", p, :prefix => ", ")
    end # </$fields.Number?>
    r += ". "
  end # </$fields.Volume?>.

  r += text_for_field("Publisher", p) # <$fields.Publisher/>
  r += text_for_field("Address", p, :prefix => ", ") #  <$fields.Address.stringByPrependingCommaAndSpaceIfNotEmpty/>,
  r += text_for_field("Edition", p, :prefix => ", ", :postfix => " edition")
  r += month_for_field("Month", p, :prefix => ", ") # <$fields.Month.stringByAppendingSpaceIfNotEmpty/>
  r += text_for_field("Year", p, :prefix => " ", :postfix => ".") # <$fields.Year/>. 
  r += text_for_field("Note", p, :prefix => " ", :postfix => ". ").detex #  <$fields.Note.stringByPrependingFullStopAndSpace/>.
  return r
end

# faithful port from BibDesk template
def render_inproceedings(p)
  r = ""
  r += p.authors.map {|a| a.abbreviated_name}.joined_by_comma_and_and + ". "
  r += p.title.detex.titlecase + ". "
  r += "In "

  if p.editors.size > 0 then
    r += p.editors.map {|e| e.abbreviated_name}.joined_by_comma_and_and + ", editors, "
  end

  r += text_for_field("Booktitle", p, :postfix => "").detex

  # TODO simplify this complex nested if structures that result from the conversion
  # from BibDesks abbrv template
  if field(p,"Volume") then # <$fields.Volume?>
    r += text_for_field("Volume", p, :prefix => ", volume ", :postfix => "") # <$fields.Volume/>
    if field(p,"Series") then # <$fields.Series?>
      r += text_for_field("Series", p, :prefix => " of ", :postfix => "") # <$fields.Series/>
    end # </$fields.Series?>
  else #<?$fields.Volume?>
    if field(p,"Number") then # <$fields.Number?>
      r += text_for_field("Number", p, :prefix => " , number ", :postfix => "") #<$fields.Number/>
      if field(p,"Series") then # <$fields.Series?>
         r += text_for_field("Series", p, :prefix => " in ", :postfix => "") # <$fields.Series/>
      end #</$fields.Series?>
    else #<?$fields.Number?>
        r += text_for_field("Series", p, :prefix => ", ", :postfix => "") # <$fields.Series.stringByPrependingCommaAndSpaceIfNotEmpty/>
    end # </$fields.Number?>
  end # </$fields.Volume?>

  if field(p,"Pages") then
    r += text_for_field("Pages", p, :prefix => ", pages ", :postfix => ". ").detex
  else
    r += ". "
  end

  if field(p,"Address") then # <$fields.Address?>
    r += text_for_field("Address", p, :prefix => " , ", :postfix => " ") #  ,  <$fields.Address/>
    r += month_for_field("Month", p, :prefix => " , ", :postfix => " ") #  , <$fields.Month.stringByAppendingSpaceIfNotEmpty/>
    r += text_for_field("Year", p, :postfix => ". ").detex # <$fields.Year/>. 
    r += text_for_field("Organization", p, :postfix => ", ").detex # <$fields.Organization/> , 
    r += text_for_field("Publisher", p, :postfix => " ").detex # <$fields.Publisher/>
  else # <?$fields.Address?>
    r += text_for_field("Organization", p, :prefix => ", ", :postfix => ", ").detex # <$fields.Organization/> ,
    r += text_for_field("Publisher", p, :postfix => ", ").detex # <$fields.Publisher/> , 
    r += month_for_field("Month", p, :postfix => " ") # <$fields.Month.stringByAppendingSpaceIfNotEmpty/>
    r += text_for_field("Year", p).detex # <$fields.Year/>. 
  end # </$fields.Address?>

  r += text_for_field("Note", p, :prefix => ", ").detex #  <$fields.Note.stringByPrependingFullStopAndSpace/>.
  r += "."
  return r
end

# faithful port from BibDesk template
def render_proceedings(p)
  r = ""
  if p.editors.size > 0 then
    r += p.editors.map {|e| e.abbreviated_name}.joined_by_comma_and_and + ", editor. "
  else
    r += text_for_field("Organization", p, :postfix => ". ")
  end

  r += p.title.detex.titlecase

  if field(p,"Volume") then
    r += text_for_field("Volume", p, :prefix => ", volume ")
    r += text_for_field("Series", p, :prefix => " of ")
  else
    if field(p,"Number") then
      r += text_for_field("Number", p, :prefix => ", number ")
      r += text_for_field("Series", p, :prefix => " in ")
    else
      r += text_for_field("Series", p, :prefix => ", ")
    end
  end

  if field(p,"Address") then
    r += text_for_field("Address", p, :prefix => ", ", :postfix => ", ")
    r += month_for_field("Month", p, :postfix => " ")
    r += text_for_field("Year", p, :postfix => ". ")
    r += text_for_field("Organization", p, :postfix => ", ")
    r += text_for_field("Publisher", p)
  else
    r += ". "
    r += text_for_field("Organization", p, :postfix => ", ")
    r += text_for_field("Publisher", p)
    r += month_for_field("Month", p, :postfix => " ")
    r += text_for_field("Year", p, :postfix => ". ")
  end
  
  r += text_for_field("Note", p, :prefix => ". ", :postfix => ".").detex #  
  return r
end

# faithful port from BibDesk template
def render_article(p)
  r = ""
  r += p.authors.map {|a| a.abbreviated_name}.joined_by_comma_and_and + ". "
  r += p.title.detex.titlecase + ". "

  r += text_for_field("Journal", p, :postfix => ", ").detex
  r += text_for_field("Volume", p)
  r += text_for_field("Number", p, :prefix => "(", :postfix => ")").detex

  # TODO simplify this complex nested if structures that result from the conversion
  # from BibDesks abbrv template
  if field(p,"Pages") then # <$fields.Pages?>
    if field(p,"Volume") then # <$fields.Volume?>
      r += ":"
    else # <?$fields.Volume?>
      if field(p,"Number") then #<$fields.Number?>
        r+= ":"
      else # <?$fields.Number?>
        r += "page "
      end # </$fields.Number?>
    end # </$fields.Volume?>

    r += text_for_field("Pages", p, :postfix => ", ").detex # <$fields.Pages/>,
  else # <?$fields.Pages?>
    if field(p,"Volume") then #<$fields.Volume?>
      r += ", "
    else # <?$fields.Volume?>
      if field(p,"Number") then #<$fields.Number?>
        r += ", "
      end #</$fields.Number?>
    end
  end #</$fields.Pages?>

  r += month_for_field("Month", p, :postfix => " ").detex
  r += text_for_field("Year", p, :postfix => ". ").detex
  r += text_for_field("Note", p, :postfix => ". ")
  return r
end

# faithful port from BibDesk template
def render_book(p)
  r = ""
  if p.authors.size > 0 then
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

  r += month_for_field("Month", p, :postfix => " ").detex
  r += text_for_field("Year", p, :postfix => ". ").detex
  r += text_for_field("Note", p, :postfix => ". ")
  return r

end

# faithful port from BibDesk template
def render_phdthesis(p)
  r = ""
  if p.authors.size > 0 then
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
  r += month_for_field("Month", p, :postfix => " ").detex
  r += text_for_field("Year", p, :postfix => ". ").detex
  r += text_for_field("Note", p, :postfix => ". ").detex
  return r

end

# faithful port from BibDesk template
def render_mastersthesis(p)
  r = ""
  if p.authors.size > 0 then
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
  r += month_for_field("Month", p, :postfix => " ").detex
  r += text_for_field("Year", p, :postfix => ". ").detex
  r += text_for_field("Note", p, :postfix => ". ").detex
  return r

end

# faithful port from BibDesk template
def render_techreport(p)
  r = ""
  if p.authors.size > 0 then
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
  r += month_for_field("Month", p, :postfix => " ").detex
  r += text_for_field("Year", p, :postfix => ". ").detex
  r += text_for_field("Note", p, :postfix => ". ").detex
  return r

end

# faithful port from BibDesk template
def render_manual(p)
  r = ""
  if p.authors.size > 0 then
    r += p.authors.map {|a| a.abbreviated_name}.joined_by_comma_and_and + ". "
  end

  r += p.title.detex.titlecase + ". "
  r += text_for_field("Organization", p, :postfix => ", ").detex
  r += text_for_field("Address", p, :postfix => ", ").detex

  if field(p,"Edition") then
    r += text_for_field("Edition", p).titlecase.detex + " edition, "
  end

  r += month_for_field("Month", p, :postfix => " ").detex
  r += text_for_field("Year", p, :postfix => ". ").detex
  r += text_for_field("Note", p, :postfix => ". ").detex
  return r
end

# faithful port from BibDesk template
def render_misc(p)
  r = ""
  if p.authors.size > 0 then
    r += p.authors.map {|a| a.abbreviated_name}.joined_by_comma_and_and + ". "
  end

  r += p.title.detex.titlecase + ". "
  r += text_for_field("Howpublished", p).detex
  if field(p,"Year")
    r += ", "
    r += month_for_field("Month", p, :postfix => " ").detex
    r += text_for_field("Year", p, :postfix => ". ").detex
  end
  r += text_for_field("Note", p, :prefix => ". ").detex
  return r
end

# faithful port from BibDesk template
def render_unpublished(p)
  r = ""
  if p.authors.size > 0 then
    r += p.authors.map {|a| a.abbreviated_name}.joined_by_comma_and_and + ". "
  end

  r += p.title.detex.titlecase + ". "
  r += text_for_field("Note", p).detex + "."

  if field(p,"Year") then
    r += month_for_field("Month", p, :prefix => " ").detex
    r += text_for_field("Year", p, :prefix => " ").detex
  end
  r += "."
  return r
end

# faithful port from BibDesk template
def render_conference(p)
  r = ""
  if p.authors.size > 0 then
    r += p.authors.map {|a| a.abbreviated_name}.joined_by_comma_and_and + ". "
  end

  r += p.title.detex.titlecase + ". "
  
  r += "In "
  if p.editors.size > 0 then
    r += p.editors.map {|e| e.abbreviated_name}.joined_by_comma_and_and + ", editors, "
  end

  r += p.booktitle.detex.titlecase + ". "
  r += text_for_field("Booktitle", p, :postfix => "").detex.titlecase


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

  if field(p,"Pages") then
    r += text_for_field("Pages", p, :prefix => ", pages ", :postfix => ". ").detex
  end

  if field(p,"Address") then
    r += text_for_field("Address", p, :prefix => ", ")
    r += month_for_field("Month", p, :prefix => ", ", :postfix => " ")
    r += text_for_field("Year", p)
    r += text_for_field("Organization", p, :prefix => ". ")
    r += text_for_field("Publisher", p, :prefix => ", ")
  else
    r += text_for_field("Organization", p, :prefix => ", ")
    r += text_for_field("Publisher", p, :prefix => ", ")
    r += month_for_field("Month", p, :prefix => ", ", :postfix => " ")
    r += text_for_field("Year", p)
  end

  r += text_for_field("Note", p, :postfix => ". ")
  return r

end
