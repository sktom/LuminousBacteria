
#= �n�𗘗p����
require 'system'
require 'element'

$mode = {:case => false}
#sys = System.new(10, 5000, 5000, 1000)
#== �����l��ς��ĐU�����E�����Ă݂�Ɩʔ������
# �Q������
# (84.29, 5000, 5000, 1000)
# (10, 9699.56472, 5000, 1000)
# ���Ŏv�������蔖�߂���ǂ��Ȃ�̂��A�Ƃ�
element = Element{
	:bacteria => 10
	:water => 1000,
	:oxgen => 5000,
 	:food => 5000}
sys = FlowSystem.new(element)
sys.test(14000)
sys.output('res')


# it looks only dens.
