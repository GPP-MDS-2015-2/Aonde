
/** Draw the chart in respective id with the options for type expenses
* @param dataProgram Matrix (nx2) with all expenses by type with [name,value]
*/
function drawProgram(path,dataProgram){
  console.log(dataProgram);
  dataProgram.sort(function(a, b) {return b[1] - a[1]})
  $('#'+PROGRAM+"."+CHART).empty();

  $('#'+PROGRAM+'.'+CHART).highcharts({
      chart: {
          type: 'pyramid',
          marginRight: 400
      },
      title: {
          text: 'Programas',
          x: -50
      },
      plotOptions: {            
          series: {
              dataLabels: {
              enabled: true,
              format: '<b>{point.name}</b> ({point.y:,.0f})',
              color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black',
              softConnector: true
          },
              cursor: 'crosshair',
              point: {
                  events: {                        
                      click: function(){
                          removePointToList(this,PROGRAM);
                      }
                  }
              }
          }            
      },
      legend: {
          enabled: false
      },
      series: [{
          name: 'Gastos R$ ',
          data:  dataProgram
      }]
  });
  showFilter(path,PROGRAM,updateProgram);
}
function updateProgram(path,data){
  var chart = $('#'+PROGRAM+"."+CHART).highcharts();
  if( chart != undefined){
    if ( chart.series[0].points.length && data.length){
      chart.series[0].points.forEach(function(point){
        var sizeData = data.length;
        var i = 0;
        var found = false;
        do{
          if ( data[i][0] === point.name ){
            found = true; 
            console.debug("found"+data[i][0]+" == "+point.name);
          }
        }while( !found && ++i < sizeData );
        if (found){
          point.y+=data[i][1];
          data.remove(i,1);
        }      
      });
      data.forEach(function(element){
        chart.series[0].addPoint(element);
      });
    }else{
      data.forEach(function(element){
        chart.series[0].addPoint(element);
      });
    }
  }else{
    console.error("No graph ploted");
  } 
  chart.render();
}
/*
$(document).ready( function () {
    $('#tableCompany').DataTable({
        data: JSON.parse('<%= raw @all_programs%>'),
        pageLength: 1000,
        lengthChange: false,
        searching: false,
        paging: false,
        destroy: true,
        oLanguage:{
            sUrl: '//cdn.datatables.net/plug-ins/1.10.9/i18n/Portuguese-Brasil.json'
        }
    });
        
});
*/