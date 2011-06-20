
#= Œn‚ð—˜—p‚·‚é
require 'system'
require 'element'

$mode = {:case => false}
#sys = System.new(10, 5000, 5000, 1000)
#== ‰Šú’l‚ð•Ï‚¦‚ÄU“®ŒÀŠE‚ðŒ©‚Ä‚Ý‚é‚Æ–Ê”’‚¢‚â‚à
# ‘Q‰»Ž®”Å
# (84.29, 5000, 5000, 1000)
# (10, 9699.56472, 5000, 1000)
# …‚ÅŽv‚¢‚Á‚«‚è”–‚ß‚½‚ç‚Ç‚¤‚È‚é‚Ì‚©A‚Æ‚©
element = Element{
	:bacteria => 10
	:water => 1000,
	:oxgen => 5000,
 	:food => 5000}
sys = FlowSystem.new(element)
sys.test(14000)
sys.output('res')


# it looks only dens.
