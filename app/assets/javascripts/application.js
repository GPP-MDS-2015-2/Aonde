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
      if (!hash[elementArray[0]]){
        hash[elementArray[0]] = elementArray[1];
      }else{
        console.error("Duplicate key: "+elementArray[0]+'with values: '+
          elementArray[1]+' and '+hash[elementArray[0]]);
        return;
      }
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
/** Valid the entry off user
* @return validText The result of verification
*/
function validSearch(){
  // The value in the field of search 
  keySearch = $('input[name="search"').val();
  console.debug(keySearch);
  // Remove the spaces and speciail characters from key of search
  onlyWords = keySearch.replace(/[^\wà-úÀ-Ú] | [\d]/g,'')
  // Valid size of string bigger then 4
  validSize = false;
  if (onlyWords.length > 4){
    validSize = true;
  }else{
    $('input[name="search"').val('');
    console.info("Invalid input of user");
    $('#error_search_link').click();
  }
  return validSize;
}