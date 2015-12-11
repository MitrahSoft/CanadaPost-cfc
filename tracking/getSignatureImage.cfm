<cfoutput>
	<cfset signatureImage = Application.trackingObj.getSignatureImage(pinNumber = "1371134583769923")>
	
	<cfif structIsEmpty(signatureImage) neq 'Yes'>
		<img src="#signatureImage.filename#">
	<cfelse>
		No result
	</cfif>
	
</cfoutput>

