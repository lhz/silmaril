require "crsfml"

module Silmaril
  class Prototype
    include Math

    getter :window
    getter :scale
    getter :frame

    def initialize(@width : Int32, @height : Int32, @scale = 2)
      @frame = 0
      @window = SF::RenderWindow.new(
        SF::VideoMode.new(@width * scale, @height * scale), "Prototype"
        #, settings: SF::ContextSettings.new(depth: 24, antialiasing: 8)
      )
      # window.framerate_limit = 60
      @window.vertical_sync_enabled = true
    end
    
    def run
      while window.open?
        while event = window.poll_event
          case event
          when SF::Event::Resized
          # Nada
          when SF::Event::Closed
            window.close
          when SF::Event::KeyPressed
            case event.code
            when SF::Keyboard::Escape
              window.close
            end
          end
        end

        window.clear SF::Color::Black
        draw
        window.display

        @frame += 1
      end
    end

    def plot(x, y, c)
      rect = SF::RectangleShape.new({scale, scale})
      rect.position = {x * scale, y * scale}
      case c
      when SF::Color
        rect.fill_color = c
      when Int32
        rect.fill_color = SF::Color.new((c & 0xF00) >> 4, c & 0xF0, (c & 0xF) << 4)
      end
      window.draw rect
    end
  end
end
