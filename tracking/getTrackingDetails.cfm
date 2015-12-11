<cfoutput>
	<cfset trackingDetailsPinNum = Application.trackingObj.getTrackingDetails(pinNumber = "7023210039414604")>
	<cfset trackingDetailsdncNum = Application.trackingObj.getTrackingDetails(dncNumber = "315052413796541")>
	
	<cfif ArrayIsEmpty(trackingDetailsPinNum) neq 'Yes'>
		<b>Tracking Details Pin Number</b>
		<table border="1">
			<tr>
				<th>Event Time</th>
				<th>Event Date</th>
				<th>Event Description</th>
				<th>Event Province</th>
				<th>Event Site</th>
				<th>Event Time Zone</th>
				<th>Event Identifier</th>
			</tr>
			<cfloop from="1" to="#arrayLen(trackingDetailsPinNum)#" index="i">
		  		<cfset dataOfTrackingDetail = trackingDetailsPinNum[i]>
				<tr>
					<cfloop collection="#dataOfTrackingDetail#" item="key">
						<td>#dataOfTrackingDetail[key]#</td>
					</cfloop>
				</tr>
			</cfloop>
		</table><br>
	<cfelse>
		No result
	</cfif>

	<cfif ArrayIsEmpty(trackingDetailsdncNum) neq 'Yes'>
		<b>Tracking Details DNC Number</b>
		<table border="1">
			<tr>
				<th>Event Time</th>
				<th>Event Date</th>
				<th>Event Description</th>
				<th>Event Province</th>
				<th>Event Site</th>
				<th>Event Time Zone</th>
				<th>Event Identifier</th>
			</tr>
			<cfloop from="1" to="#arrayLen(trackingDetailsdncNum)#" index="i">
		  		<cfset dataOfTrackingDetail = trackingDetailsdncNum[i]>
				<tr>
					<cfloop collection="#dataOfTrackingDetail#" item="key">
						<td>#dataOfTrackingDetail[key]#</td>
					</cfloop>
				</tr>
			</cfloop>
		</table>
	<cfelse>
		No result
	</cfif>

</cfoutput>