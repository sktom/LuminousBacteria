
class System < Hash

  def initialize(exp_name)
    @exp_name = exp_name
    @log= Array.new
    require "../util/xmlparser"
    expcase = XML::Document.new("../exp/#{@exp_name}")[:field]

    Dir.entries('../element/essential').
      find_all{|f| f =~ /\.rb$/}.each do |e|
      require "../element/essential/#{e}"
      end
    [:essential, :additional].each do |etype|
      self[etype] ||= Hash.new
      expcase[etype].each do |element, option|
        self[etype][element] = get_instance(element, option)
      end
    end
  end

  def test(term)
    term.times do
      before_do
      routine
      after_do
    end
    output
  end

  def each
    self[:additional].each{|k, v| yield(k, v) }
  end

  protected
  def before_do; end
  def after_do; end
  def routine
    bacteria = self[:essential][:bacteria]
    bacteria.routine
    @log << [bacteria[:number], bacteria[:brightness]]
  end

  private
  def output
    file_name = "../result/#{@exp_name}"
    File.open(file_name, 'w') do |fout|
      @log.each do |log|
        fout.puts "#{log[0]} #{log[1]}"
      end
    end
    `gnuplot -persist -e "
    plot '#{file_name}' using 1"`
  end

  def get_instance(id, option)
    id = id.to_s.camelize
    id.constantize rescue create_class(id)
    id.constantize.new(self[:essential][:water], option)
  end

  def create_class(id)
    eval "class ::#{id.to_s.camelize} < Element; end"
  end


end

class FlowSystem < System

  def before_do
    import
    export

    each do |id, entity|
      entity[:volume] += 12
    end
  end

  private
  def import
  end

  def export
  end

end

