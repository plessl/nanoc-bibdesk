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


def text_for_field(fieldname, p, params)
  prefix = params[:prefix]
  postfix = params[:postfix]
  
  if field(p,fieldname) then
    return prefix + field(p,fieldname) + postfix
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

  r += field(p,"Booktitle").detex + ", "

  if field(p,"Volume") then
    r += ", volume " + field(p,"Volume") + " "
  end

  if field(p,"Number") then
    r += ", number " + field(p,"Number") + " "
  end

  if field(p,"Series") then
    r += "of " + field(p,"Series").detex + ", "
  end

  r += text_for_field("Pages", p, :prefix => ", pages ", :postfix => ". ").detex

#  if field(p,"Pages") then
#    r += ", pages " + field(p,"Pages").detex + ". "
#  end

  if field(p,"Address") then
    r += field(p,"Address").detex + ", "
  end

  if field(p,"Organization") then
    r += field(p,"Organization").detex + ", "
  end

  if field(p,"Month") then
    r += field(p,"Month").detex + " "
  end

  if field(p,"Year") then
    r += field(p,"Year").detex + ". "
  end

  if field(p,"Publisher") then
    r += field(p,"Publisher").detex + ". "
  end

  if field(p,"Note") then
    r += field(p,"Note").detex + ". "
  end
  
  return r
end

  
#  <?$pubType=inproceedings?>
#  	<$authors.abbreviatedName.@componentsJoinedByCommaAndAnd/>. <$fields.Title.titleCapitalizedString.stringByRemovingTeX/>. In #<$editors?><$editors.abbreviatedName.@componentsJoinedByCommaAndAnd/>, editors, </$editors?><$fields.Booktitle.stringByRemovingTeX/>
#<$fields.Volume?>, volume <$fields.Volume/>
#<$fields.Series?> of <$fields.Series/></$fields.Series?>
#<?$fields.Volume?><$fields.Number?>, number <$fields.Number/><$fields.Series?> in <$fields.Series/></$fields.Series?><?$fields.Number?><$fields.Series.stringByPrependingCommaAndSpaceIfNotEmpty/></$fields.Number?></$fields.Volume?>
#<$fields.Pages.stringByPrependingCommaAndSpaceIfNotEmpty/>
#<$fields.Address?>, <$fields.Address/>,
# <$fields.Month.stringByAppendingSpaceIfNotEmpty/><$fields.Year/>.
# <$fields.Organization/>, 
#<$fields.Publisher/>
#<?$fields.Address?>, <$fields.Organization/>, <$fields.Publisher/>, #<$fields.Month.stringByAppendingSpaceIfNotEmpty/><$fields.Year/></$fields.Address?>
#<$fields.Note.stringByPrependingFullStopAndSpace/>.


