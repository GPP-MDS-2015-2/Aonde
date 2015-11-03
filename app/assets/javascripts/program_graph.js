var COMPANIESPERPAGE = 150;
var nodes = new vis.DataSet();
var edges = new vis.DataSet();
var companies;
var actualNodes;

function createGraph(dataProgram,idGraph){
	
	var container = document.getElementById(idGraph);
    
    var data = initializeData(dataProgram[0],dataProgram[1],dataProgram[2],dataProgram[3]);
    console.log(data);
    var options = {
          layout:{improvedLayout:false},
          nodes:{
                shape: 'icon',
                icon: {
                    face: 'FontAwesome',
                    code: '\uf015',
                    size: 70,
                    color: 'blue'
                }
            },
      edges: {
        smooth: {
          type: 'curvedCW',
          forceDirection: 'none'
          }
      },
        groups: {
            mints: {color:'rgb(0,150,140)'},
            PublicAgency: {
                shape: 'icon',
                icon: {
                    face: 'FontAwesome',
                    code: '\uf19c',
                    size: 50,
                    color: 'black'
                }
            },
            Company: {
                shape: 'icon',
                icon: {
                    face: 'FontAwesome',
                    code: '\uf1ad',
                    size: 50,
                    color: 'orange'
                }
            },
            source: {
                color:{border:'white'}
            }
        },
        interaction:{
          navigationButtons: true,
          keyboard: true
        },
        physics: {
          repulsion: {
          centralGravity: 1,
          nodeDistance: 1000
        },
          maxVelocity: 20,
          minVelocity: 1,
          solver: 'repulsion'
    }
  };
    
  var network = new vis.Network(container, data, options);
  return network;
}

function initializeData(agencyNodes,edgeAgencies,companiesNodes,edgeCompanies){
	companies = companiesNodes;
	actualNodes = companies.slice(0,COMPANIESPERPAGE);
	nodes.add(agencyNodes);
	nodes.add(actualNodes);
	edges.add(edgeAgencies);
	edges.add(edgeCompanies);
	
	data = {
        nodes: nodes,
        edges: edges
    };
    return data;
}

function cluster(network) {
  var groups = ['PublicAgency','Company'];
  var clusterOptionsByData;
  for (var i = 0; i < groups.length; i++) {
      var group = groups[i];
      var translate_group = translate_groups(group);
      clusterOptionsByData = {
      joinCondition: function (childOptions) {
        return childOptions.group == group; // the group is fully defined in the node.
      },
        clusterNodeProperties: {id: group, borderWidth: 3, shape: 'icon', 
		        group:group, label: translate_group}
      }
    network.cluster(clusterOptionsByData);
  }
}

function uncluster(network,cluster){
	cluster.forEach(function(cluster){
		if( network.isCluster([cluster]) ){
			network.openCluster([cluster]);
		}
	});
}

function createPagesButton(nodes){
	console.log(nodes);
	var number_pages = nodes.length/COMPANIESPERPAGE;
	for (var page =1; page <= number_pages+1; page++){
	  $("#page").append("<input type='button' id='"+page+"' onclick='changePage("+page
	  	+")' value='"+page+"' style='width:30px;height:25px;'></button>");
	}
}
function makeChangePage(page,network){
	uncluster(network,['Company']);
	nodes.remove(actualNodes);
	var indice = COMPANIESPERPAGE*page;
    actualNodes = companies.slice(indice-COMPANIESPERPAGE,indice);
    nodes.add(actualNodes);
    //console.log("\n\n"+page+"\n\n");
	//actualNodes.forEach(function(node){ console.log(node);})
}

function translate_groups (name_groups) {
    if (name_groups === 'PublicAgency'){
      name_groups = 'Órgãos Publicos';
    }
    else{
      name_groups = 'Empresas';  
    }
    console.log(name_groups);
    return name_groups;
}