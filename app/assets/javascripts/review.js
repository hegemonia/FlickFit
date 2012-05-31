$(document).ready(function() {
	$("form.review_container input:radio").live('change', function() {$(this.form).submit()})
})