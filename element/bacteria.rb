
require '../element/element'

class Bacteria < Element
  attr  :brightness
  def self.set_fluctuation_method fluctuation_type
    @@fluctuation_method = 'fluctuate_'.concat(fluctuation_type.to_s).to_sym
  end
  def density; self[:volume] / @water[:volume]; end

  def routine
    fluctuate
    emit
  end

  private
  def fiss
    SYSTEM.each do |id, entity|
      return unless entity[:acceptable_density].min < entity.density
    end
    self[:volume] *= 2 ** (self[:term_fission] ** -1)
  end

  def fluctuate_case 
    SYSTEM.each do |id, entity|
      ad = entity[:acceptable_density]
      min, max = ad.min, ad.max
      d = entity.density

      case true
      when ad.cover?(d)
        # do nothing
      when d < min
        self[:volume] = 
          self[:volume] * d / min +
          self[:volume] * (min - d) / min * (2 ** (-1.0 / entity[:halflife_shortage]))
      when max < d
        self[:volume] *= (max / d) ** (1.0 / entity[:halflife_excess])
      end
    end

    fiss
  end

  def fluctuate_recurrence
    effect = 0
    SYSTEM.each do |id, entity|
      ad = entity[:acceptable_density]
      min, max = ad.min, ad.max
      d = entity.density

      excess = 
        case true
        when ad.cover?(d)
          0
        when d < min
          d - min
        when max < d
          d - max
        end
      (0..2).each do |i|
        effect += entity[:coefficient][i] * excess ** i
      end
    end
    self[:volume] = 2 ** (self[:term_fission] ** -1) * self[:volume] * (effect + 1)
  end

  def fluctuate
    send @@fluctuation_method 

    SYSTEM.each do |id, entity|
      entity.consume self
    end
  end

  def emit
    self[:brightness] = 0
    return unless density > 10

    self[:brightness] = self[:volume]
  end

end

