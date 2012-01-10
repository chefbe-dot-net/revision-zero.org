require 'wlang'
require 'wlang/dialects/xhtml_dialect'
require 'uri'
require 'albino'

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
      ["<a href='#{href}'>#{label}</a>", offset]
    else 
      [href, offset]
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

  rule "!!" do |parser,offset| 
    text, reached = parser.parse(offset)
    ["<p class=\"attention\">#{text}</p>", reached]
  end

  rule '@' do |parser, offset|
    href, offset = parser.parse(offset)
    if parser.has_block?(offset)
      label, offset = parser.parse_block(offset)
      ["<a href='#{href}'>#{label}</a>", offset]
    else 
      [href, offset]
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
    uri, lexer = nil
    uri, reached = parser.parse(offset, "wlang/uri")
    if parser.has_block?(reached)
      lexer = uri.to_sym
      text, reached = parser.parse_block(reached)
      highlighted = Albino.colorize(text, lexer)
      [highlighted, reached]
    else
      file = RevisionZero::WebApp.send(:content_folder)/uri
      if file.file?
        lexer = File.extname(file)[1..-1].to_sym
        lexer = :text if lexer == :md
        highlighted = Albino.colorize(File.read(file), lexer)
        [highlighted, reached]
      else
        text = parser.parse(offset, "wlang/dummy")[0]
        parser.error(offset, "no such file (#{file})")
      end
    end
  end
  
  rule "!!" do |parser,offset| 
    text, reached = parser.parse(offset)
    [text, reached]
  end
  
  post_transform do |text|
    Kramdown::Document.new(text).to_html
  end

end
