module Graph
  def self.create_nodes_superior(superio_agency, agencies)
    graph_data = [[{'id'=>1,'name'=> superio_agency.name}],[]]
    agencies.each do |agency|
      name_value = {name: agency.name}
      create_node(PublicAgency, graph_data, name_value)
    end
    return graph_data
  end

  def self.create_node(class_entity, data_graph, name_value)  
    add_node(name_value[:name], data_graph, class_entity.name)
    add_edge(data_graph, class_entity)
    if(name_value[:value])
      add_value(name_value[:value],data_graph)
    end
    rescue Exception => e
      puts "\n\n\n#{e}\n\n"
  end
    def self.add_node(name, data_graph, name_entity)
      node = 0
      next_id = data_graph[node].last['id'] + 1
      data_graph[node] << { 'id' => next_id, 'label' => name,
                            'group' => name_entity }
    end

    def self.add_edge(data_graph,class_entity)
      node = 0
      last_id = data_graph[node].last['id']
      edge = 1
      color = color_edge(class_entity)
      data_graph[edge] << { 'from' => 1, 'to' => last_id, 'color' => color}
    end
    
    def self.add_value(value,data_graph)
      edge = 1
      data_graph[edge].last['title']=value
      data_graph[edge].last['value']=value
    end

    def self.color_edge(class_entity)
      color = nil
      if class_entity.name == PublicAgency.name
        color = '#43BFC5'
      elsif class_entity.name == Company.name
        color = '#FFBC82'
      else
        color
      end
    end
    #private :color_edge
end