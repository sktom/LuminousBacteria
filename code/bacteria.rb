
require 'component'

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
class Bacteria < Component
	attr	:brightness  # 発光強度
	# 分裂周期
	@@TERM_FISSOIN = 4 * 60
	# 半減期(不足時)
	@@TERM_HALFLIFE_SHORTAGE = {
		:oxgen => 2 * 60,
		:food  => 2 * 60}
  # 半減期(過剰時)
	@@TERM_HALFLIFE_EXCESS = {
		:oxgen => 20 * 60,
		:food  => 20 * 60}
	# 消費量
	@@COMSUMPTION = {
	 	:oxgen => 1,
		:food  => 1}
	# 濃度の許容範囲
	@@ACCEPTABLE_DENSITY = {
	 	:oxgen => 3..5,
		:food  => 3..5}
	def self.ACCEPTABLE_DENSITY; @@ACCEPTABLE_DENSITY; end
	# 増殖漸化式中の係数
	#! 配列のインデクスと次数が対応する
	@@COEFFICIENT = {
		:oxgen => [0, 4.5*10 ** (-3), - 10 ** (- 3)],
		:food  => [0, 4.5*10 ** (-3), - 10 ** (- 3)]}

	def initialize(water, element, volume)
		@element = element
		super(water, volume)
	end

	def routine
		fluctuate
		emit
	end

	private
	#=== 分裂
	#! 全ての要素の濃度が必要以上であることが条件
	def fiss
		@element.each do |id, entity|
			return unless @@ACCEPTABLE_DENSITY[id].min < entity.density
		end
		self.volume *= 2 ** (1.0 / @@TERM_FISSOIN)
	end

	# 
	def fluctuate_case 
			# 減少(各要素の濃度に依存する)
			@element.each do |id, entity|
				ad = @@ACCEPTABLE_DENSITY[id]
				min, max = ad.min, ad.max
				d = entity.density

				case true
				when ad.cover?(d)
					# 減少しない
				when d < min
					self.volume = 
						(@volume * d / min) +
						(@volume * (min - d) / min) * (2 ** (- 1.0 / @@TERM_HALFLIFE_SHORTAGE[id]))
				when max < d
					self.volume *= (max / d) ** (1.0 / @@TERM_HALFLIFE_EXCESS[id])
				end
			end

			# 増加(分裂)
			fiss
	end

	def fluctuate_recurrence
		effect = 0
		@element.each do |id, entity|
			ad = @@ACCEPTABLE_DENSITY[id]
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
				effect += @@COEFFICIENT[id][i] * excess ** i
			end
		end
		self.volume = 2 ** (@@TERM_FISSOIN ** (- 1)) * @volume * (1 + effect)
	end

	def fluctuate
		$mode[:case] ? fluctuate_case : fluctuate_recurrence

		# 消費
		@element.each do |id, entity|
			entity.volume -= @@COMSUMPTION[id] * @volume
		end
	end

	#fix: 詳細はJasson氏と詰める
	def emit
		@brightness = 0
		return unless density > 10

		@brightness = @volume * @element[:oxgen].density * @element[:food].density
	end


end

