
#= 系を利用する
require 'system'
require 'element'

$mode = {:case => false}
#sys = System.new(10, 5000, 5000, 1000)
#== 初期値を変えて振動限界を見てみると面白いやも
# 漸化式版
# (84.29, 5000, 5000, 1000)
# (10, 9699.56472, 5000, 1000)
# 水で思いっきり薄めたらどうなるのか、とか
element = Element{
	:bacteria => 10
	:water => 1000,
	:oxgen => 5000,
 	:food => 5000}
sys = FlowSystem.new(element)
sys.test(14000)
sys.output('res')


# it looks only dens.
