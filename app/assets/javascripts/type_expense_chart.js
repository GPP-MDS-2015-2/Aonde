/** Draw the chart in respective id with the options for type expenses
* @param dataTypeExpenses Matrix (nx2) with all expenses by type with [type,value]
*/
function drawTypeExpense(path,dataTypeExpenses){
    console.debug(dataTypeExpenses);
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
                            removePointToList(this,TYPE);
                        }
                    }
                }
            }
        }
    });
    showFilter(path,TYPE,updateType);
}
function updateColor(points,totalValue){
    points.forEach(function(point){
        point.update({colorValue: point.value*100/totalValue});
    });
}
function updateType(path,data){
    console.info("Update chart");
    var chart = $('#'+TYPE+'.'+CHART).highcharts();
    if (chart != undefined){
        if (chart.series[0].data.length && data.length){

            chart.series[0].data.forEach(function(element){
                sizeData = data.length;
                i =0;
                var found = false;
                do{ 
                    if (data[i]['name'] == element.name ){
                        found = true;
                    }
                }while(!found && ++i<sizeData);
                if(found){
                    element.update({value: element.value+data[i]['value']});
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
    updateColor(chart.series[0].points,chart.series[0].tree.val);
    }
}