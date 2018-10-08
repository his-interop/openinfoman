module namespace page = 'http://basex.org/modules/web-page';
import module namespace csd_bl = "https://github.com/openhie/openinfoman/csd_bl";
import module namespace functx = 'http://www.functx.com';
import module namespace csr_proc = "https://github.com/openhie/openinfoman/csr_proc";
import module namespace csd_webui =  "https://github.com/openhie/openinfoman/csd_webui";
import module namespace csd_dm = "https://github.com/openhie/openinfoman/csd_dm";
import module namespace svs_lsvs = "https://github.com/openhie/openinfoman/svs_lsvs";
declare namespace csd =  "urn:ihe:iti:csd:2013";
declare namespace svs = "urn:ihe:iti:svs:2008";
declare default element  namespace   "urn:ihe:iti:csd:2013";


declare function page:get_location ($doc_name,$_id,$page,$_count,$_since)
{
  <CSD xmlns:csd="urn:ihe:iti:csd:2013">
    {
      let $search_collection := 
      <collection>
        <search directory="facilityDirectory">urn:ihe:iti:csd:2014:stored-function:facility-search</search>
        <search directory="organizationDirectory">urn:ihe:iti:csd:2014:stored-function:organization-search</search>
      </collection>
      for $search in $search_collection/search
      let $search_name := $search/text()
      return
      (
        let $careServicesSubRequest :=  
        <csd:careServicesRequest>
          <csd:function urn="{$search_name}" resource="{$doc_name}" base_url="{csd_webui:generateURL('')}">
            <csd:requestParams>
              {
                let $id := $_id
                return if (functx:all-whitespace($id)) then () else <csd:id entityID="{$id}"/>
              }

              {
                let $t_start := $page
                return if (functx:is-a-number($t_start))
                  then
                    let $start := max((xs:int($t_start),1))
                    let $t_count := $_count
                    let $count := if(functx:is-a-number($t_count)) then  max((xs:int($t_count),1)) else 50
                    let $startIndex := ($start - 1)*$count + 1
                    return <csd:start>{$startIndex}</csd:start>
                  else () 
              }
         {
           let $count := $_count
           return 
              if(functx:is-a-number($count)) 
              then  <csd:max>{max((xs:int($count),1))} </csd:max>
              else ()
         }
         {
          let $since := $_since
          return if (functx:all-whitespace($since)) then () else <csd:record updated="{$since}"/> 
         }
            </csd:requestParams>
          </csd:function>
        </csd:careServicesRequest>

        let $doc :=  csd_dm:open_document($doc_name)
        let $contents := csr_proc:process_CSR_stored_results( $doc , $careServicesSubRequest)
        let $directory := $search/@directory/string()
        return $contents/*[name() = $directory]
      )
    }
  </CSD>
};

declare function page:get_provider ($doc_name,$_id,$page,$_count,$_since,$organization,$location)
{
  let $search_name := "urn:ihe:iti:csd:2014:stored-function:provider-search"
  return
  <CSD xmlns:csd="urn:ihe:iti:csd:2013">
    {
      let $careServicesSubRequest :=  
      <csd:careServicesRequest>
        <csd:function urn="{$search_name}" resource="{$doc_name}" base_url="{csd_webui:generateURL('')}">
          <csd:requestParams>
            {
              let $id := $_id
              return if (functx:all-whitespace($id)) then () else <csd:id entityID="{$id}"/>
            }

            {
              let $t_start := $page
              return if (functx:is-a-number($t_start))
                then
                  let $start := max((xs:int($t_start),1))
                  let $t_count := $_count
                  let $count := if(functx:is-a-number($t_count)) then  max((xs:int($t_count),1)) else 50
                  let $startIndex := ($start - 1)*$count + 1
                  return <csd:start>{$startIndex}</csd:start>
                else () 
            }
            {
              let $org := $organization
              return if (functx:all-whitespace($org)) then () else  <csd:organizations><csd:organization>{$org}</csd:organization></csd:organizations>
            }
            {
              let $loc := $location
              return if (functx:all-whitespace($loc)) then () else <csd:facilities><csd:facility>{$loc}</csd:facility></csd:facilities> 
            }
       {
         let $count := $_count
         return 
            if(functx:is-a-number($count)) 
            then  <csd:max>{max((xs:int($count),1))} </csd:max>
            else ()
       }
       {
        let $since := $_since
        return if (functx:all-whitespace($since)) then () else <csd:record updated="{$since}"/> 
       }
          </csd:requestParams>
        </csd:function>
      </csd:careServicesRequest>

      let $doc :=  csd_dm:open_document($doc_name)
      let $contents := csr_proc:process_CSR_stored_results( $doc , $careServicesSubRequest)
      return $contents/providerDirectory
    }
  </CSD>
};

declare function page:get_services ($doc_name,$_id,$page,$_count,$_since)
{
  let $search_name := "urn:ihe:iti:csd:2014:stored-function:service-search"
  return
  <CSD xmlns:csd="urn:ihe:iti:csd:2013">
    {
      let $careServicesSubRequest :=  
      <csd:careServicesRequest>
        <csd:function urn="{$search_name}" resource="{$doc_name}" base_url="{csd_webui:generateURL('')}">
          <csd:requestParams>
            {
              let $id := $_id
              return if (functx:all-whitespace($id)) then () else <csd:id entityID="{$id}"/>
            }

            {
              let $t_start := $page
              return if (functx:is-a-number($t_start))
                then
                  let $start := max((xs:int($t_start),1))
                  let $t_count := $_count
                  let $count := if(functx:is-a-number($t_count)) then  max((xs:int($t_count),1)) else 50
                  let $startIndex := ($start - 1)*$count + 1
                  return <csd:start>{$startIndex}</csd:start>
                else () 
            }
            {
              let $count := $_count
              return 
                  if(functx:is-a-number($count)) 
                  then  <csd:max>{max((xs:int($count),1))} </csd:max>
                  else ()
            }
            {
              let $since := $_since
              return if (functx:all-whitespace($since)) then () else <csd:record updated="{$since}"/> 
            }
          </csd:requestParams>
        </csd:function>
      </csd:careServicesRequest>

      let $doc :=  csd_dm:open_document($doc_name)
      let $contents := csr_proc:process_CSR_stored_results( $doc , $careServicesSubRequest)
      return $contents/serviceDirectory
    }
  </CSD>
};

declare
  %rest:path("/fhir")
  %rest:GET
  function page:FHIR()
{
  let $output := 
                <json type='object'>
                  <issue type="array">
                    <_ type="object">
                      <code>exception</code>
                      <details type="object">
                        <text>Internal server error</text>
                      </details>
                      <severity>fatal</severity>
                    </_>
                  </issue>
                  <resourceType>OperationOutcome</resourceType>
                </json>
    return (
              <rest:response>
                <output:serialization-parameters>
                  <output:media-type value='application/json'/>
                </output:serialization-parameters>
              </rest:response>,
              json:serialize($output,map{"format":"direct",'escape': 'no'})
            )
};

declare
  %rest:path("/{$doc_name}/fhir/Location/{$id}")
  %rest:query-param("page", "{$page}")
  %rest:query-param("_count", "{$_count}")
  %rest:query-param("_since", "{$_since}")
  %rest:GET
  function page:FHIRLocationID($id,$page,$_count,$_since,$doc_name)
{
  page:FHIRLocation($id,$page,$_count,$_since,$doc_name)
};

declare
  %rest:path("/{$doc_name}/fhir/Location/_history")
  %rest:query-param("_id", "{$_id}")
  %rest:query-param("page", "{$page}")
  %rest:query-param("_count", "{$_count}")
  %rest:query-param("_since", "{$_since}")
  %rest:GET
  function page:FHIRLocation($_id,$page,$_count,$_since,$doc_name)
{
let $contents := page:get_location ($doc_name,$_id,$page,$_count,$_since)
 
let $location :=
<json type='object'>
<resourceType>Bundle</resourceType>
<total>{count($contents/facilityDirectory/facility) + count($contents/organizationDirectory/organization)}</total>
<type>history</type>
<entry type="array">
{
for $content in ($contents/facilityDirectory/facility,$contents/organizationDirectory/organization)
return
<_ type="object">
  <fullURL>{csd_webui:generateURL("fhir/" || $doc_name || "/Location/" || $content/@entityID)}</fullURL>
  {
    if($content/record/@created/string() != $content/record/@updated/string())
    then
    <request type="object">
      <method>PUT</method>
      <url>{$doc_name}/Location/{$content/@entityID/string()}</url>
    </request>
    else()
  }
  <resource type="object">
    <resourceType>Location</resourceType>
    <id>{$content/@entityID/string()}</id>
    {
     if(exists($content/otherID))
     then
     <identifier type="array">
      {
      for $otherid in $content/otherID
      return
      <_ type="object">
        <system>{$otherid/@assigningAuthorityName/string()}</system>
        <value>{$otherid/text()}</value>
      </_>
      }
      <_ type="object">
        <system>urn:ihe:iti:csd:2013:entityID</system>
        <value>{$content/@entityID/string()}</value>
      </_>
     </identifier>
     else ()
    }
    {
      let $search_name := "urn:ihe:iti:csd:2014:stored-function:organization-search"
      let $parent :=
      if(exists($content/organizations/organization))
      then
      $content/organizations/organization/@entityID/string()
      else 
      if (exists($content/parent))
      then $content/parent/@entityID/string()
      else ()

      return if($parent)
      then
      let $careServicesSubRequest :=
      <csd:careServicesRequest>
        <csd:function urn="{$search_name}" resource="{$doc_name}" base_url="{csd_webui:generateURL()}">
          <csd:requestParams>
            <csd:id entityID="{$parent}"/>
          </csd:requestParams>
        </csd:function>
      </csd:careServicesRequest>
      let $doc :=  csd_dm:open_document($doc_name)
      let $organization := csr_proc:process_CSR_stored_results( $doc , $careServicesSubRequest)
      return if(exists($organization/organizationDirectory/organization))
      then
      <partOf type="object">
        <reference>{csd_webui:generateURL("fhir/" || $doc_name || "/Location/" || $organization/organizationDirectory/organization/@entityID/string())}</reference>
        <display>{$organization/organizationDirectory/organization/primaryName/text()}</display>
      </partOf>
      else ()
      else ()
    }
    {
      let $entityType := $content/name()
      return  <physicalType type="object">
                <coding type="array">
                  <_ type="object">
                    <system>http://hl7.org/fhir/location-physical-type</system>
                    {
                      if($entityType = "csd:facility" or $entityType = "facility") then
                      ( <code>bu</code>,
                        <display>Building</display>
                      )
                      else if($entityType = "csd:organization" or $entityType = "organization") then
                      (
                        <code>jdn</code>,
                        <display>Jurisdiction</display>
                      )
                      else 
                      (
                      )
                    }
                  </_>
                </coding>
              </physicalType>
    }
    {
    if(exists($content/contactPoint))
    then
    <telecom type="array">
     {
     for $contactPoint in $content/contactPoint
     return ()
     }
    </telecom>
    else ()
    }
    {
      if(exists($content/geocode))
      then 
      <position type="object">
        <longitude>{$content/geocode/longitude/text()}</longitude>
        <latitude>{$content/geocode/latitude/text()}</latitude>
      </position>
      else ()
    }
    {
      if(exists($content/codedType))
      then
        <type type="object">
          <coding type="array">
            {
              for $codedType in $content/codedType
                return
                <_ type="object">
                  <code>{$codedType/@code/string()}</code>
                  <system>{$codedType/@codingScheme/string()}</system>
                  {
                  if(functx:all-whitespace($codedType/text()))
                  then ()
                  else
                  <display>{$codedType/text()}</display>
                  }
                </_>
            }
          </coding>
        </type>
      else ()
    }
    <meta type="object">
      <lastUpdated>{$content/record/@updated/string()}</lastUpdated>
      <tag type="array">
        <_ type="object">
          <code>{$content/record/@sourceDirectory/string()}</code>
          <system>https://github.com/openhie/openinfoman/tags/fhir/sourceDirectory</system>
        </_>
      </tag>
    </meta>
    <status>{$content/record/@status/string()}</status>
    <name>{$content/primaryName/text()}</name>
    <mode>instance</mode>
  </resource>
</_>
}
</entry>
</json>

return (
  <rest:response>
    <output:serialization-parameters>
      <output:media-type value='application/json'/>
    </output:serialization-parameters>
  </rest:response>,
  json:serialize($location,map{"format":"direct",'escape': 'no'})
  )

};

declare
  %rest:path("/{$doc_name}/fhir/Practitioner/{$id}")
  %rest:query-param("page", "{$page}")
  %rest:query-param("_count", "{$_count}")
  %rest:query-param("_since", "{$_since}")
  %rest:query-param("organization", "{$organization}")
  %rest:query-param("location", "{$location}")
  %rest:GET
  function page:FHIRPractitionerID($id,$page,$_count,$_since,$doc_name,$organization,$location)
{
  page:FHIRPractitioner($id,$page,$_count,$_since,$doc_name,$organization,$location)
};

declare
  %rest:path("/{$doc_name}/fhir/Practitioner/_history")
  %rest:query-param("_id", "{$_id}")
  %rest:query-param("page", "{$page}")
  %rest:query-param("_count", "{$_count}")
  %rest:query-param("_since", "{$_since}")
  %rest:query-param("organization", "{$organization}")
  %rest:query-param("location", "{$location}")
  %rest:GET
  function page:FHIRPractitioner($_id,$page,$_count,$_since,$doc_name,$organization,$location)
{
let $contents := page:get_provider ($doc_name,$_id,$page,$_count,$_since,$organization,$location)
let $practitioner :=
<json type='object'>
<resourceType>Bundle</resourceType>
<total>{count($contents/providerDirectory/provider)}</total>
<type>history</type>
<entry type="array">
{
  for $content in $contents/providerDirectory/provider
  return
  <_ type="object">
    <fullURL>{csd_webui:generateURL("fhir/" || $doc_name || "/Practitioner/" || $content/@entityID)}</fullURL>
    {
      if($content/record/@created/string() != $content/record/@updated/string())
      then
      <request type="object">
        <method>PUT</method>
        <url>{$doc_name}/Practitioner/{$content/@entityID/string()}</url>
      </request>
      else()
    }
    <resource type="object">
      <resourceType>Practitioner</resourceType>
      <id>{$content/@entityID/string()}</id>
      {
        if(exists($content/otherID))
        then
        <identifier type="array">
        {
          for $otherid in $content/otherID
          return
          <_ type="object">
            <system>{$otherid/@assigningAuthorityName/string()}</system>
            <value>{$otherid/text()}</value>
          </_>
        }
          <_ type="object">
            <system>urn:ihe:iti:csd:2013:entityID</system>
            <value>{$content/@entityID/string()}</value>
          </_>
        </identifier>
        else ()
      }
      <active>
        {
          let $status := lower-case($content/record/@status/string())
          return if($status = "active") then "true"
                  else if($status = "inactive" or $status = "in-active") then "false"
                  else()
        }
      </active>
      {
        if(exists($content/demographic/contactPoint/codedType))
        then
        <telecom type="array">
          {
            for $contactPoint in $content/demographic/contactPoint
            return if (exists($contactPoint/codedType))
                    then
                    <_ type="object">
                      <system>
                      {
                        let $code := $contactPoint/codedType/@code/string()
                        return if($code = "BP") then "phone"
                               else if ($code = "EMAIL") then "email"
                               else if ($code = "FAX") then "fax"
                               else "other"
                      }
                      </system>
                      <value>{$contactPoint/codedType/text()}</value>
                    </_>
                   else ()
          }
        </telecom>
        else ()
      }
      {
        if(exists($content/demographic/address/addressLine))
        then
        <address type="array">
          {
            for $address in $content/demographic/address
            return
              if(exists($address/addressLine))
              then
              <_ type="object">
                {
                  let $csdtype := lower-case($address/@type/string())
                  let $fhirtype := if($csdtype = "mailing" or $csdtype = "mailing address") then "postal"
                                    else if ($csdtype = "physical" or $csdtype = "physical address") then "physical"
                                    else ()
                  return if($fhirtype) 
                          then <type>{$fhirtype}</type>
                          else ()
                }
                {
                  for $addressLine in $address/addressLine
                  return if($addressLine/@component = "streetAddress")
                          then <line>{$addressLine/text()}</line>
                          else if($addressLine/@component = "city")
                          then <city>{$addressLine/text()}</city>
                          else if($addressLine/@component = "stateProvince")
                          then <state>{$addressLine/text()}</state>
                          else if($addressLine/@component = "country")
                          then <country>{$addressLine/text()}</country>
                          else if($addressLine/@component = "postalCode")
                          then <postalCode>{$addressLine/text()}</postalCode>
                          else()
                }
              </_>
              else ()
          }
        </address>
        else ()
      }
      {
        if(exists($content/credential)) then
        <qualification type="array">
        {
          for $credential in $content/credential
          return
          <_ type="object">
            <identifier type="array">
            {
              for $number in $credential/number
              return  <_ type="object">
                        <value>{$credential/number/text()}</value>
                      </_>
            }
            </identifier>
            <code type="object">
              <coding type="array">
              {
                for $codedType in $credential/codedType
                return
                <_ type="object">
                  {
                    if($codedType/@codingScheme/string()) then
                    <system>{$codedType/@codingScheme/string()}</system>
                    else ()
                  }
                  {
                    if($codedType/@code/string()) then
                    <code>{$codedType/@code/string()}</code>
                    else ()
                  }
                  <display>{$codedType/text()}</display>
                </_>
              }
              </coding>
            </code>
            {
              if($credential/issuingAuthority/text()) then
              <issuer type="object">
                <display>{$credential/issuingAuthority/text()}</display>
              </issuer>
              else ()
            }
            {
              if(exists($credential/credentialIssueDate) or exists($credential/credentialRenewalDate)) then
              <period type="object">
              {
                if($credential/credentialIssueDate/text()) then
                <start>{$credential/credentialIssueDate/text()}</start>
                else ()
              }
              {
                if($credential/credentialRenewalDate/text()) then
                <end>{$credential/credentialRenewalDate/text()}</end>
                else ()
              }
              </period>
              else ()
            }
          </_>
        }
        </qualification>
        else ()
      }
      {
        if(exists($content/language)) then
        <communication type="array">
        {
          for $language in $content/language
          return
          <_ type="object">
            <coding type="array">
              {
                <_ type="object">
                  {
                    if($language/@codingScheme/string()) then
                    <system>{$language/@codingScheme/string()}</system>
                    else ()
                  }
                  {
                    if($language/@code/string()) then
                    <code>{$language/@code/string()}</code>
                    else ()
                  }
                    <display>{$language/text()}</display>
                </_>
              }
            </coding>
            {
              if($language/text()) then
              <text>{($language/text())}</text>
              else ()
            }
          </_>
        }
        </communication>
        else ()
      }
      <name type="array">
      {
        for $name in $content/demographic/name
        return
        <_ type="object">
          <text>{($name/commonName/text())[1]}</text>
          <family>{($name/surname/text())[1]}</family>
          <given>{($name/forename/text())[1] || ' ' || ($name/otherName/text())[1]}</given>
          <prefix>{($name/honorific/text())[1]}</prefix>
          <suffix>{($name/suffix/text())[1]}</suffix>
        </_>
      }
      </name>
      {
        if(exists($content/demographic/gender))
        then
        <gender>
          {
            let $gender := $content/demographic/gender/text()
            return if($gender = "F") then "female"
                    else if($gender = "M") then "male"
                    else lower-case($gender)
          }
        </gender>
        else ()
      }
      {
        if(exists($content/demographic/dateOfBirth))
        then
        <birthDate>{$content/demographic/dateOfBirth/text()}</birthDate>
        else ()
      }
      <meta type="object">
        <lastUpdated>{$content/record/@updated/string()}</lastUpdated>
        <tag type="array">
          <_ type="object">
            <code>{$content/record/@sourceDirectory/string()}</code>
            <system>https://github.com/openhie/openinfoman/tags/fhir/sourceDirectory</system>
          </_>
        </tag>
      </meta>
    </resource>
  </_>
}
</entry>
</json>
return (
          <rest:response>
            <output:serialization-parameters>
              <output:media-type value='application/json'/>
            </output:serialization-parameters>
          </rest:response>,
          json:serialize($practitioner,map{"format":"direct",'escape': 'no'})
        )
};

declare
  %rest:path("/{$doc_name}/fhir/PractitionerRole/{$id}")
  %rest:query-param("page", "{$page}")
  %rest:query-param("_count", "{$_count}")
  %rest:query-param("_since", "{$_since}")
  %rest:query-param("organization", "{$organization}")
  %rest:query-param("location", "{$location}")
  %rest:GET
  function page:FHIRPractitionerRoleID($id,$page,$_count,$_since,$doc_name,$organization,$location)
{
  page:FHIRPractitionerRole($id,$page,$_count,$_since,$doc_name,$organization,$location)
};

declare
  %rest:path("/{$doc_name}/fhir/PractitionerRole/_history")
  %rest:query-param("_id", "{$_id}")
  %rest:query-param("page", "{$page}")
  %rest:query-param("_count", "{$_count}")
  %rest:query-param("_since", "{$_since}")
  %rest:query-param("organization", "{$organization}")
  %rest:query-param("location", "{$location}")
  %rest:GET
  function page:FHIRPractitionerRole($_id,$page,$_count,$_since,$doc_name,$organization,$location)
{
let $contents := page:get_provider ($doc_name,$_id,$page,$_count,$_since,$organization,$location)
let $practitionerRole :=
<json type='object'>
<resourceType>Bundle</resourceType>
<total>{count($contents/providerDirectory/provider)}</total>
<type>history</type>
<entry type="array">
{
  for $content in $contents/providerDirectory/provider
  return
  <_ type="object">
    <fullURL>{csd_webui:generateURL("fhir/" || $doc_name || "/PractitionerRole/" || $content/@entityID)}</fullURL>
    {
      if($content/record/@created/string() != $content/record/@updated/string())
      then
      <request type="object">
        <method>PUT</method>
        <url>{$doc_name}/PractitionerRole/{$content/@entityID/string()}</url>
      </request>
      else()
    }
    <resource type="object">
      <resourceType>PractitionerRole</resourceType>
      <id>{$content/@entityID/string()}</id>
      {
        if(exists($content/otherID))
        then
        <identifier type="array">
        {
          for $otherid in $content/otherID
          return
          <_ type="object">
            <system>{$otherid/@assigningAuthorityName/string()}</system>
            <value>{$otherid/text()}</value>
          </_>
        }
        <_ type="object">
          <system>urn:ihe:iti:csd:2013:entityID</system>
          <value>{$content/@entityID/string()}</value>
        </_>
        </identifier>
        else ()
      }
      <practitioner type="object">
        <reference>Practitioner/{$content/@entityID/string()}</reference>
        <display>{$content/demographic/name[1]/commonName[1]/string()}</display>
      </practitioner>
      <location type="array">
        {
        for $facility at $index in $content/facilities/facility
        return
        <_ type="object">
          <reference>{csd_webui:generateURL("fhir/" || $doc_name || "/Location/" || $facility/@entityID/string())}</reference>
          {
            let $search_name := "urn:ihe:iti:csd:2014:stored-function:facility-search"
            let $careServicesSubRequest :=
            <csd:careServicesRequest>
              <csd:function urn="{$search_name}" resource="{$doc_name}" base_url="{csd_webui:generateURL()}">
                <csd:requestParams>
                  <csd:id entityID="{$facility/@entityID/string()}"/>
                </csd:requestParams>
              </csd:function>
            </csd:careServicesRequest>
            let $doc :=  csd_dm:open_document($doc_name)
            let $fac := csr_proc:process_CSR_stored_results( $doc , $careServicesSubRequest)
            return <display>{$fac//primaryName/text()}</display>
          }
        </_>
        }
        {
          for $organization at $index in $content/organizations/organization
          return
          <_ type="object">
          <reference>{csd_webui:generateURL("fhir/" || $doc_name || "/Location/" || $organization/@entityID/string())}</reference>
          {
            let $search_name := "urn:ihe:iti:csd:2014:stored-function:organization-search"
            let $careServicesSubRequest :=
            <csd:careServicesRequest>
              <csd:function urn="{$search_name}" resource="{$doc_name}" base_url="{csd_webui:generateURL()}">
                <csd:requestParams>
                  <csd:id entityID="{$organization/@entityID/string()}"/>
                </csd:requestParams>
              </csd:function>
            </csd:careServicesRequest>
            let $doc :=  csd_dm:open_document($doc_name)
            let $org := csr_proc:process_CSR_stored_results( $doc , $careServicesSubRequest)
            return <display>{$org//primaryName/text()}</display>
          }
          </_>
        }
      </location>
      <healthcareService type="array">
        {
        for $facility at $index in $content/facilities/facility
        for $service in $facility/service
        return
        <_ type="object">
          <reference>{csd_webui:generateURL("fhir/" || $doc_name || "/HealthcareService/" || $service/@entityID/string())}</reference>
          {
            let $search_name := "urn:ihe:iti:csd:2014:stored-function:service-search"
            let $careServicesSubRequest :=
            <csd:careServicesRequest>
              <csd:function urn="{$search_name}" resource="{$doc_name}" base_url="{csd_webui:generateURL()}">
                <csd:requestParams>
                  <csd:id entityID="{$service/@entityID/string()}"/>
                </csd:requestParams>
              </csd:function>
            </csd:careServicesRequest>
            let $doc :=  csd_dm:open_document($doc_name)
            let $serv := csr_proc:process_CSR_stored_results( $doc , $careServicesSubRequest)
            let $codedType := $serv//codedType
            let $svsCode := svs_lsvs:get_single_version_code($codedType/@code/string(),$codedType/@codingScheme/string(),"")
            return <display>{$svsCode//svs:Concept/@displayName/string()}</display>
          }
        </_>
        }
      </healthcareService>
      <specialty type="array">
        {
        for $specialty at $index in $content/specialty
        return
        <_ type="object">
          <code type="object">
            <coding type="array">
            {
              for $codedType in $specialty/codedType
              return
              <_ type="object">
                {
                  if($codedType/@codingScheme/string()) then
                  <system>{$codedType/@codingScheme/string()}</system>
                  else ()
                }
                {
                  if($codedType/@code/string()) then
                  <code>{$codedType/@code/string()}</code>
                  else ()
                }
                {
                  let $svsCode := svs_lsvs:get_single_version_code($codedType/@code/string(),$codedType/@codingScheme/string(),"")
                  return <display>{$svsCode//svs:Concept/@displayName/string()}</display>
                }
              </_>
            }
            </coding>
            {
              if($specialty/codedType/text()) then
              <text>{($specialty/codedType/text())[1]}</text>
              else ()
            }
          </code>
        </_>
        }
      </specialty>
      <availableTime type="array">
        {
          for $service in $content/facilities/facility/service
          return <_ type="object">
            {
              for $operatingHours in $service/operatingHours
              let $CSDdayOfTheWeek := $operatingHours/dayOfTheWeek/text()
              let $FHIRdayOfTheWeek := page:getDayOfTheWeek($CSDdayOfTheWeek)
              return (
                      <daysOfWeek>{$FHIRdayOfTheWeek}</daysOfWeek>,
                      <availableStartTime>{$operatingHours/beginningHour/text()}</availableStartTime>,
                      <availableEndTime>{$operatingHours/endingHour/text()}</availableEndTime>
                      )
            }
            </_>
        }
        {
          for $operatingHours in $content/facilities/facility/operatingHours
          return
          <_ type="object">
          {
            let $CSDdayOfTheWeek := $operatingHours/dayOfTheWeek/text()
              let $FHIRdayOfTheWeek := page:getDayOfTheWeek($CSDdayOfTheWeek)
              return (
                      <daysOfWeek>{$FHIRdayOfTheWeek}</daysOfWeek>,
                      <availableStartTime>{$operatingHours/beginningHour/text()}</availableStartTime>,
                      <availableEndTime>{$operatingHours/endingHour/text()}</availableEndTime>
                      )
          }
          </_>
        }
      </availableTime>
      {
        if(exists($content/organizations/organization/contactPoint/codedType))
        then
        <telecom type="array">
          {
            for $contactPoint in $content/organizations/organization/contactPoint
            return if (exists($contactPoint/codedType))
                    then
                    <_ type="object">
                      <system>
                      {
                        let $code := $contactPoint/codedType/@code/string()
                        return if($code = "BP") then "phone"
                               else if ($code = "EMAIL") then "email"
                               else if ($code = "FAX") then "fax"
                               else "other"
                      }
                      </system>
                      <value>{$contactPoint/codedType/text()}</value>
                    </_>
                   else ()
          }
        </telecom>
        else ()
      }
      <active>
        {
          let $status := lower-case($content/record/@status/string())
          return if($status = "active") then "true"
                  else if($status = "inactive" or $status = "in-active") then "false"
                  else()
        }
      </active>
      <meta type="object">
        <lastUpdated>{$content/record/@updated/string()}</lastUpdated>
        <tag type="array">
          <_ type="object">
            <code>{$content/record/@sourceDirectory/string()}</code>
            <system>https://github.com/openhie/openinfoman/tags/fhir/sourceDirectory</system>
          </_>
        </tag>
      </meta>
    </resource>
  </_>
}
</entry>
</json>
return (
          <rest:response>
            <output:serialization-parameters>
              <output:media-type value='application/json'/>
            </output:serialization-parameters>
          </rest:response>,
          json:serialize($practitionerRole,map{"format":"direct",'escape': 'no'})
        )
};

declare
  %rest:path("/{$doc_name}/fhir/HealthcareService/{$id}")
  %rest:query-param("page", "{$page}")
  %rest:query-param("_count", "{$_count}")
  %rest:query-param("_since", "{$_since}")
  %rest:GET
  function page:FHIRHealthcareServiceID($id,$page,$_count,$_since,$doc_name)
{
  page:FHIRHealthcareService($id,$page,$_count,$_since,$doc_name)
};

declare
  %rest:path("/{$doc_name}/fhir/HealthcareService/_history")
  %rest:query-param("_id", "{$_id}")
  %rest:query-param("page", "{$page}")
  %rest:query-param("_count", "{$_count}")
  %rest:query-param("_since", "{$_since}")
  %rest:GET
  function page:FHIRHealthcareService($_id,$page,$_count,$_since,$doc_name)
{
let $contents := page:get_services ($doc_name,$_id,$page,$_count,$_since)
let $HealthcareService :=
<json type='object'>
  <resourceType>Bundle</resourceType>
  <total>{count($contents/serviceDirectory/service)}</total>
  <type>history</type>
  <entry type="array">
  {
    for $content in $contents/serviceDirectory/service
    return
    <_ type="object">
      <fullURL>{csd_webui:generateURL("fhir/" || $doc_name || "/HealthcareService/" || $content/@entityID)}</fullURL>
      {
        if($content/record/@created/string() != $content/record/@updated/string())
        then
        <request type="object">
          <method>PUT</method>
          <url>{$doc_name}/HealthcareService/{$content/@entityID/string()}</url>
        </request>
        else()
      }
      <resource type="object">
        <resourceType>HealthcareService</resourceType>
        <id>{$content/@entityID/string()}</id>
        {
          let $codedType := $content/codedType
          let $svsCode := svs_lsvs:get_single_version_code($codedType/@code/string(),$codedType/@codingScheme/string(),"")
          return <name>{$svsCode//svs:Concept/@displayName/string()}</name>
        }
        {
          <identifier type="array">
          {
            for $otherid in $content/otherID
            return
            <_ type="object">
              <system>{$otherid/@assigningAuthorityName/string()}</system>
              <value>{$otherid/text()}</value>
            </_>
          }
            <_ type="object">
              <system>urn:ihe:iti:csd:2013:entityID</system>
              <value>{$content/@entityID/string()}</value>
            </_>
          </identifier>
        }
        <active>
          {
            let $status := lower-case($content/record/@status/string())
            return if($status = "active") then "true"
                    else if($status = "inactive" or $status = "in-active") then "false"
                    else()
          }
        </active>
      </resource>
    </_>
  }
  </entry>
</json>

return (
          <rest:response>
            <output:serialization-parameters>
              <output:media-type value='application/json'/>
            </output:serialization-parameters>
          </rest:response>,
          json:serialize($HealthcareService,map{"format":"direct",'escape': 'no'})
        )
};

declare function page:getDayOfTheWeek ($day) {
  if($day = 1) then "mon"
                else if ($day = 2) then "tue"
                else if ($day = 3) then "wed"
                else if ($day = 4) then "thu"
                else if ($day = 5) then "fri"
                else if ($day = 6) then "sat"
                else if ($day = 7) then "sun"
                else ()
};