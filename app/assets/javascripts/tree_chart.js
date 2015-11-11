//Var with data incoming from controller
var dataController = [];

var removed = [],inChart = [];

function setChart(path){
    var hasChart = $('#treemap_chart').highcharts();
    if (!hasChart){
        typeExpense(path);
    }else{
        console.log("Já tem o gráfico renderizado no local");
    }
}

function typeExpense(pathTypeExpense){
    console.log(pathTypeExpense);
    
    $.ajax({
        url: pathTypeExpense,
        format: 'json',
        error: function(){
            console.log("Error to try connect with server");
        },
        success: function(data){
            console.log("Receive the data from server of type expense");
            console.log(data);
            dataController = data;
            createListAndChart(dataController);
        }
    });
}

function createListAndChart(data){
    createList(data);
    drawChart(data);
}
function sortData(dataUnorder){
    console.log(dataUnorder);
    dataOrder = [];
    for (var typeExpenses in dataController){
        dataOrder.push([typeExpenses, dataController[typeExpenses].value,dataController[typeExpenses].name])
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
    dataController.forEach(function(element){
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
function drawChart(datas){
    console.log(datas);
    $('#treemap_chart').highcharts({
        colorAxis: {
            minColor: '#FFFFFF',
            maxColor: '#FF7600'//Highcharts.getOptions().colors[0]
        },
        series: [{
            type: "treemap",
            layoutAlgorithm: 'squarified',
            data: datas
        }],
        title: {
            text: 'Gastos por federação'
        }
    });
}
