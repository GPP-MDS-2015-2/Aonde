function drawCompany(dataCompany){
  $('#'+COMPANYCHART).highcharts({
  chart: {
      plotBackgroundColor: null,
      plotBorderWidth: 0,
      plotShadow: true,
      height: 580
  },
  title: {
      text: 'TOP 5',
      align: 'center',
      verticalAlign: 'middle',
      y: 150,
      x: -160,
      style: {
          color: 'black',
          fontWeight: 'bold',
          fontFamily: 'Times New Roman',
          fontSize: '120px'
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
          startAngle: -90,
          endAngle: 90,
          center: ['35%', '65%']
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

}