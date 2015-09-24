$(document).on('page:change', function(){
	$('#tableData').dataTable({
		pagingType: "full_numbers",
		searching: false,
		dom: "<'top p'>",
		processing: true
	});
});