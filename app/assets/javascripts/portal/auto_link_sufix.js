var anchor = document.getElementsByTagName('a');
	    var text = "";
	    for (i = 0; i < anchor.length; i++) {
		    obj = anchor[i];
		    href = obj.getAttribute("href");
		    var match =	href.match(/\/a\/portal-shahalam\//gi)
			if(match!=null ) {
				if(match.length>0){
				 obj.setAttribute('href', href+hashToken);
				}
			}

		}