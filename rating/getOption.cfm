<cfoutput>
	
	<cfset getOptionsRequest = Application.ratingObj.getOptions(countryCode = "SO")>
	
	<cfif ArrayIsEmpty(getOptionsRequest) neq 'Yes'>
		<cfset dataOfOptions = getOptionsRequest[1]>
		<table border="1">
			<tr>
				<th>Option Code</th>
				<th>Option Name</th>
			</tr>
			<tr>
				<cfloop collection="#dataOfOptions#" item="key">
					<td>#dataOfOptions[key]#</td>
				</cfloop>
			</tr>
		</table>
	<cfelse>
		No result
	</cfif> 

</cfoutput>