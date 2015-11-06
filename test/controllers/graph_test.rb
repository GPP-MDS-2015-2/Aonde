require 'test_helper'

class GraphGeneratorTest < ActiveSupport::TestCase
  test 'return color to PublicAgency' do
    color_agency = Graph.send(:color_edge, PublicAgency)
    color_expected = '#43BFC5'

    assert_equal(color_expected, color_agency)
  end
  test 'return color to Company' do
    color_company = Graph.send(:color_edge, Company)
    color_expected = '#FFBC82'

    assert_equal(color_expected, color_company)
  end

  test 'null result of entity is not Agency or Company' do
    assert_nil(Graph.send(:color_edge, Program))
  end

  test 'add edge to array' do
    data_graph = [[{ 'id' => 1, 'label' => 'Programa1' },
                   { 'id' => 2, 'label' => 'Company1' }], []]
    Graph.add_edge(data_graph, PublicAgency)

    data_expected = [[{ 'id' => 1, 'label' => 'Programa1' },
                      { 'id' => 2, 'label' => 'Company1' }],
                     [{ 'from' => 1, 'to' => 2, 'color' => '#43BFC5' }]]

    assert_equal(data_expected, data_graph)
  end

  test 'empty return to invalid id' do
    data_graph = [[], []]
    name_value = { name: 'valid name' }
    Graph.create_node(PublicAgency, data_graph, name_value)
    assert_empty(data_graph[0])
    assert_empty(data_graph[1])
  end

  test 'Addition of one node without value' do
    data_graph = [[{ 'id' => 1, 'label' => 'Programa1' }], []]
    name_value = { name: 'valid name' }
    Graph.create_node(PublicAgency, data_graph, name_value)
    data_expected = [[{ 'id' => 1, 'label' => 'Programa1' },
                      { 'id' => 2, 'label' => 'valid name',
                        'group' => PublicAgency.name }],
                     [{ 'from' => 1, 'to' => 2, 'color' => '#43BFC5' }]]

    assert_equal(data_expected, data_graph)
  end
  test 'Addition of one node with value' do
    data_graph = [[{ 'id' => 1, 'label' => 'Programa1' }], []]
    name_value = { name: 'valid name', value: 500 }
    Graph.create_node(PublicAgency, data_graph, name_value)
    data_expected = [[{ 'id' => 1, 'label' => 'Programa1' },
                      { 'id' => 2, 'label' => 'valid name',
                        'group' => PublicAgency.name }],
                     [{ 'from' => 1, 'to' => 2, 'color' => '#43BFC5',
                        'title' => 'R$ 500,00', 'value' => 500 }]]

    assert_equal(data_expected, data_graph)
  end
end