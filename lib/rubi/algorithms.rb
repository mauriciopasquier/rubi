require 'algorithms'

class MinPriorityQueue < Containers::Heap
  def initialize
    super { |a, b| a.distance < b.distance }
  end

  def push(vertex, distance)
    @heap.push(vertex_key(vertex, distance), vertex)
  end

  def decrease_priority(vertex, old_distance, new_distance)
    @heap.change_key(vertex_key(vertex, old_distance), vertex_key(vertex, new_distance))
  end

  private

  def vertex_key(vertex, distance)
    VertexKey.new(vertex, distance)
  end

  VertexKey = Struct.new(:vertex, :distance)
end

module Rubi
  # class Combinations
  #   def self.combinations paths, target_vertices
  #     valid_combinations = paths.combination(target_vertices.sort!.length - 1).select { |combination|
  #       combination.map(&:endpoints).flatten.uniq.sort == target_vertices
  #     }

  #     current_length = Float::INFINITY

  #     combinations = []

  #     valid_combinations.map { |combination|
  #       combination = combination.map(&:edges).flatten.uniq.sort

  #       if combination.length == current_length
  #         combinations << combination
  #       elsif combination.length < current_length
  #         current_length = combination.length
  #         combinations = [combination]
  #       end
  #     }

  #     combinations.uniq.sort
  #   end
  # end

  class Dijkstra
    # https://github.com/monora/rgl/blob/master/lib/rgl/dijkstra.rb
    # http://en.wikipedia.org/wiki/Dijkstra's_algorithm

    def initialize graph, source, target
      distance = Hash.new(Float::INFINITY)
      distance[source] = 0
      
      heap = MinPriorityQueue.new
      tree = Graph.new

      vertices.each do |vertex|
        heap.push vertex, distance[vertex]
      end

      scanned = Hash.new(false)

      until queue.empty?
        u = queue.pop
        scanned[u] = true

        graph.adjacent_vertices(u).each do |v|
          unless scanned[v]
            new_distance = distance[u] + 1 # length(u, v)

            if new_distance <= distance[v]
              if new_distance < distance[v]
                heap.decrease_priority v, distance[v], new_distance
                distance[v] = new_distance
              end

              tree.add_edge DirectedEdge u, v
            end
          end
        end
      end

      return tree
    end
  end # Dijkstra

  class Graph
    def shortest_paths source, target
      Dijkstra.new self, source, target
    end
  end # Graph

end # Rubi
