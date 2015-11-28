
/** Draw the chart in respective id with the options for type expenses
* @param dataProgram Matrix (nx2) with all expenses by type with [name,value]
*/
function drawProgram(dataProgram){
    console.log(dataProgram);
    show_filter(PROGRAM);
    dataProgram.sort(function(a, b) {return b[1] - a[1]})

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
                            removePointToList(this,PROGRAMLIST,PROGRAM);
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