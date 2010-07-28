$LOAD_PATH << File.dirname(__FILE__) + "/../.."

require "render-publication"

class PublicationFilter < Nanoc3::Filter
  identifier :render_publications
  type :text
  
  def run(content, params={})
    content.gsub( /<citation key="(.*)" \/>/ ) { render_publication($1) }
  end

end
