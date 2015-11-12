
var dataProgram;
var removedProgram=[],inChartProgram = [];

function processDataP(data){
    console.log(data);
    dataProgram = data;
    if(dataProgram.length){
        drawChartP(dataProgram);        
    }else{
        console.log("Deu merda");
    }
}

function createPyramidChart(path,idChart){    
    setChart(path,idChart,processDataP);    
}

$("#listChange_1 ul li").click(function(){
    contentRemove = $(this)[0].innerHTML;

    var node = $(this);
    console.log(contentRemove);
    dataProgram.forEach(function(element){
        console.log(removedProgram.indexOf(element) == -1);              
        if ( contentRemove === element[0] ){
            if( removedProgram.indexOf(element) == -1 ){
                removedProgram.push(element);
                inChartProgram.remove(inChartProgram.indexOf(element),1);
                node.addClass("notinChart_1");
                node.removeClass("inChart_1");
            }else{
                node.addClass("inChart_1");
                node.removeClass("notinChart_1");
                inChartProgram.push(element);
                removedProgram.remove(removedProgram.indexOf(element),1);
            }                
        }
    });
    drawChart(inChartProgram);
});
function drawChartP(datas){
    console.log(datas);
    datas.sort(function(a, b) {return b[1] - a[1]})

    $('#program_chart').highcharts({
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
                }
            }
        },
        legend: {
            enabled: false
        },
        series: [{
            name: 'Gastos R$ ',
            data:  datas
        }]
    });
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