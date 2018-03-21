require 'wlang'
require 'wlang/dialects/xhtml_dialect'

class HTMLwithAlbino < Redcarpet::Render::HTML
  def block_code(code, language)
    Albino.colorize(code, language)
  end
end

WLang::dialect('whtml', '.whtml') do
  encoders WLang::EncoderSet::XHtml
  rules    WLang::RuleSet::Basic
  rules    WLang::RuleSet::Imperative
  rules    WLang::RuleSet::Encoding
  rules    WLang::RuleSet::Buffering

  rule '+' do |parser,offset|
    text, reached = parser.parse(offset)
    text = parser.evaluate(text)
    [text, reached]
  end

  rule '@' do |parser, offset|
    href, offset = parser.parse(offset)
    if parser.has_block?(offset)
      label, offset = parser.parse_block(offset)
      [RevisionZero.makelink(href, label), offset]
    else 
      [RevisionZero.makelink(href), offset]
    end
  end

  rule '~' do |parser, offset|
    text, offset = parser.parse(offset)
    text = parser.evaluate(text)
    text, _ = parser.branch(
      :template => WLang::template(text, "active-markdown"),
      :offset   => 0,
      :shared   => :all) do
      parser.instantiate
    end 
    [text, offset]
  end

end

WLang::dialect("active-markdown") do

  rule '@' do |parser, offset|
    href, offset = parser.parse(offset)
    if parser.has_block?(offset)
      label, offset = parser.parse_block(offset)
      [RevisionZero.makelink(href, label), offset]
    else 
      [RevisionZero.makelink(href), offset]
    end
  end

  rule "@?" do |parser,offset| 
    link, reached = parser.parse(offset)
    if parser.has_block?(reached)
      term, reached = parser.parse_block(reached)
    else
      term = link
    end
    link = <<-LINK.strip
      <a href="http://www.google.com/search?q=#{URI.escape(link)}" target="_blank">#{term}</a>
    LINK
    [ link, reached ]
  end

  rule "#<" do |parser, offset|
    uri, lexer, text = nil
    uri, reached = parser.parse(offset, "wlang/uri")
    if parser.has_block?(reached)
      lexer = uri.to_sym
      text, reached = parser.parse_block(reached)
    else
      file = RevisionZero::WebApp.send(:dynamic)/uri
      if file.file?
        lexer = File.extname(file)[1..-1].to_sym
        lexer = :text if lexer == :md
        text  = file.read
      else
        parser.error(offset, "no such file (#{file})")
      end
    end
    ["```#{lexer}\n#{text}\n```", reached]
  end
  
  rule "!!" do |parser,offset| 
    text, reached = parser.parse(offset)
    [text, reached]
  end
  
  rule "%" do |parser,offset| 
    text, reached = parser.parse(offset, "wlang/dummy")
    [text, reached]
  end
  
  post_transform do |text|
    begin
      @markdown ||= begin
        opts = {:fenced_code_blocks => true}
        Redcarpet::Markdown.new(HTMLwithAlbino, opts)
      end
      @markdown.render(text)
    rescue
      text
    end
  end

end
