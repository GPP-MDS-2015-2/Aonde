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
function showFilter(path,idEntity,updateChart){
  sliderDiv = $('#'+idEntity+"."+FILTER);
  if ( !sliderDiv.hasClass('ui-slider') ){
    sliderDiv.slider({
      range: true,
      min: 2011,
      max: 2015,
      values: [2015,2015],
      slide: function( event, ui ) {        
          console.info("Change the slider")
          if (idEntity!=AGENCY){
            clearChart(idEntity);
          }else{
            console.debug(AGENCY);
            clearAgency();
            console.debug(AGENCY);
          }
          obtainData(path,idEntity,updateChart,ui.values[0],ui.values[1])
        }
             
    });
  }
}
function clearAgency(){
  var chart = $('#'+AGENCY+'.'+CHART).highcharts();
  var size = chart.series[0].points.length;
  var superPoint = 0;
  console.log("ha");
  for (var i = 0; i < size; i++){
    if (chart.series[0].points[superPoint].id.contains('_')){
        chart.series[0].points[superPoint].remove();
    }else{
      superPoint++;
    }
  }
  console.log("ha");
  var size = chart.series[0].points.length;
  for(var i =0; i<size; i++){
    chart.series[0].points[0].remove();
  }
}
function clearChart(idEntity){
  // Clear list removeds
  removedPoints = {};
  $('#'+idEntity+'.'+LIST).empty();

  // Remove points
  var chart = $("#"+idEntity+"."+CHART).highcharts();
  if ( chart != undefined && chart != null ){
    sizePoints = chart.series[0].points.length;
    
    console.debug(sizePoints);
    for (var j = 0; j < sizePoints; j++){
      chart.series[0].points[0].remove();
    }
  }
}