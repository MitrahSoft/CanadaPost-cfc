<cfoutput>
	
	<cfset deliveryConfirmationCertificate = Application.trackingObj.getDeliveryConfirmationCertificate( pinNumber = "1371134583769923" )>

	<cfif structIsEmpty(deliveryConfirmationCertificate) neq 'Yes'>
		<a href="#deliveryConfirmationCertificate.filename#" target="_blank">Click here to view the delivery confirmation certificate</a>
	<cfelse>
		No result
	</cfif>

</cfoutput>