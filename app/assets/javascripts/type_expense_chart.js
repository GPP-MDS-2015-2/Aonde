//Var with data incoming from controller
var dataTypeExpense = [];

var removed = [],inChart = [];

function sortData(dataUnorder){
    console.log(dataUnorder);
    dataOrder = [];
    for (var typeExpenses in dataTypeExpense){
        dataOrder.push([typeExpenses, dataTypeExpense[typeExpenses].value,dataTypeExpense[typeExpenses].name])
    }
    dataOrder.sort(function(a, b) {return b[1] - a[1]});
    return dataOrder;
}
function createList(dataUnorder){
    sortData(dataUnorder).forEach(function (obj){
        //console.log(obj);
        $("#listChange ul").append("<li class='inChart'>"+obj[2]+"</li>");
    });
}

$("#listChange ul li").click(function(){
    contentRemove = $(this)[0].innerHTML;
    var node = $(this);
    dataTypeExpense.forEach(function(element){
        console.log(removed.indexOf(element) == -1);              
        if ( contentRemove === element.name ){
            if( removed.indexOf(element) == -1 ){
                removed.push(element);
                inChart.remove(inChart.indexOf(element),1);
                node.addClass("notInChart");
                node.removeClass("inChart");
            }else{
                node.addClass("inChart");
                node.removeClass("notInChart");
                inChart.push(element);
                removed.remove(removed.indexOf(element),1);
            }                
        }
    });
});


/** Draw the chart in respective id with the options for type expenses
* @param dataTypeExpenses Matrix (nx2) with all expenses by type with [type,value]
*/
function drawTypeExpense(dataTypeExpenses){
    console.debug(dataTypeExpenses);
    $('#'+TYPECHART).highcharts({
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
                            removePointToList(this,TYPELIST,TYPECHART);
                        }
                    }
                }
            }
        }
    });
}
