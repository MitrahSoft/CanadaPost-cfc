<cfoutput>
	
	<cfset getService = Application.ratingObj.getServices(countryCode = "JP")>
	
	<cfif ArrayIsEmpty(getService) neq 'Yes'>
		<table border="1">
			<tr>
				<th>Option Code</th>
				<th>Option Name</th>
			</tr>
			<cfloop from="1" to="#arrayLen(getService)#" index="i">
		  		<cfset dataOfService = getService[i]>
				<tr>
					<cfloop collection="#dataOfService#" item="key">
						<td>#dataOfService[key]#</td>
					</cfloop>
				</tr>
			</cfloop>
		</table>
	<cfelse>
		No result
	</cfif>

</cfoutput>