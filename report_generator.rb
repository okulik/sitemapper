require_relative "page"

module SiteMapper
  class ReportGenerator
    INDENT = " "
    XML_PROLOG = <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
EOS
    XML_EPILOG = "</urlset>"
    XML_NODE_TEMPLATE1 = <<-EOS
<url>
  <loc>%s</loc>
</url>
EOS
    XML_NODE_TEMPLATE2 = <<-EOS
<url>
  <loc>%s</loc>
  <changefreq>%s</changefreq>
</url>
EOS

    def initialize options
      @options = options
    end

    def to_text(page)
      out = ""
      tree_to_text(page, out)
      return out
    end

    def to_sitemap(page)
      out = XML_PROLOG
      page.each do |p|
        if @options.frequency_type != :none
          out << XML_NODE_TEMPLATE2 % [ p.path, @options.frequency_type ]
        else
          out << XML_NODE_TEMPLATE1 % [ p.path ]
        end
      end
      out << XML_EPILOG
      return out
    end

    private

    def tree_to_text(page, out, depth=0)
      indent = INDENT * 2 * depth
      if page.scraped?
        details = ": a(#{page.anchors.count}), img(#{page.images.count}), link(#{page.links.count}), script(#{page.scripts.count})"
      else
        details = ": #{page.format_codes}"
      end
      out << "#{indent}(#{depth}#{page.scraped? ? "*" : ""}) page #{page.path}#{details}\n"
      return unless page.scraped?

      if page.images.count > 0
        out << "#{indent}#{INDENT}images:\n"
        page.images.each { |img| out << "#{indent}#{INDENT*2}#{img}\n" }
      end
      if page.links.count > 0
        out << "#{indent}#{INDENT}links:\n"
        page.links.each { |link| out << "#{indent}#{INDENT*2}#{link}\n" }
      end
      if page.scripts.count > 0
        out << "#{indent}#{INDENT}scripts:\n"
        page.scripts.each { |script| out << "#{indent}#{INDENT*2}#{script}\n" }
      end
      if page.sub_pages.count > 0
        out << "#{indent}#{INDENT}pages:\n"
        page.sub_pages.each do |sub_page|
          tree_to_text(sub_page, out, depth + 1)
        end
      end
    end

  end
end
