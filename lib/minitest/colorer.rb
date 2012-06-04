module MiniTest
  class Colorer
    # Start an escape sequence
    ESC = "\e["

    # End the escape sequence
    NND = "#{ESC}0m"

    # The IO we're going to pipe through.
    attr_reader :io

    def initialize(io) # :nodoc:
      @io = io
    end

    ##
    # Wrap print to colorize the output.

    def print(o)
      case o
      when "." then
        io.print success(o)
      when "E" then
        io.print error(o)
      when "F" then
        io.print failure(o)
      when "S" then
        io.print skip(o)
      else
        io.print o
      end
    end

    def puts(*o) # :nodoc:
      o.map! { |s|
        s.sub(/(\d+\) )(Failure|Error)(.+)/m) {
          status = ($2 == 'Failure') ? 'failure' : 'error'
          "#{$1}#{send(status, $2)}#{$3}"
        }.sub(/(\d+ tests?, \d+ assertions?, (\d+) failures?, (\d+) errors?, (\d+) skips?)/) {
          if $2.to_i > 0
            failure($1)
          elsif $3.to_i > 0
            error($1)
          elsif $4.to_i > 0
            skip($1)
          else
            success($1)
          end
        }
      }

      super
    end

    def method_missing(msg, *args) # :nodoc:
      io.send(msg, *args)
    end

    COLORS =  {
      :black   => 30,
      :blue    => 34,
      :cyan    => 36,
      :green   => 32,
      :magenta => 35,
      :red     => 31,
      :white   => 37,
      :yellow  => 33
    }

    COLORS.each do |color_name, color_value|
      define_method color_name do |string|
        "#{ESC}#{color_value}m#{string}#{NND}"
      end
    end

    def success(text)
      green(text)
    end

    def error(text)
      yellow(text)
    end

    def failure(text)
      red(text)
    end

    def skip(text)
      cyan(text)
    end
  end
end
MiniTest::Unit.output = MiniTest::Colorer.new(MiniTest::Unit.output)
