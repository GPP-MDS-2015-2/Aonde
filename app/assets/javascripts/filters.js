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
    sliderDiv.rangeSlider({
      bounds: {min: 2011, max: 2015},
      defaultValues: {min: 2015,max:2015},
      symmetricPositionning: true,
      range: false,
      step: 1,
      arrows: false
    });
    // Preferred method
  sliderDiv.on("valuesChanged", function(e, data){
    if (idEntity!=AGENCY){
            clearChart(idEntity,0);
    }else{
      console.debug(AGENCY);
      clearAgency();
      console.debug(AGENCY);
    }
    obtainData(path,idEntity,updateChart,data.values.min,data.values.max)
    console.log("Something moved. min: " + data.values.min + " max: " + data.values.max);
});
  }
}
/*{
      range: true,
      min: 2011,
      max: 2015,
      values: [2015,2015],
      /*slide: function( event, ui ) {        
          console.info("Change the slider")
        },
        stop: function(event,ui){
          
        }
    }*/

function budgetFilter(path,idEntity,updateChart){
  sliderDiv = $('#'+idEntity+"."+FILTER);
  if ( !sliderDiv.hasClass('ui-slider') ){
    sliderDiv.slider({
      range: false,
      min: 2012,
      max: 2015,
      value: 2015,
      /*slide: function( event, ui ) {        
          console.info("Change the slider")
        },*/
        stop: function(event,ui){
          $('#year_filter').empty();
          $('#year_filter').append("Ano atual: "+ui.value);
          console.debug(ui);
          clearChart(idEntity,0);
          clearChart(idEntity,1);
          obtainData(path,idEntity,drawBudget,ui.value,ui.value);
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
function clearChart(idEntity,series){
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