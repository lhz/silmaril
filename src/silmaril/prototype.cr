require "crsfml"

module Silmaril

  alias Colour = Int32
  alias Point  = Tuple(Int32, Int32)
  alias Size   = Tuple(Int32, Int32)

  class Prototype
    include Math

    getter :window
    getter :scale
    getter :frame
    getter :size

    def initialize(@size = {352, 272}, @scale = 2, @bgcol = 0x000, @title = "Prototype")
      @window = SF::RenderWindow.new(
        SF::VideoMode.new(size[0] * scale, size[1] * scale), @title)
      @window.vertical_sync_enabled = true
      @frame = 0
      @autostep = true
      setup
      run
    end

    def setup
    end

    def update
    end

    def run
      while window.open?
        while event = window.poll_event
          handle_event event
        end

        update
        window.clear sf_color(@bgcol)
        draw
        window.display

        @frame += 1 if @autostep
      end
    end

    def plot(at : Point, col : Colour)
      rect = SF::RectangleShape.new({scale, scale})
      rect.position = {at[0] * scale, at[1] * scale}
      rect.fill_color = sf_color(col)
      window.draw rect
    end

    def rect(at : Point, size : Size, col : Colour)
      rect = SF::RectangleShape.new({size[0] * scale, size[1] * scale})
      rect.position = {at[0] * scale, at[1] * scale}
      rect.fill_color = sf_color(col)
      window.draw rect
    end

    private def sf_color(c : Colour) : SF::Color
      SF::Color.new(((c & 0xF00) >> 8) * 17, ((c & 0xF0) >> 4) * 17, (c & 0xF) * 17)
    end

    private def handle_event(event)
      case event
      when SF::Event::Closed
        window.close
      when SF::Event::KeyPressed
        case event.code
        when SF::Keyboard::Escape
          window.close
        when SF::Keyboard::Space
          @autostep = !@autostep
        when SF::Keyboard::Left
          @frame -= 1 unless @autostep
        when SF::Keyboard::Right
          @frame += 1 unless @autostep
        end
      end
    end
  end
end
