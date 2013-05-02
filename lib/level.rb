class Level
  attr_accessor :number

  def initialize(number)
    @number = number
    @monsters = []
    instance_eval File.read(File.expand_path("../../levels/#{number}.rb", __FILE__))
  end

  def next
    Level.new(number + 1)
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
      @description = value.split("\n").map(&:strip).join("\n").strip
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

  def hide_patience
    @hide_patience = true
  end

  def hide_patience?
    @hide_patience
  end

  def hide_energy
    @hide_energy = true
  end

  def hide_energy?
    @hide_energy
  end

  def fruits_can_be_grabbed
    @fruits_can_be_grabbed = true
  end

  def fruits_can_be_grabbed?
    @fruits_can_be_grabbed
  end

  def monsters_can_be_grabbed
    @monsters_can_be_grabbed = true
  end

  def monsters_can_be_grabbed?
    @monsters_can_be_grabbed
  end

  def monsters
    yield if block_given?
    @monsters
  end

  def SweetTooth(options = {})
    @monsters.push [SweetTooth, options]
  end
end
