
require 'component'

#= �o�N�e���A��\���N���X
#== �o�N�e���A�̐���(�N���X�萔�Ƃ��ċL�q)
#=== �������
# ���b�ɂP�񕪗􂷂�̂�
#=== ������(�v�f��)
# �K�v�ȗv�f���s�������ۂ̔�����
#=== �Z�x�̋��e�͈�(�v�f��)
# �ɐB�ɓK�����Z�x�̈�
# ���������Ƃ͕ʂɍl����
#=== �����(�v�f��)
# �P�b�ԂɂP�̂�������
#== �o�N�e���A�̊���(�C���X�^���X���\�b�h�Ƃ��ċL�q)
#= ���B
# ���B�Q�����Ɗe������ɏ]���āA���b�̐���ω�������
#= ����
# �e������𖞂����Ɣ�������
class Bacteria < Component
	attr	:brightness  # �������x
	# �������
	@@TERM_FISSOIN = 4 * 60
	# ������(�s����)
	@@TERM_HALFLIFE_SHORTAGE = {
		:oxgen => 2 * 60,
		:food  => 2 * 60}
  # ������(�ߏ莞)
	@@TERM_HALFLIFE_EXCESS = {
		:oxgen => 20 * 60,
		:food  => 20 * 60}
	# �����
	@@COMSUMPTION = {
	 	:oxgen => 1,
		:food  => 1}
	# �Z�x�̋��e�͈�
	@@ACCEPTABLE_DENSITY = {
	 	:oxgen => 3..5,
		:food  => 3..5}
	def self.ACCEPTABLE_DENSITY; @@ACCEPTABLE_DENSITY; end
	# ���B�Q�������̌W��
	#! �z��̃C���f�N�X�Ǝ������Ή�����
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
	#=== ����
	#! �S�Ă̗v�f�̔Z�x���K�v�ȏ�ł��邱�Ƃ�����
	def fiss
		@element.each do |id, entity|
			return unless @@ACCEPTABLE_DENSITY[id].min < entity.density
		end
		self.volume *= 2 ** (1.0 / @@TERM_FISSOIN)
	end

	# 
	def fluctuate_case 
			# ����(�e�v�f�̔Z�x�Ɉˑ�����)
			@element.each do |id, entity|
				ad = @@ACCEPTABLE_DENSITY[id]
				min, max = ad.min, ad.max
				d = entity.density

				case true
				when ad.cover?(d)
					# �������Ȃ�
				when d < min
					self.volume = 
						(@volume * d / min) +
						(@volume * (min - d) / min) * (2 ** (- 1.0 / @@TERM_HALFLIFE_SHORTAGE[id]))
				when max < d
					self.volume *= (max / d) ** (1.0 / @@TERM_HALFLIFE_EXCESS[id])
				end
			end

			# ����(����)
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

		# ����
		@element.each do |id, entity|
			entity.volume -= @@COMSUMPTION[id] * @volume
		end
	end

	#fix: �ڍׂ�Jasson���Ƌl�߂�
	def emit
		@brightness = 0
		return unless density > 10

		@brightness = @volume * @element[:oxgen].density * @element[:food].density
	end


end

