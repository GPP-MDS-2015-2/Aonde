//Define the options to dataTable and control that
$(document).ready( function(){
	$('#tableData').dataTable({
		autoWidth: true,
		pagingType: "full_numbers",
		searching: true,
		columnDefs:[],
		order: [1,'desc'],
		//dom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
		 dom: "<'top'>t<'bottom'pi>",
		 oLanguage:{
		 	sUrl: '//cdn.datatables.net/plug-ins/1.10.9/i18n/Portuguese-Brasil.json'
		 }
	});

});

//Define the options to dataTable and control that
$(document).ready( function(){
	$('#tableData1').dataTable({
		autoWidth: true,
		pagingType: "full_numbers",
		searching: true,
		columnDefs:[
			{
				visible: false,
				targets:0
			}],
		order: [1,'desc'],
		//dom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
		 dom: "<'top'>t<'bottom'pi>",
		 oLanguage:{
		 	sUrl: '//cdn.datatables.net/plug-ins/1.10.9/i18n/Portuguese-Brasil.json'
		 }
	});

});


function filterTable(name){
	var table = $('#tableData1').DataTable();
	table.column(0).search(name).draw();
}
