require 'text-helpers'

def render_inproceedings(p)
  r = ""
  r += p.authors.map {|a| a.abbreviated_name}.joined_by_comma_and_and
end

  
#  <?$pubType=inproceedings?>
#  	<$authors.abbreviatedName.@componentsJoinedByCommaAndAnd/>. <$fields.Title.titleCapitalizedString.stringByRemovingTeX/>. In <$editors?><$editors.abbreviatedName.@componentsJoinedByCommaAndAnd/>, editors, </$editors?><$fields.Booktitle.stringByRemovingTeX/><$fields.Volume?>, volume <$fields.Volume/><$fields.Series?> of <$fields.Series/></$fields.Series?><?$fields.Volume?><$fields.Number?>, number <$fields.Number/><$fields.Series?> in <$fields.Series/></$fields.Series?><?$fields.Number?><$fields.Series.stringByPrependingCommaAndSpaceIfNotEmpty/></$fields.Number?></$fields.Volume?><$fields.Pages.stringByPrependingCommaAndSpaceIfNotEmpty/><$fields.Address?>, <$fields.Address/>, <$fields.Month.stringByAppendingSpaceIfNotEmpty/><$fields.Year/>. <$fields.Organization/>, <$fields.Publisher/><?$fields.Address?>, <$fields.Organization/>, <$fields.Publisher/>, <$fields.Month.stringByAppendingSpaceIfNotEmpty/><$fields.Year/></$fields.Address?><$fields.Note.stringByPrependingFullStopAndSpace/>.


