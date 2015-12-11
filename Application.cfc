component output="false"{

	This.name = "CanadaPost API wrapper - Build by MitrahSoft.com";

	public any function onRequestStart() {

		// Test values taken from https://www.canadapost.ca/cpo/mc/business/productsservices/developers/services/fundamentals.jsf#TestValues 
		// Please replace these with your details
		canadaPostCredentials = { apiKey = "6e93d53968881714:0bfa9fcb9853d1f51ee57a", customerNumber = "2004381", contractNumber = "42708517"};
		
		Application.ratingObj = createobject("component","com.mitrahsoft.canadaPostRating").init(argumentcollection=canadaPostCredentials);
		Application.trackingObj = createobject("component","com.mitrahsoft.canadaPostTracking").init(argumentcollection=canadaPostCredentials);

	}

}