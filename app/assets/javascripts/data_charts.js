/** data_charts.js
* Manage the data necessary to draw the charts of expenses by the categories
*/

// Define constant of key for dataExpenses (String)
var TYPE = 'type_expense';
var BUDGET = 'budget';
var COMPANY = 'company';
var PROGRAM = 'program';
var AGENCY = 'public_agency';

// Contain all type of expenses of requisitions (Hash)
var dataExpenses = {type_expense: {}, budget: {}, company: {}, program: {}, public_agency: {}};
var removedPoints = {};

// Define constants of id for drawn charts (String)
var CHART = 'chart';
var FILTER = 'filter';
var LIST = 'list';

var LIMITCOMPANY = 100;

/** Verify if the chart is drawn and if the data has the interval of data need
* @param path The route to controller (String)
* @param idChart The id of field to drawn the chart (String)
* @param drawnFunction Function drawn the chart
*/
function setChart(path,idChart,drawFunction){
    console.debug(path+" "+idChart);

    // Verify the chart in page (Object)
    var hasChart = $('#'+idChart+'.'+CHART).highcharts();
    if (!hasChart){
      loadinScreen(idChart);
      console.info("The page has no chart draw");
      obtainData(path,idChart,drawFunction,2015,2015);
      
    }else{
        console.info("The chart is already draw");
    }   
}
/** Make the requisition to the controller and obtain the data of expenses
* @param path The route to controller (String)
* @param idChart The id of field to drawn the chart (String)
* @param drawnFunction Function drawn the chart
*/
function obtainData(path,idChart,drawFunction,year,year_stop){
  if ( dataExpenses[idChart][year] == undefined ){
    $.ajax({
        url: path,
        method: 'GET',
        data: {year: year},
        format: 'json',
        error: function(){
            console.error("Error to try connect with server");
            $('#'+idChart+"."+CHART).empty();
            $('#'+idChart+"."+CHART).append("Ops, nao obtivemos os dados para desenhar o gráfico");
        },
        success: function(data){
          console.debug(data);
          
          if(isValidData(data) && isValidId(idChart)){
            console.info("Process of data received from controller");
            addData(year,idChart,data);
            drawFunction(path,cloneObject(data));
          }else{ 
            console.warn("Data received from controller or id of chart"
              +"has length == 0");
          }
          obtainNextYear(path,idChart,drawFunction,year,year_stop)
        }
        
    });
    console.info("Requisição ajax realizada");
  }else {
    drawFunction(path,cloneObject(dataExpenses[idChart][year]));
    obtainNextYear(path,idChart,drawFunction,year,year_stop);
  }
}
function obtainNextYear(path,idChart,drawFunction,year,year_stop){

  if ( year < year_stop ){
    console.log(year);
    console.log(year_stop);
    obtainData(path,idChart,drawFunction,year+1,year_stop);
  }
}

function addData(year,entity,data){
  dataExpenses[entity][year] = data;
}

/** Verify if the data received from controllers is valid
* @param data Data received from controller in determined data struct (Object)
* @return validId The definition if the id is not empty and valid (boolean)
*/
function isValidData(data){

    console.debug("Data in method processData:");
    console.debug(data);

    // The valid data of the chart (Boolean)
    var validData = true;
    if (data != null && data != undefined){
        console.info("The data is valid");
    }else{
      console.error("The data received is null or undefined");
      validData = false;
    }
    return validData;
}
/** Remove one point from a chart
* @param idListRemoved add again in list chart (String)
* @param idChart add again in list chart (String)
*/
function removePointToList(point,idChart){
  console.debug(point);
  // Use name for id
  
  removedPoints[point.options.name] = point.options;
  generateList(point.options.name,idChart);
  point.remove();
}

/** Verify if the id of chart is correct
* @param idChart The id of field to drawn the chart (String)
* @return validId The definition if the id is not empty and valid (boolean)
*/
function isValidId(idChart){

    console.debug("id in method processData:");
    console.debug(idChart);

    // The valid id of the chart (Boolean)
    var validId = true;
    if (idChart != null && idChart != undefined && idChart.length){
      if (idChart === PROGRAM || idChart === COMPANY || 
        idChart === TYPE || idChart === BUDGET || idChart === AGENCY){
        console.info("The id is valid"+idChart);
      }else{
        console.warn("Invalid id of chart"+ idChart);
        validId = false;
      }  
    }else{
      console.error("The id received is null or undefined");
      validId = false;
    }
    return validId;
}

function loadinScreen(idChart){
  node = '<center><div class="preloader-wrapper big active">'+
  '<div class="spinner-layer spinner-blue-only">'+
  '<div class="circle-clipper left">'+
  '<div class="circle"></div>'+
  '</div><div class="gap-patch">'+
  '<div class="circle"></div>'+
  '</div><div class="circle-clipper right">'+
  '<div class="circle"></div>'+
  '</div></div></div> </center>'
  $('#'+idChart+'.'+CHART).empty();
  $('#'+idChart+'.'+CHART).append(node);
}
/** Generate list and show list of elements in chart
* @param idList add again in list chart (String)
* @param nameElement name of element in list (String)
* @param idChart add again in list chart (String)
*/
function generateList(nameElement,idChart) {
      name = nameElement.replace(/[^\w]/gi,'_');
      // Build element to add in the list (String)
      newElement = "<a class='collection-item' id='"+name+"' style='cursor:n-resize'>"+
                    nameElement+"</a>";
      console.info("Insert element "+ nameElement +"/"+name+" in the list " + idChart);
      $('#'+ idChart+'.'+LIST).append(newElement);

      $("#"+name).click(function(){
        addElementChart(nameElement,idChart);
        this.remove();
        console.info("Remove the element from list");
      });
}
/** Add element back to the list 
* @param nameElement name of element in list (String)
* @param idChart add again in list chart (String)
*/
function addElementChart(nameElement,idChart){
  // Add point again in the list 
  chart = $('#'+idChart+'.'+CHART).highcharts(); 
  chart.series[0].addPoint(removedPoints[nameElement]);
}
