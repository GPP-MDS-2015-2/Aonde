module Graph
  def self.obtain_name_value(class_entity,data)
    name = 0
    value = 1
    class_name = 1
    if class_entity.name == Program.name
      real_name = data[name].split(' ')
      name_value = {name: real_name[name],value: data[value],class_entity: real_name[class_name]}
    elsif class_entity.name == SuperiorPublicAgency.name
      name_value ={name: data.name,class_entity: PublicAgency}
    end
  end

  def self.create_nodes_superior(superio_agency, agencies)
    graph_data = [[{'id'=>1,'name'=> superio_agency.name}],[]]
    agencies.each do |agency|
      
      create_node(graph_data, name_value)
    end
    return graph_data
  end

  def self.create_node(data_graph, name_value)  
    add_node(name_value[:name], data_graph, name_value[:class_entity])
    add_edge(data_graph, name_value[:class_entity])
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
    if class_entity == PublicAgency.name
      color = '#43BFC5'
    elsif class_entity == Company.name
      color = '#FFBC82'
    else
      color
    end
  end
  #private :color_edge
end