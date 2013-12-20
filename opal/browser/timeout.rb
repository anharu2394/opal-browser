module Browser

# This class wraps `setTimeout`.
class Timeout
  # @!attribute [r] after
  # @return [Number] the seconds after which the block is called
  attr_reader :after

  # Create and start a timeout.
  #
  # @param window [Window] the window to start the timeout on
  # @param time [Number] seconds after which the block is called
  def initialize(window, time, &block)
    @window = Native.convert(window)
    @after  = time
    @block  = block

    @id = `#@window.setTimeout(#{block.to_n}, time * 1000)`
  end

  # Abort the timeout.
  #
  # @return [self]
  def abort
    `#@window.clearTimeout(#@id)`

    self
  end
end

class Window
  # Execute a block after the given seconds.
  #
  # @param time [Float] the seconds after it gets called
  # @return [Timeout] the object representing the timeout
  def after(time, &block)
    Timeout.new(@native, time, &block)
  end
end

end

class Proc
  def after(time, *args)
    $window.after time do
      call(*args)
    end
  end
end
