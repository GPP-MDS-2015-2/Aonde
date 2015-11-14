// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require materialize-sprockets
//= require jquery.turbolinks
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require highcharts/highcharts
//= require_tree ../../../vendor/assets/javascripts
//= require visjs/vis
//= require turbolinks
//= require_tree .

/** Add a transformation of Object atributes in Array class
* @return array Array with array in elements with 2 positions
*/

/*Object.prototype.toArray = function(){
  array = []
  for (key in this){
    array.push([key,this[key]]);
  }
  return array;
};*/

/** Check the elements of array and constroy a hash
* @return hash Object in formar key-value
*/
Array.prototype.toHash = function(){
  var hash = {};
  if ( this.length >=1 && this[0].length == 2) {
    this.forEach(function(elementArray){
      hash[elementArray[0]] = elementArray[1];
    });  
  }else if (this.length == 0 ){
    console.error("The array is empty");
  }else if (this[0].length != 2){
    console.error("Impossible convert the array in hash"+
      "the element has no length equal 2");
  }else{
    console.error("Impossible convert the array in hash with unknow cause");
  }
  return hash;  
}

/** Increment a function of clone to class Array
*/
Array.prototype.clone = function() {
    return this.slice(0);
}

/** Increment a function to remove one element  to class Array
* @param start Index element (Integer)
* @param end Number elements to be removed (Integer)
*/
Array.prototype.remove = function(start, end) {
  this.splice(start, end);
  return this;
}

/** Increment the clear to class Array
*/
Array.prototype.clear = function() {
  	while(this.length){
  		this.pop();
  	}
  	return this;
}

// Define constant of key for dataExpenses (String)
var TYPE = 'type';
var BUDGET = 'budget';
var COMPANY = 'company';
var PROGRAM = 'program';

// Contain all type of expenses of requisitions (Hash)
var dataExpenses = {type: null, budget: null, company: null, program: null};

// Define constants of id for drawn charts (String)
var PROGRAMCHART = 'program_chart';
var COMPANYCHART = 'company_chart';
var TYPECHART = 'type_expense_chart';
var BUDGETCHART = 'budget_chart';

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
  
  $.ajax({
      url: path,
      format: 'json',
      error: function(){
          console.error("Error to try connect with server");
      },
      success: function(data){
        if(isValidData(data) && isValidId(idChart)){
          console.info("Process of data received from controller");
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