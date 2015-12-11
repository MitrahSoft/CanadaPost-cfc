<cfoutput>
	
	<cfset discoverServiceRequest = Application.ratingObj.discoverServices( countryCode = "CA", originPostalCode = "K2B8J6" , postalCode = "J0E1X0")>
	
	<cfif ArrayIsEmpty(discoverServiceRequest) neq 'Yes'>
		<table border="1">
			<tr>
				<th>Service Code</th>
				<th>Servie Name</th>
			</tr>
			<cfloop from="1" to="#arrayLen(discoverServiceRequest)#" index="i">
		  		<cfset dataOfDiscoverService = discoverServiceRequest[i]>
				<tr>
					<cfloop collection="#dataOfDiscoverService#" item="key">
						<td>#dataOfDiscoverService[key]#</td>
					</cfloop>
				</tr>
			</cfloop>
		</table>
	<cfelse>
		No result
	</cfif>

</cfoutput>