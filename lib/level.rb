class Level
  attr_accessor :number

  def initialize(number)
    @number = number
    @monsters = []
    instance_eval File.read(File.expand_path("../../levels/#{number}.rb", __FILE__))
  end

  def name(value = nil)
    if value
      @name = value
    else
      @name
    end
  end

  def description(value = nil)
    if value
      @description = value
    else
      @description
    end
  end

  def fruits_per_second(value = nil)
    if value
      @fruits_per_second = value
    else
      @fruits_per_second
    end
  end

  def fruits(*values)
    if values.length == 0
      @fruits
    else
      @fruits = values
    end
  end

  def time(value = nil)
    if value
      minutes, seconds = value.split(':').map(&:to_i)
      @time = minutes * 60 + seconds
    else
      @time
    end
  end

  def monsters
    yield if block_given?
    @monsters
  end

  def SweetTooth(options = {})
    @monsters.push [SweetTooth, options]
  end
end
