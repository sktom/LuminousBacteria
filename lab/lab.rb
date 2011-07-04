
require '../system/system'

SYSTEM = FlowSystem.new(ARGV[0])
SYSTEM.test(10000)

