# Copyright 2019 Tan Nhu, Maarten Brakkee
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# plugin imported from https://github.com/tnhu/jekyll-include-absolute-plugin

module Jekyll
  class IncludeTagError < StandardError
    attr_accessor :path

    def initialize(msg, path)
      super(msg)
      @path = path
    end
  end

  class IncludeAbsoluteTag < Liquid::Tag
    VARIABLE_SYNTAX = %r!
        (?<variable>[^{]*(\{\{\s*[\w\-\.]+\s*(\|.*)?\}\}[^\s{}]*)+)
        (?<params>.*)
      !x

    def initialize(tag_name, markup, tokens)
      super

      @file = markup.strip
    end

    # Render the variable if required (@see https://goo.gl/N5sMV3)
    def render_variable(context)
      if @file.match(VARIABLE_SYNTAX)
        partial = context.registers[:site]
          .liquid_renderer
          .file("(variable)")
          .parse(@file)
        partial.render!(context)
      end
    end

    def render(context)
      file  = render_variable(context) || @file
      source = File.expand_path(context.registers[:site].config['source']).freeze
      path   = File.join(source, file)

      begin
        partial = Liquid::Template.parse(read_file(path, context))

        context.stack do
          context['include'] = parse_params(context) if @params
          partial.render!(context)
        end
      rescue => e
        raise IncludeTagError.new e.message, path
      end
    end

    def read_file(file, context)
      File.read(file, file_read_opts(context))
    end

    def file_read_opts(context)
      context.registers[:site].file_read_opts
    end
  end
end

Liquid::Template.register_tag('include_absolute', Jekyll::IncludeAbsoluteTag)
