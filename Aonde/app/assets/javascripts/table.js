//Define the options to dataTable and control that
$(document).ready( function(){
	$('#tableData').dataTable({
		autoWidth: true,
		pagingType: "full_numbers",
		searching: false,
		order: [1,'desc'],
		//dom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
		 dom: "<'top'ip>",
	});
});