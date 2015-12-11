<cfcomponent hint="Canada Post">

	<cffunction name="init" access="public">
		<cfargument name="apiKey" type="string" required="true" />
		<cfargument name="customerNumber" type="string" required="true" />
		<cfargument name="contractNumber" type="string" required="true" />

		<cfset variables.apiKey = arguments.apiKey>
		<cfset variables.customerNumber = arguments.customerNumber>
		<cfset variables.contractNumber = arguments.contractNumber>

		<cfset variables.username = ListFirst(apiKey,':')>
		<cfset variables.password = ListLast(apiKey,':')>

		<cfreturn this />
	</cffunction>

	<cffunction name="getRates" access="public" returntype="any">
		<cfargument name="originPostalCode" type="string" required="true" />
		<cfargument name="postalCode" type="string" required="true" />
		<cfargument name="countryCode" type="string" required="true" />
		<cfargument name="weight" type="string" required="true" />
		<cfargument name="length" type="string" required="true" />
		<cfargument name="width" type="string" required="true" />
		<cfargument name="height" type="string" required="true" />
		
		<cfsavecontent variable="xmlRequest">
			<cfoutput>
				<?xml version="1.0" encoding="utf-8"?>
				<mailing-scenario xmlns="http://www.canadapost.ca/ws/ship/rate-v3">
					<customer-number>#variables.customerNumber#</customer-number>
					<parcel-characteristics>
						<dimensions>
							<length>#NumberFormat(arguments.length, ".9")#</length>
							<width>#NumberFormat(arguments.width, ".9")#</width>
							<height>#NumberFormat(arguments.height, ".9")#</height>
						</dimensions>
						<weight>#NumberFormat(arguments.weight, ".9")#</weight>
					</parcel-characteristics>
					<origin-postal-code>#arguments.originPostalCode#</origin-postal-code>
					<destination>
						<cfif arguments.countryCode EQ 'CA'>
							<domestic>
								<postal-code>#arguments.postalCode#</postal-code>
							</domestic>
						<cfelseif arguments.countryCode EQ 'us'>
							<united-states>
								<zip-code>#arguments.postalCode#</zip-code>
							</united-states>
						<cfelse>
							<international>
								<country-code>#arguments.countryCode#</country-code>
							</international>
						</cfif>
					</destination>
				</mailing-scenario>
			</cfoutput>
		</cfsavecontent>

		<cfset local.url = "https://ct.soa-gw.canadapost.ca/rs/ship/price">

		<cfhttp url="#local.url#" method="post" result="httpResponse" username="#variables.username#" password="#variables.password#">
			<cfhttpparam type="header" name="Accept" value="application/vnd.cpc.ship.rate-v3+xml"/>
			<cfhttpparam type="xml" value="#trim(xmlRequest)#"/>
			<cfhttpparam type="header" name="Content-type" value="application/vnd.cpc.ship.rate-v3+xml">
		</cfhttp>

		<cfset local.resultOfArray = arrayNew(1)>

		<cfif httpResponse.Statuscode eq '200 OK'>
			<cfset getRatesXML = xmlparse(httpResponse.Filecontent)>
			<cfset getRatesDetail = getRatesXML["price-quotes"]["price-quote"]>
			<cfset getRatesNum = ArrayLen(getRatesDetail)>

			<cfloop from="1" to="#getRatesNum#" index="i">
				<cfset getRatesValue = {"service-code":#getRatesDetail[i]["service-code"].XmlText#,"service-name":#getRatesDetail[i]["service-name"].XmlText#,"price-details":#getRatesDetail[i]["price-details"].due.XmlText#}>
				 <cfset ArrayAppend(local.resultOfArray, getRatesValue)> 
			</cfloop>
		</cfif>

		<cfreturn local.resultOfArray />
	</cffunction>

	<cffunction name="discoverServices" returntype="Any" access="public">
		<cfargument name="countryCode" type="any" required="true" />
		<cfargument name="originPostalCode" type="any" required="true" />
		<cfargument name="postalCode" type="any" required="true" />

		<cfset local.url = "https://ct.soa-gw.canadapost.ca/rs/ship/service?country="& #arguments.countryCode# & "&contract=" & #variables.contractNumber# & "&origpc=" & #arguments.originPostalCode# & "&destpc=" & #arguments.postalCode#>

		<cfhttp url="#local.url#" method="get" result="httpResponse" username="#variables.username#" password="#variables.password#">
			<cfhttpparam type="header" name="Accept" value="application/vnd.cpc.ship.rate-v3+xml"/>
		</cfhttp>

		<cfset local.resultOfArray = arrayNew(1)>

		<cfif httpResponse.Statuscode eq '200 OK'>

			<cfset discoverServicesXML = xmlparse(httpResponse.filecontent)>
			<cfset discoverServiceDetail = discoverServicesXML["services"]["service"]>
			<cfset discoverServiceNum = ArrayLen(discoverServiceDetail)>

			<cfloop from="1" to="#discoverServiceNum#" index="i">
				<cfset getServiceValue = {"service-code":#discoverServiceDetail[i]["service-code"].XmlText#,"service-name":#discoverServiceDetail[i]["service-name"].XmlText#}>
				 <cfset ArrayAppend(local.resultOfArray, getServiceValue)> 
			</cfloop>

		</cfif>

		<cfreturn local.resultOfArray />
	</cffunction>

	<cffunction name="getservices" returntype="Any" access="public">
		<cfargument name="countryCode" type="string" required="true" />

		<!--- <cfset local.url = 'https://ct.soa-gw.canadapost.ca/rs/ship/service/DOM.EP?country=' & arguments.countryCode /> --->
		<cfset local.url = 'https://ct.soa-gw.canadapost.ca/rs/ship/service/DOM.EP?country=?' & arguments.countryCode />
		<cfhttp url="#local.url#" method="get" result="httpResponse" username="#variables.username#" password="#variables.password#">
			<cfhttpparam type="header" name="Accept" value="application/vnd.cpc.ship.rate-v3+xml"/>
		</cfhttp>

		<cfset local.resultOfArray = arrayNew(1)>
		
		<cfif httpResponse.Statuscode eq '200 OK'>
			
			<cfset getServices = xmlparse(httpResponse.Filecontent)>
			<cfset getServiceDetail = getServices["service"]["options"]["option"]>
			<cfset getServiceNum = ArrayLen(getServiceDetail)>
			
			<cfloop from="1" to="#getServiceNum#" index="i">
				<cfset getServiceValue = {"option-code":#getServiceDetail[i]["option-code"].XmlText#,"option-name":#getServiceDetail[i]["option-name"].XmlText#}>
				 <cfset ArrayAppend(local.resultOfArray, getServiceValue)> 
			</cfloop>

		</cfif>

		<cfreturn local.resultOfArray />
	</cffunction>

	<cffunction name="getOptions" returntype="Any" access="public">
		<cfargument name="countryCode" type="string" required="true" />

		<cfset local.url = 'https://ct.soa-gw.canadapost.ca/rs/ship/option/' & arguments.countryCode />

		<cfhttp url="#local.url#" method="get" result="httpResponse" username="#variables.username#" password="#variables.password#">
			<cfhttpparam type="header" name="Accept" value="application/vnd.cpc.ship.rate-v3+xml"/>
		</cfhttp>
		
		<cfset local.resultOfArray = arrayNew(1)>

		<cfif httpResponse.Statuscode eq '200 OK'>
			<cfset getOptions = xmlparse(httpResponse.Filecontent)>
			<cfset getOptionValue = {"option-code":#getOptions["option"]["option-code"]["XmlText"]#,"option-name":#getOptions["option"]["option-name"]["XmlText"]#}>
			<cfset ArrayAppend(local.resultOfArray, getOptionValue)>
		</cfif>

		<cfreturn local.resultOfArray />
	</cffunction>

</cfcomponent>