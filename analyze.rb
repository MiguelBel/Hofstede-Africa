require "pp"
require "json"
require "googlecharts"

class Analyzer
  def initialize(data)
    @data = data
    @indexes = @data["raw_data"].collect{|single_data| single_data[0][1]}
    @array_indexes = ["pdi", "idv", "mas", "uai", "lto", "ind"] 
    @north_south_order = ["Morocco","Libya","Cape Verde","Senegal","Burkina Faso","Nigeria","Ghana","Sierra Leone","Ethiopia","Kenya","Tanzania","Angola","Zambia","Malawi","Mozambique","Namibia","South Africa"]
  end

  def getIndexes(nort_south = false)
    return @indexes unless nort_south
    return @north_south_order
  end

  def getArrayIndexes
    return @array_indexes
  end

  def getArrayIndex(index)
    return @array_indexes.find_index(index)

    return array_index
  end

  def getData(index)
    return @data["raw_data"].collect{|single_data| single_data[self.getArrayIndex(index) + 1][1].to_i}
  end

  def plotGlobalBar(index)
    Gchart.bar(:data => [self.getData(index)], :axis_labels => [@indexes, "0|100"], :axis_with_labels => "x,y", :title => "#{index.upcase} level by country", :bar_width_and_spacing => "a", :size => "999x200", :theme => :pastel)
  end

  def getNorthSouthData(index_for_retrieve)
    new_data = []
    self.getIndexes.each_with_index do |single_index, index|
      new_data[@north_south_order.index(single_index)] = self.getData(index_for_retrieve)[index]
    end
    return new_data
  end

  def plotNorthSouthBar(index)
    Gchart.bar(:data => [self.getNorthSouthData(index)], :axis_labels => [@north_south_order, "0|100"], :axis_with_labels => "x,y", :title => "#{index.upcase} level by country", :bar_width_and_spacing => "a", :size => "999x200", :theme => :pastel)
  end

  def getAllPlotsNorthSouth
    all_plots = []
    self.getArrayIndexes.each do |index|
       all_plots.push(self.plotNorthSouthBar(index))
    end

    return all_plots
  end

  def getAllPlotsAlphabetic
    all_plots = []
    self.getArrayIndexes.each do |index|
       all_plots.push(self.plotGlobalBar(index))
    end

    return all_plots
  end

  def getDataForMapPlotting(index)
    all = (@indexes.each_with_index.collect{|single, key| [single, self.getData(index)[key]]})
    all.unshift(["Country", "Some"])
    return all
  end

  def getMaxMinValues
    organized_data = {}

    @array_indexes.each_with_index do |index, key|
      organized_data[index] = @data["raw_data"].collect{|single| single[(key + 1)][1].to_i}
    end

    max_and_mins = []
    @array_indexes.each_with_index do |index, key|
      max = organized_data[index].each_with_index.max
      min = organized_data[index].collect{|single| single == -1 ? 100 : single}.each_with_index.min
      max_and_mins.push([index, [max[0], @indexes[max[1]]], [min[0], @indexes[min[1]]]])
    end

    return max_and_mins
  end
end
