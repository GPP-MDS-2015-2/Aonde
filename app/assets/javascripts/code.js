  $(document).ready(function(){
      var totalExpense = JSON.parse('<%= raw @a %>')
      var nodes_a = totalExpense[0];
      var edges_a = totalExpense[1];
      console.log(totalExpense);
      console.log(nodes_a);
      console.log(edges_a);
      //generate_nodes_edges(nodes, edges);
    });

function generate_nodes_edges(nodes_a, edges_a){ // on dom ready


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
    nodes: nodes_a
    ,
    edges: edges_a
  },
  
  layout: {
    name: 'preset',
    padding: 5
  }
});

}); // on dom ready
