$(function(){ // on dom ready

var cy = cytoscape({
  container: document.getElementById('cy'),
  
  boxSelectionEnabled: false,
  autounselectify: true,
  
  style: [
    {
//Change style of node
      selector: 'node',
      css: {
        'content': 'data(id)',
        'text-valign': 'center',
        'text-halign': 'center',
        'background-color': 'darkorange'
      }
    },
    {
      selector: '$node > node',
      css: {
        'padding-top': '10px',
        'padding-left': '10px',
        'padding-bottom': '10px',
        'padding-right': '10px',
        'text-valign': 'top',
        'text-halign': 'center',
        'background-color': 'lightblue',
      }
    },
    {
      selector: 'edge',
      css: {
        'target-arrow-shape': 'triangle',
        'line-color': 'orange'
      }
    },
    {
//Don't work this part of code
      selector: ':selected',
      css: {
        'background-color': 'black',
        'line-color': 'black',
        'target-arrow-color': 'black',
        'source-arrow-color': 'black'
      }
    }
  ],
//Insert new elements
  elements: {
    nodes: [
      { "data": { id: 'Empresas' }, position: { x: 100, y: 80 } },
      { "data": { id: 'Ministério2', parent: 'Órgãos Públicos' }, position: { x: 200, y: 80 } },
      { "data": { id: 'qtde Contratações' } },
      { "data": { id: '37', parent: 'qtde Contratações' }, position: { x: 350, y: 30 } },
      { "data": { id: 'Órgãos Públicos' } },
      { "data": { id: 'Ministério1', parent: 'Órgãos Públicos' }, position: { x: 200, y: 30 } },      
    ],
    edges: [
      { data: { id: 'Ministério2Empresas', source: 'Ministério2', target: 'Empresas' } },
      { data: { id: '37Ministério1', source: '37', target: 'Ministério1' } },
      { data: { id: 'Ministério1Empresas', source: 'Ministério1', target: 'Empresas' } }
      
    ]
  },
  
  layout: {
    name: 'preset',
    padding: 5
  }
});

}); // on dom ready