<cfoutput>

	<cfset data.originPostalCode = "K2B8J6">
	<cfset data.postalCode = "J0E1X0">
	<cfset data.countryCode = "CA">
	<cfset data.weight = "1">
	<cfset data.length = "1">
	<cfset data.width = "1">
	<cfset data.height = "1">

	<cfset getRatesRequest = Application.ratingObj.getRates( argumentCollection = data)>
	
	<cfif ArrayIsEmpty(getRatesRequest) neq 'Yes'>
		<table border="1">
			<tr>
				<th>Service Code</th>
				<th>Service Fee</th>
				<th>Servie Name</th>
			</tr>
			<cfloop from="1" to="#arrayLen(getRatesRequest)#" index="i">
				<cfset dataOfRates = getRatesRequest[i]>
				<tr>
					<cfloop collection="#dataOfRates#" item="key">
						<td>#dataOfRates[key]#</td>
					</cfloop>
				</tr>
			</cfloop>
		</table>
	<cfelse>
		No result
	</cfif>
	
</cfoutput>

