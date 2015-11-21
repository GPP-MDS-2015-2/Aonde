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
  sliderDiv = $('#'+idEntity+"."+FILTER);
  if ( !sliderDiv.hasClass('ui-slider') ){

    sliderDiv.slider({
      range: true,
      min: 2011,
      max: 2015,
      values: [2015,2015],
      slide: function( event, ui ) {        
          console.info("Change the slider")
            var c = $("#"+idEntity+"."+CHART).highcharts();
            console.log(c.series[0].points.lenght);
            
            d = c.series[0].points.length-1
            
            console.debug(d);
            for (var j = 0; j <= d; j++){
              c.series[0].points[0].remove();
            }
            obtainData('/public_agency/10/companies',idEntity,drawCompany,ui.values[0],ui.values[1])
        }
             
    });
  }
}