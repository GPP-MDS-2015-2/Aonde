/*

function show_filter(){
  var c = $("#"+PROGRAMCHART).highcharts();
  d = c.series[0].points;
  e = []
  d.forEach(function(element){ e.push(element.options); });
  //d.forEach(function(e){ f.push(e.options) });
  f = e.clone();
  dataExpenses.program = {'2015': e,'2014': f};
}
*/
function show_filter(idEntity){
  $('#'+idEntity+"."+FILTER).slider({
      range: true,
      min: 2011,
      max: 2015,
      values: [2015,2015],
      slide: function( event, ui ) {        
          console.info("Change the slider")
          /*
            var c = $("#"+PROGRAMCHART).highcharts();
            console.log(c.series[0].points.lenght);
            
            d = c.series[0].points.length-1
            
            for (var j = 0; j < d;j++){
              console.log(j);
              c.series[0].points[0].remove();
            }
          for (var i =ui.values[0];i<=ui.values[1];i++){
            console.debug("To lo looop"+i);
            console.log(dataExpenses);
           
            if (i in dataExpenses.program){              
              dataExpenses.program[i].forEach(function(element){c.series[0].addPoint(element)});
            }else{
              console.log("ha");
            }
        }*/
        }     
    });
}