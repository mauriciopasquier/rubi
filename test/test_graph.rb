require 'minitest/autorun'
require 'rubi'

include Rubi

describe Graph do
  def graph
    @graph ||= Graph.new DirectedEdge.new(:a, :b), UndirectedEdge.new(:b, :c)
  end

  describe '#eql?' do
    it 'is equal' do
      same_graph = Graph.new UndirectedEdge.new(:b, :c), DirectedEdge.new(:a, :b)

      graph.must_equal same_graph
    end

    it 'is not equal' do
      different_graph = Graph.new DirectedEdge.new(:b, :a), UndirectedEdge.new(:b, :c)

      graph.wont_equal different_graph
    end
  end
end
