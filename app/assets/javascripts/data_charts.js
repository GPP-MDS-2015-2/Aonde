/** data_charts.js
* Manage the data necessary to draw the charts of expenses by the categories
*/

// Define constant of key for dataExpenses (String)
var TYPE = 'type';
var BUDGET = 'budget';
var COMPANY = 'company';
var PROGRAM = 'program';

// Contain all type of expenses of requisitions (Hash)
var dataExpenses = {type: null, budget: null, company: null, program: null, agency: null};

// Define constants of id for drawn charts (String)
var PROGRAMCHART = 'program_chart';
var COMPANYCHART = 'company_chart';
var TYPECHART = 'type_expense_chart';
var BUDGETCHART = 'budget_chart';

// Define constants of id for list
var PROGRAMLIST = 'program_list';
var COMPANYLIST = 'company_list';
var TYPELIST = 'type_list';

/** Verify if the chart is drawn and if the data has the interval of data need
* @param path The route to controller (String)
* @param idChart The id of field to drawn the chart (String)
* @param drawnFunction Function drawn the chart
*/
function setChart(path,idChart,drawFunction){
    console.debug(path+" "+idChart);

    // Verify the chart in page (Object)
    var hasChart = $('#'+idChart).highcharts();
    if (!hasChart){
      console.info("The page has no chart draw");
      obtainData(path,idChart,drawFunction);
    }else{
        console.info("The chart is already draw");
    }   
}

/** Make the requisition to the controller and obtain the data of expenses
* @param path The route to controller (String)
* @param idChart The id of field to drawn the chart (String)
* @param drawnFunction Function drawn the chart
*/
function obtainData(path,idChart,drawFunction){
  loadinScreen(idChart);
  $.ajax({
      url: path,
      format: 'json',
      error: function(){
          console.error("Error to try connect with server");
      },
      success: function(data){
        if(isValidData(data) && isValidId(idChart)){
          console.info("Process of data received from controller");
          $('#'+idChart).empty();
          drawFunction(data);
        }else{ 
          console.warn("Data received from controller or id of chart"
            +"has length == 0");
        }
        
      }
      
  });
  console.info("Requisição ajax realizada")
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
var removedPoints = {};
function removePointToList(point,idListRemoved,idChart){
  console.debug(point);
  // Use name for id
  
  removedPoints[point.options.name] = point.options;
  generateList(idListRemoved,point.options.name,idChart);
  point.remove();
}

/** Verify if the id of chart is correct
* @param idChart The id of field to drawn the chart (String)
* @return validId The definition if the id is not empty and valid (boolean)
*/
function isValidId(idChart){

    console.debug("Data in method processData:");
    console.debug(idChart);

    // The valid id of the chart (Boolean)
    var validId = true;
    if (idChart != null && idChart != undefined && idChart.length){
      if (idChart === PROGRAMCHART || idChart === COMPANYCHART || 
        idChart === TYPECHART || idChart === BUDGETCHART){
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
  $('#'+idChart).empty();
  $('#'+idChart).append(node);
}
/** Generate list and show list of elements in chart
* @param idList add again in list chart (String)
* @param nameElement name of element in list (String)
* @param idChart add again in list chart (String)
*/
function generateList(idList,nameElement,idChart) {
      name = nameElement.replace(/[^\w]/gi,'_');
      // Build element to add in the list (String)
      newElement = "<a class='collection-item' id='"+name+"' style='cursor:n-resize'>"+
                    nameElement+"</a>";
      console.info("Insert element "+ nameElement +"/"+name+" in the list " + idList);
      $('#'+ idList).append(newElement);

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
  chart = $('#'+idChart).highcharts(); 
  chart.series[0].addPoint(removedPoints[nameElement]);
}
