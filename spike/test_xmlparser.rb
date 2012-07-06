
require './xmlparser'

describe XML::Document do
  before do
    @xml = XML::Document.new('cc')
  end

  it 'is' do
    @xml[:field][:essence][:bacteria][:term_fission].should == 10 ** 3
    @xml[:field][:element][:oxgen][:halflife_excess].should == 10 ** 3
    @xml[:field][:element][:food][:acceptable_density].should == (3..5)
    @xml[:field][:element][:food][:coefficient].should ==
      [0, 4.5 * 10 ** -3, - 10 ** -3]
  end

end

