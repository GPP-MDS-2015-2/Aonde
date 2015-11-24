function drawBudget(path,dataBudgetExpense){
console.debug(dataBudgetExpense);
    $('#'+BUDGET+'.'+CHART).highcharts({
        chart: {
            zoomType: 'xy'
        },
        title: {
            text: 'Comparação do orçamento com os gastos dos órgãos'
        },
        xAxis: [{
            categories: ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'],
            crosshair: true
        }],
        yAxis: [{ // Primary yAxis
            labels: {
                format: 'R$ {value}',
                style: {
                    color: Highcharts.getOptions().colors[1]
                }
            },
            title: {
                text: 'Orçamento',
                style: {
                    color: Highcharts.getOptions().colors[1]
                }
            }
        },{ // Secondary yAxis
            labels: {
                format: 'R$ {value}',
                style: {
                    color: Highcharts.getOptions().colors[0]
                }
            },
            title: {
                text: 'Gastos',
                style: {
                    color: Highcharts.getOptions().colors[0]
                }
            },
            opposite: true
        }],
        tooltip: {
            shared: true
        },
        series: [{
            name: 'Gastos',
            type: 'column',
            yAxis: 1,
            data: dataBudgetExpense['expenses'],
            tooltip: {
                valuePrefix: 'R$ '
            }

        }, {
            name: 'Orçamento',
            type: 'line',
            data: dataBudgetExpense['budgets'],
            tooltip: {
                valuePrefix: 'R$ '
            }
        }],
        plotOptions: {
            series: {
                point: {
                    events: {
                        click: function(){
                            console.info("Deseja mesmo remover?");
                        }
                    }
                }
            }
        }
    });
    var chart = $('#'+BUDGET+"."+CHART).highcharts();
    var max = Math.max(chart.yAxis[0].dataMax,chart.yAxis[1].dataMax);
    var min = Math.min(chart.yAxis[0].dataMin,chart.yAxis[1].dataMin);
    console.info("The value of max("+max+") and min("+min+") of the chart");
    chart.yAxis[0].setExtremes(min,max);
    chart.yAxis[1].setExtremes(min,max);

}