var anchor = document.getElementsByTagName('a');
var text = "";
for (i = 0; i < anchor.length; i++) {
	obj = anchor[i];
	href = obj.getAttribute("href");
	var match = href.match(/\/a\/portal-dev\//gi)
	if (match != null) {
		if (match.length > 0) {
			obj.setAttribute('href', href + "?token=435975757923454%40.com82f8442236184226cbb304481a65490f&hash=82f8442236184226cbb304481a65490f");
		}
	}

}
