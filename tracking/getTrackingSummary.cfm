<cfoutput>
	<cfset trackingSummaryPinNum = Application.trackingObj.getTrackingSummary(pinNumber = "7023210039414604")>
	<cfset trackingSummaryDncNum = Application.trackingObj.getTrackingSummary(dncNumber = "315052413796541")>
	<cfset trackingSummaryReference = Application.trackingObj.getTrackingSummaryReference( mailingDateTo = "2015-04-05" , destinationPostalCode = "K0J1T0", mailingDateFrom = "2015-04-12", referenceNumber ='APRIL1REF1A')>
 
	<cfif structIsEmpty(trackingSummaryPinNum) neq 'Yes'>
		<b>Tracking Summary Pin Number</b>
		<table border="1">
			<cfloop collection="#trackingSummaryPinNum#" item="key">
				<tr>
					<th>#key#</th>
					<td>#trackingSummaryPinNum[key]#</td>
				</tr>
			</cfloop>
		</table><br>
	<cfelse>
		No result
	</cfif>
	
	<cfif structIsEmpty(trackingSummaryDncNum) neq 'Yes'>
		<b>Tracking Summary DNC Number</b>
		<table border="1">
			<cfloop collection="#trackingSummaryDncNum#" item="key">
				<tr>
					<th>#key#</th>
					<td>#trackingSummaryDncNum[key]#</td>
				</tr>
			</cfloop>
		</table>
	<cfelse>
		No result
	</cfif>

</cfoutput>