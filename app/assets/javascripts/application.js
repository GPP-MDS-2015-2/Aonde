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

Array.prototype.clone = function() {
    return this.slice(0);
};
Array.prototype.remove = function(start, end) {
  this.splice(start, end);
  return this;
}

Array.prototype.clear = function() {
  	while(this.length){
  		this.pop();
  	}
  	return this;
}