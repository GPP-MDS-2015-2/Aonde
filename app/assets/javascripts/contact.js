function sendEmail(path) {
	console.debug(path);
	var email = $('input[name=from]').val();
	var subject = $('input[name=subject]').val();
	var text = $('textarea[name=text]').val();
	if (verifyPrecense(email,subject,text)){
		$.ajax({
			url: path,
			data: {
				from: email,
				subject: subject,
				text: text
			},
			format: 'json',
			method: 'POST',
			error: function(ajax,status,mais) {
				console.debug(ajax)
				console.debug(status);
				console.debug (mais);
				Materialize.toast("Ops, ocorreu algum erro!", 4000);
				console.error("Error na aplicaçao");
			},
			success: function() {
				
				Materialize.toast("Email Enviado", 4000, 'rounded', 'green');
				console.info("Envio com sucesso");

			}
		});
		$('input[name=from]').val('');
		$('input[name=subject]').val('');
		$('textarea[name=text]').val('');
	}
	return false;
}

function verifyPrecense(email, subject, text) {
	$("#message_error_field").empty();
	opentag = "<center>";
	closetag = "<br></center>";
	valid=true;
	if(!email.length){
		$("#message_error_field").append(opentag + "Campo email vazio! Por favor preencha!" + closetag);
		valid = false;
	}
	if(!subject.length){
		$("#message_error_field").append(opentag + "Campo assunto vazio! Por favor preencha!" + closetag);
		valid = false;
	}
	if(!text.length){
		$("#message_error_field").append(opentag + "Campo texto vazio! Por favor preencha!" + closetag);
		valid = false;
	}
	if(!valid){
		$('#error_field_contact').click();
	}
	return valid;
}