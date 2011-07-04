
require '../element/element'

#= バクテリアを表すクラス
#== バクテリアの性質(クラス定数として記述)
#=== 分裂周期
# 何秒に１回分裂するのか
#=== 半減期(要素毎)
# 必要な要素が不足した際の半減期
#=== 濃度の許容範囲(要素毎)
# 繁殖に適した濃度領域
# 発光条件とは別に考える
#=== 消費量(要素毎)
# １秒間に１個体が消費する量
#== バクテリアの活動(インスタンスメソッドとして記述)
#= 増殖
# 増殖漸化式と各種条件に従って、毎秒個体数を変化させる
#= 発光
# 各種条件を満たすと発光する
class Bacteria < Element
  attr  :brightness  # 発光強度
	def density; self[:number] / @water[:volume]; end
  # 分裂周期

  def routine
    fluctuate
    emit
  end

  private
  #=== 分裂
  #! 全ての要素の濃度が必要以上であることが条件
  def fiss
    SYSTEM.each do |id, entity|
      return unless entity[:acceptable_density].min < entity.density
    end
    self[:number] *= 2 ** (self[:term_fission] ** (- 1))
  end

  # 
  def fluctuate_case 
      # 減少(各要素の濃度に依存する)
      SYSTEM.each do |id, entity|
        ad = entity[:acceptable_density]
        min, max = ad.min, ad.max
        d = entity.density

        case true
        when ad.cover?(d)
          # 減少しない
        when d < min
          self[:number] = 
            (self[:number] * d / min) +
            (self[:number] * (min - d) / min) * (2 ** (- 1.0 / entity[:halflife_shortage]))
        when max < d
          self[:number] *= (max / d) ** (1.0 / entity[:halflife_excess])
        end
      end

      # 増加(分裂)
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
    self[:number] = 2 ** (self[:term_fission] ** (- 1)) * self[:number] * (1 + effect)
  end

  def fluctuate
    ARGV[1] == 'true' ? fluctuate_case : fluctuate_recurrence

    # 消費
    SYSTEM.each do |id, entity|
      entity.consume self
    end
  end

  #fix: 詳細はJasson氏と詰める
  def emit
    self[:brightness] = 0
    return unless density > 10

    self[:brightness] = self[volume]
  end


end

