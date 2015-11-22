function drawCompany(path,dataCompany){
  $('#'+COMPANY+"."+CHART).empty();

  $('#'+COMPANY+'.'+CHART).highcharts({
    chart: {
        plotBackgroundColor: null,
        plotBorderWidth: 0,
        plotShadow: true,
        height: 580
    },
    title: {
        text: 'Empresas',
        align: 'center',
        verticalAlign: 'middle',
        y: 150,
        x: 0,
        style: {
            color: 'black',
            fontWeight: 'bold',
            fontFamily: 'Times New Roman',
            fontSize: '60px'
        }
    },
    tooltip: {
        pointFormat: '{series.name}: <b>{point.percentage:.3f}%</b>'
    },
    plotOptions: {
        pie: {
            dataLabels: {
                enabled: true,
                distance: 30,
                style: {
                    fontWeight: 'bold',
                    color: 'black',
                    fontSize: '12px'
                }
            },
            startAngle: -100,
            endAngle: 100,
            center: ['50%', '65%']
        },
        series: {
          cursor: 'crosshair',
          point: {
            events: {
              click: function(){
                removePointToList(this,COMPANYLIST,COMPANY);
              }
            }
          }
        }
    },
    series: [{
        type: 'pie',
        size: '100%',
        name: 'Porcentagem',
        innerSize: '50%',
        data: dataCompany

    }]
  });
  showFilter(path,COMPANY);
}

function updateChart(){
  
}