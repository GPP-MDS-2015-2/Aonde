
var dataProgram;
var removedProgram=[],inChartProgram = [];

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


/** Draw the chart in respective id with the options for type expenses
* @param dataProgram Matrix (nx2) with all expenses by type with [name,value]
*/
function drawProgram(dataProgram){
    console.log(dataProgram);
    dataProgram.sort(function(a, b) {return b[1] - a[1]})

    $('#'+PROGRAMCHART).highcharts({
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
            data:  dataProgram
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