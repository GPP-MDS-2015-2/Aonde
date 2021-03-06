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
//= require_tree ../../../vendor/assets/javascripts/jQuery
//= require materialize-sprockets
//= require jquery.turbolinks
//= require highcharts/highcharts
//= require Fireworks
//= require_tree ../../../vendor/assets/javascripts/slider
//= require_tree ../../../vendor/assets/javascripts/visjs
//= require_tree ../../../vendor/assets/javascripts/highcharts
//= require_tree ../../../vendor/assets/javascripts/dataTable
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

function cloneObject(object){
  var newObject;
  if (object != undefined && object != null){
    newObject = JSON.parse(JSON.stringify(object));
  }else{
    newObject = object;
  }
  return newObject;
}
Number.prototype.formatMoney = function(){
var n = this, 
    c = 2, 
    d = "," , 
    t = ".", 
    s = n < 0 ? "-" : "", 
    i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", 
    j = (j = i.length) > 3 ? j % 3 : 0;
   return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
 };

 jQuery.fn.dataTableExt.aTypes.unshift(
  function ( sData )
  {
    var sValidChars = "0123456789-,";
    var Char;
    var bDecimal = false;
    
    /* Check the numeric part */
    for ( i=0 ; i<sData.length ; i++ )
    {
      Char = sData.charAt(i);
      if (sValidChars.indexOf(Char) == -1)
      {
        return null;
      }
      
      /* Only allowed one decimal place... */
      if ( Char == "," )
      {
        if ( bDecimal )
        {
          return null;
        }
        bDecimal = true;
      }
    }
    
    return 'numeric-comma';
  }
);

jQuery.fn.dataTableExt.oSort['numeric-comma-asc']  = function(a,b) {
  var x = (a == "-") ? 0 : a.replace(/./,"").replace( /,/, "." ).replace(/R$/, "");
  var y = (b == "-") ? 0 : b.replace(/./,"").replace( /,/, "." ).replace(/R$/, "");
  x = parseFloat( x );
  y = parseFloat( y );
  return ((x < y) ? -1 : ((x > y) ?  1 : 0));
};

jQuery.fn.dataTableExt.oSort['numeric-comma-desc'] = function(a,b) {
  var x = (a == "-") ? 0 : a.replace(/./,"").replace( /,/, "." ).replace(/R$/, "");
  var y = (b == "-") ? 0 : b.replace(/./,"").replace( /,/, "." ).replace(/R$/, "");
  x = parseFloat( x );
  y = parseFloat( y );
  return ((x < y) ?  1 : ((x > y) ? -1 : 0));
};