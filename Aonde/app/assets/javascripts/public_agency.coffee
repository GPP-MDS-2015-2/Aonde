# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# This table is for list the PublicAgencies
jQuery -> $('#tableData').dataTable
	pagingType: "full_numbers"
	searching: false
	dom: "<'top'p>"
	processing: true
	info: false