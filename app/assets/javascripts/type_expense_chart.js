/** Draw the chart in respective id with the options for type expenses
* @param dataTypeExpenses Matrix (nx2) with all expenses by type with [type,value]
*/
function drawTypeExpense(dataTypeExpenses){
    console.debug(dataTypeExpenses);
    show_filter(TYPE);
    $('#'+TYPE+'.'+CHART).highcharts({
        colorAxis: {
            minColor: '#FFFFFF',
            maxColor: '#FF7600'//Highcharts.getOptions().colors[0]
        },
        series: [{
            type: "treemap",
            layoutAlgorithm: 'squarified',
            data: dataTypeExpenses
        }],
        title: {
            text: 'Gastos por tipo'
        },
        plotOptions:{
            series:{
                cursor: 'crosshair',
                point:{
                    events:{
                        click: function(){
                            removePointToList(this,TYPELIST,TYPE);
                        }
                    }
                }
            }
        }
    });
}
