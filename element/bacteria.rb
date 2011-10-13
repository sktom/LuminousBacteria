
require '../element/element'

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
class Bacteria < Element
  attr  :brightness  # �������x
	def density; self[:number] / @water[:volume]; end
  # �������

  def routine
    fluctuate
    emit
  end

  private
  #=== ����
  #! �S�Ă̗v�f�̔Z�x���K�v�ȏ�ł��邱�Ƃ�����
  def fiss
    SYSTEM.each do |id, entity|
      return unless entity[:acceptable_density].min < entity.density
    end
    self[:number] *= 2 ** (self[:term_fission] ** (- 1))
  end

  # 
  def fluctuate_case 
      # ����(�e�v�f�̔Z�x�Ɉˑ�����)
      SYSTEM.each do |id, entity|
        ad = entity[:acceptable_density]
        min, max = ad.min, ad.max
        d = entity.density

        case true
        when ad.cover?(d)
          # �������Ȃ�
        when d < min
          self[:number] = 
            (self[:number] * d / min) +
            (self[:number] * (min - d) / min) * (2 ** (- 1.0 / entity[:halflife_shortage]))
        when max < d
          self[:number] *= (max / d) ** (1.0 / entity[:halflife_excess])
        end
      end

      # ����(����)
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

    # ����
    SYSTEM.each do |id, entity|
      entity.consume self
    end
  end

  #fix: �ڍׂ�Jasson���Ƌl�߂�
  def emit
    self[:brightness] = 0
    return unless density > 10

    self[:brightness] = self[volume]
  end


end

