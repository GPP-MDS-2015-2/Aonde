require 'test_helper'
class GraphGenerator
end

class GraphGeneratorTest < ActiveSupport::TestCase


  test 'return color to PublicAgency' do
    color_agency = Graph.send(:color_edge,PublicAgency)
    color_expected = '#43BFC5'

    assert_equal(color_expected,color_agency)
  end
  test 'return color to Company' do
    
    color_company = Graph.send(:color_edge,Company)
    color_expected = '#FFBC82'

    assert_equal(color_expected,color_company)
  end
  
  test 'null result of entity is not Agency or Company' do
    assert_nil(Graph.send(:color_edge,Program))
  end
  
end
=begin
###############################################################################
Para realizar testes! 
###############################################################################
test 'add edge to array' do
    data_program = [[{ 'id' => 1, 'label' => 'Programa1' },
                     { 'id' => 2, 'label' => 'Company1' }], []]
    value = 500
    @controller.add_edge(data_program, value,PublicAgency)

    data_expected = [[{ 'id' => 1, 'label' => 'Programa1' },
                      { 'id' => 2, 'label' => 'Company1' }],
                     [{ 'from' => 1, 'to' => 2, 'value' => 500,
                        'title' => 'R$ 500,00', 'color' => '#43BFC5' }]]

    assert_equal(data_expected, data_program)
  end
  test 'addition of one node' do
    generate_program_seed
    program_related = [[{ 'id' => 1 }], []]

    @controller.create_node(1, PublicAgency, 1, program_related)
    assert_not_empty(program_related[0])
    assert_not_empty(program_related[1])
  end
  test 'empty return to invalid id' do
    program_related = [[], []]
    @controller.create_node(1, PublicAgency, 1, program_related)
    assert_empty(program_related[0])
    assert_empty(program_related[1])
  end
    test 'Add node to array' do
    data_program = [[{ 'id' => 1, 'label' => 'Programa1' }], []]
    company_add = 'company'

    @controller.add_node(company_add, data_program, Company.name)

    data_expected = [[{ 'id' => 1, 'label' => 'Programa1' },
                      { 'id' => 2, 'label' => 'company',
                        'group' => Company.name }], []]

    assert_equal(data_expected, data_program)
  end
  
=end
