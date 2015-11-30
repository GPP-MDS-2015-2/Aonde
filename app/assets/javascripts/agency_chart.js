    /** Method which draw the chart of public agency
    * @params points The expense processed for chart(Array)
    */
    function drawAgency(path,agencyData) {
        points = processData(agencyData);
        console.debug(points);
        $('#'+AGENCY+'.'+CHART).highcharts({
            series: [{
                type: 'treemap',
                layoutAlgorithm: 'squarified',
                allowDrillToNode: true,
                dataLabels: {
                    enabled: false
                },
                levelIsConstant: false,
                levels: [{
                    level: 1,
                    dataLabels: {
                        enabled: true
                    },
                    borderWidth: 3
                }],
                data: points
            }],
            subtitle: {
                text: 'Clique nos anos para ver os gastos por mês'
            },
            title: {
                text: 'Gastos dos Órgãos Publicos'
            }
        });
        showFilter(path,AGENCY,updateAgency);
    }
function updateAgency(path,data){
    points = processData(data);
    sizePoint = points.length;
    var chart = $('#'+AGENCY+'.'+CHART).highcharts();
    for (var i = sizePoint-1; i>=0; i--){
        chart.series[0].addPoint(points[i]);
    }
}
  /** Method which process the data to draw the chart
    * @params data The expenses of public agency (Object)
    * @return points The expense processed for chart(Array)
    */
    function processData(data) {
        
        //The expense processed for chart
        var points = [];
        //Counter of year
        var yearCount = 0;
        console.info("Processing data to draw chart");
        // Loop which create the points of each year
        console.debug(data);
        for (year in data) {
            console.debug(year);
            //Check if data has year
            if (data.hasOwnProperty(year)) {
                //Pointer for each year
                var yearSquare = {
                    id: year,
                    name: year,
                    color: Highcharts.getOptions().colors[yearCount]
                };
                // The sum value of all months of a year
                var yearValue = createPointForMonths(data[year], yearSquare, points);
                yearSquare.value = Math.round(yearValue);
                points.push(yearSquare);
                yearCount = yearCount + 1;
            }
            else{
                console.warn('data not have year');
            }
        }
        return points;
    }
    /** Method which create points of months for a determined year
    * @params data[year] The data for a determined year(Object)
    * @params value The value of expenses for a determined year(Integer)
    * @params square The point of determined year(Object)
    * @params The expense processed for chart(Array)
    */
    function createPointForMonths(data, square, points) {
        //Month of expense
        var month;
        //Counter of month
        var monthCount = 0;
        console.info("Creating the month points for each year");
        // The sum value of all months of a year
        var yearValue = 0;
        //Loop which create the points of months
        for(month in data) {
            //Check if data has month
            if(data.hasOwnProperty(month)) {
                //Pointer for each month
                var monthSuare = {
                    id: square.id + '_' + monthCount,
                    name: month,
                    parent: square.id,
                    value: Math.round(+data[month])
                };
                yearValue += monthSuare.value;
                points.push(monthSuare);
                monthCount = monthCount + 1;
            }
            else{
                console.warn('data not have month');
            }
        }
        return yearValue;
    }