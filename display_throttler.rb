
class DisplayThrottler

  attr_accessor :framerate

  def initialize framerate
    @framerate = framerate
    @last_throttle_time = Time.now
    @ticks_left_until_odd_throttle = 13 
  end
 
  def throttle
    sleep_and_return [time_left_for_this_frame, odd_throttle_delay].max
  end


private

  def time_left_for_this_frame
    time_allotted_per_frame - time_since_last_frame
  end

  def time_allotted_per_frame
    @time_allotted_per_frame ||= compute_time_allotted_per_frame 
  end

  def time_since_last_frame
    time = Time.now - @last_throttle_time
    @last_throttle_time = Time.now
    time
  end


  def compute_time_allotted_per_frame
    if framerate <= 0
      0.0
    else
      1.0/framerate
    end
  end

  def sleep_and_return delay 
    sleep delay
    delay
  end

  def odd_throttle_delay
    @ticks_left_until_odd_throttle -= 1
    if @ticks_left_until_odd_throttle <= 0 
      @ticks_left_until_odd_throttle = 13 
      0.01
    else
      0
    end
  end 
 
end
