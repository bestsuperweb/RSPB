if (customerToken !== undefined && customerToken !== null && customerHash !== undefined && customerHash !== null) {
	var anchor = document.getElementsByTagName('a');
	var text = "";
	for (i = 0; i < anchor.length; i++) {
		obj = anchor[i];
		href = obj.getAttribute("href");
		var match = href.match(/\/a\//gi)
		if (match != null && match.length > 0) {
			href_token = replaceUrlParam(href, 'token', customerToken);
			new_href = replaceUrlParam(href_token, 'hash', customerHash);
			obj.setAttribute("href", new_href);
		}
	}
}

function replaceUrlParam(url, paramName, paramValue) {
	if (paramValue == null)
		paramValue = '';
	var pattern = new RegExp('\\b(' + paramName + '=).*?(&|$)')
	if (url.search(pattern) >= 0) {
		return url.replace(pattern, '$1' + paramValue + '$2');
	}
	return url + (url.indexOf('?') > 0 ? '&' : '?') + paramName + '=' + paramValue
}
