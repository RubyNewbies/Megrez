module TopicsHelper

  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer: language)
    end

    def codespan(code)
      if code[0] == "$" && code[-1] == "$"
        code.gsub!(/^\$/,'')
        code.gsub!(/\$$/,'')
        "<script type=\"math/tex\">#{code}</script>"
      else
        "<code>#{code}</code>"
      end
    end
  end

  def markdown(text)
    renderer = HTMLwithPygments.new(hard_wrap: true)
    options = {
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      autolink: true,
      strikethrough: true,
      lax_html_blocks: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text)
  end

end
