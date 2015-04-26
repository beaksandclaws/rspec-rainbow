# RainbowColorizer overrides RSpec's ConsoleCodes to wrap
# success messages in rainbow colors
module RSpec
  module Core
    module Formatters
      module RainbowColorizer
        extend ::RSpec::Core::Formatters::ConsoleCodes
        PI_3 = Math::PI / 3

        module_function

        # Wraps a piece of text in ANSI codes with the supplied code. Will
        # only apply the control code if `RSpec.configuration.color_enabled?`
        # returns true.
        #
        # @param text [String] the text to wrap
        # @param code_or_symbol [Symbol, Fixnum] the desired control code
        # @return [String] the wrapped text
        def wrap(text, code_or_symbol)


          colors = (0...(6 * 7)).map { |n|
            n *= 1.0 / 6
            r  = (3 * Math.sin(n           ) + 3).to_i
            g  = (3 * Math.sin(n + 2 * PI_3) + 3).to_i
            b  = (3 * Math.sin(n + 4 * PI_3) + 3).to_i

            36 * r + 6 * g + b + 16
          }
          color_index = 0

          if RSpec.configuration.color_enabled? && code_or_symbol == RSpec.configuration.success_color
            rainbow_text = ""

            text.each_char do |letter|

              color_index == (colors.size - 1) ? color_index = 0 : color_index += 1
              rainbow_color = colors[color_index]

              rainbow_text += "\e[38;5;#{rainbow_color}m#{letter}\e[0m"
            end

            rainbow_text
          elsif RSpec.configuration.color_enabled?
            "\e[#{console_code_for(code_or_symbol)}m#{text}\e[0m"
          else
            text
          end
        end

      end
    end
  end
end

