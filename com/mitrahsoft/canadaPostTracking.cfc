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

	<cffunction name="getTrackingSummary" returntype="Any" access="public">
		<cfargument name="pinNumber" type="any" required="false" default=""/>
		<cfargument name="dncNumber" type="any" required="false" default=""/>

		<cfif arguments.pinNumber neq ''>
			<cfset local.url = "https://ct.soa-gw.canadapost.ca/vis/track/pin/#arguments.pinNumber#/summary">
		<cfelse>
			<cfset local.url = "https://ct.soa-gw.canadapost.ca/vis/track/dnc/#arguments.dncNumber#/summary">
		</cfif>
		
		<cfhttp url="#local.url#" method="get" result="httpResponse" username="#variables.username#" password="#variables.password#">
			<cfhttpparam type="header" name="Accept" value="application/vnd.cpc.track+xml"/>
			<cfhttpparam type="header" name="Accept-language" value="en-CA"/>
		</cfhttp>

		<cfset local.resultOfStructure  = structNew()>

		<cfif httpResponse.Statuscode eq '200 OK'>
			<cfset trackingSummaryXML = xmlparse(httpResponse.Filecontent)>
			
			<cfset local.resultOfStructure = {"pin":#trackingSummaryXML["tracking-summary"]["pin-summary"]["pin"]["XmlText"]#, "destinationPostalID":#trackingSummaryXML["tracking-summary"]["pin-summary"]["destination-postal-id"]["XmlText"]#
			, "mailedOnDate":#trackingSummaryXML["tracking-summary"]["pin-summary"]["mailed-on-date"]["XmlText"]#
			, "actualDeliveryDate":#trackingSummaryXML["tracking-summary"]["pin-summary"]["actual-delivery-date"]["XmlText"]#
			, "expectedDeliveryDate":#trackingSummaryXML["tracking-summary"]["pin-summary"]["expected-delivery-date"]["XmlText"]#
			, "eventDescription":#trackingSummaryXML["tracking-summary"]["pin-summary"]["event-description"]["XmlText"]#}>
		</cfif>

		<cfreturn local.resultOfStructure>
	</cffunction>

	<cffunction name="getTrackingSummaryReference" returntype="Any" access="public">
		<cfargument name="mailingDateTo" type="any" required="true" />
		<cfargument name="destinationPostalCode" type="any" required="true" />
		<cfargument name="mailingDateFrom" type="any" required="true" />
		<cfargument name="referenceNumber" type="any" required="true" />

		 <cfset local.url = "https://ct.soa-gw.canadapost.ca/vis/track/ref/summary?mailingDateTo=" & #arguments.mailingDateTo# & "&mailingDateFrom=" & #arguments.mailingDateTo# & "&referenceNumber=" & #arguments.referenceNumber# & "&customerNumber=" & #variables.customerNumber# & "&destinationPostalCode=" & #arguments.destinationPostalCode#> 

		<cfhttp url="#local.url#" method="get" result="httpResponse" username="#variables.username#" password="#variables.password#">
			<cfhttpparam type="header" name="Accept" value="application/vnd.cpc.track+xml"/>
			<cfhttpparam type="header" name="Accept-language" value="en-CA"/>
		</cfhttp>

		<cfset local.resultOfStructure  = structNew()>
<!--- <cfdump var="#httpResponse.Filecontent#" /><cfabort />
		<cfif httpResponse.Statuscode eq '200 OK'>
			<cfset trackingSummaryDncNumXML = xmlparse(httpResponse.Filecontent)>
			
			<cfset local.resultOfStructure = {"pin":#trackingSummaryDncNumXML["tracking-summary"]["pin-summary"]["pin"]["XmlText"]#, "destinationPostalID":#trackingSummaryDncNumXML["tracking-summary"]["pin-summary"]["destination-postal-id"]["XmlText"]#
			, "mailedOnDate":#trackingSummaryDncNumXML["tracking-summary"]["pin-summary"]["mailed-on-date"]["XmlText"]#
			, "actualDeliveryDate":#trackingSummaryDncNumXML["tracking-summary"]["pin-summary"]["actual-delivery-date"]["XmlText"]#
			, "expectedDeliveryDate":#trackingSummaryDncNumXML["tracking-summary"]["pin-summary"]["expected-delivery-date"]["XmlText"]#
			, "eventDescription":#trackingSummaryDncNumXML["tracking-summary"]["pin-summary"]["event-description"]["XmlText"]#}>
		</cfif>
 --->
		<cfreturn local.resultOfStructure>
	</cffunction>

	<cffunction name="getTrackingDetails" returntype="Any" access="public">
		<cfargument name="pinNumber" type="any" required="true" default=""/>
		<cfargument name="dncNumber" type="any" required="false" default=""/>
		
		<cfif arguments.pinNumber neq '' >
			<cfset local.url = "https://ct.soa-gw.canadapost.ca/vis/track/pin/#arguments.pinNumber#/detail">
		<cfelse>
			<cfset local.url = "https://ct.soa-gw.canadapost.ca/vis/track/dnc/#arguments.dncNumber#/detail">
		</cfif>

		<cfhttp url="#local.url#" method="get" result="httpResponse" username="#variables.username#" password="#variables.password#">
			<cfhttpparam type="header" name="Accept" value="application/vnd.cpc.track+xml"/>
			<cfhttpparam type="header" name="Accept-language" value="en-CA"/>
		</cfhttp>

		<cfset local.resultOfArray  = arrayNew(1)>

		<cfif httpResponse.Statuscode eq '200 OK'>
			<cfset trackingDetailsXML = xmlparse(httpResponse.Filecontent)>
			<cfset trackingDetail = trackingDetailsXML["tracking-detail"]["significant-events"]["occurrence"]>
			<cfset getTrackingDetailNum = ArrayLen(trackingDetail)>
			
			<cfloop from="1" to="#getTrackingDetailNum#" index="i">
				<cfset getTrackingDetailValue = {"event-identifier":#trackingDetail[i]["event-identifier"].XmlText#,
				"event-date":#trackingDetail[i]["event-date"].XmlText#,
				"event-time":#trackingDetail[i]["event-time"].XmlText#,
				"event-time-zone":#trackingDetail[i]["event-time-zone"].XmlText#,
				"event-description":#trackingDetail[i]["event-description"].XmlText#,
				"event-site":#trackingDetail[i]["event-site"].XmlText#,
				"event-province":#trackingDetail[i]["event-province"].XmlText#
				}>
				 <cfset ArrayAppend(local.resultOfArray, getTrackingDetailValue)> 
			</cfloop>
		</cfif>
		<cfreturn local.resultOfArray>
	</cffunction>

	<cffunction name="getSignatureImage" returntype="Any" access="public">
		<cfargument name="pinNumber" type="any" required="true" />

		<cfset local.url = "https://ct.soa-gw.canadapost.ca/vis/signatureimage/#arguments.pinNumber#">

		<cfhttp url="#local.url#" method="get" result="httpResponse" username="#variables.username#" password="#variables.password#">
			<cfhttpparam type="header" name="Accept" value="application/vnd.cpc.track+xml"/>
			<cfhttpparam type="header" name="Accept-language" value="en-CA"/>
		</cfhttp>

		<cfset local.resultOfStructure  = structNew()>

		<cfif httpResponse.Statuscode eq '200 OK'>
			<cfset signatureImageXML = xmlparse(httpResponse.Filecontent)>

			<cffile action="write" file="#expandPath('.')#\#signatureImageXML["signature-image"]["filename"]["XmlText"]#" output="#ToBinary(signatureImageXML["signature-image"]["image"]["XmlText"])#">
			
			<cfset local.resultOfStructure = {"filename":#signatureImageXML["signature-image"]["filename"]["XmlText"]#}>
		</cfif>
		<cfreturn local.resultOfStructure>
	</cffunction>

	<cffunction name="getDeliveryConfirmationCertificate" returntype="Any" access="public">
		<cfargument name="pinNumber" type="any" required="true" />

		<cfset local.url = "https://ct.soa-gw.canadapost.ca/ot/certificate/#arguments.pinNumber#">

		<cfhttp url="#local.url#" method="get" result="httpResponse" username="#variables.username#" password="#variables.password#">
			<cfhttpparam type="header" name="Accept" value="application/vnd.cpc.track+xml"/>
			<cfhttpparam type="header" name="Accept-language" value="en-CA"/>
		</cfhttp>

		<cfset local.resultOfStructure  = structNew()>

		<cfif httpResponse.Statuscode eq '200 OK'>
			<cfset deliveryConfirmationXML = xmlparse(httpResponse.Filecontent)>

			<cffile action="write" file="#expandPath('.')#\#deliveryConfirmationXML["delivery-confirmation-certificate"]["filename"]["XmlText"]#" output="#ToBinary(deliveryConfirmationXML["delivery-confirmation-certificate"]["image"]["XmlText"])#">

			<cfset local.resultOfStructure = {"filename":#deliveryConfirmationXML["delivery-confirmation-certificate"]["filename"]["XmlText"]#}>
		</cfif>
		<cfreturn local.resultOfStructure>
	</cffunction>

</cfcomponent>