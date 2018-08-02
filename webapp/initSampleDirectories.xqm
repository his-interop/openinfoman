module namespace page = 'http://basex.org/modules/web-page';

import module namespace csd_lsd = "https://github.com/openhie/openinfoman/csd_lsd";
import module namespace csd_dm = "https://github.com/openhie/openinfoman/csd_dm";
import module namespace csd_webui =  "https://github.com/openhie/openinfoman/csd_webui";
import module namespace csr_proc = "https://github.com/openhie/openinfoman/csr_proc";
import module namespace csd_psd = "https://github.com/openhie/openinfoman/csd_psd";
declare   namespace   csd = "urn:ihe:iti:csd:2013";



declare
  %rest:path("/CSD/initSampleDirectory/directory/{$name}")
  %rest:GET
  %output:method("xhtml")
  function page:get_service_menu($name)
{
  let $response := page:services_menu($name) 
  return csd_webui:nocache(csd_webui:wrapper($response))
};

declare
  %rest:path("/CSD/initSampleDirectory/directory/{$name}/get")
  %rest:GET
  function page:get_directory($name)
{
  csd_dm:open_document($name) 
};

declare
  %rest:path("/CSD/directory/{$name}/get")
  %rest:GET
  function page:get_directory2($name)
{
  csd_dm:open_document($name) 
};


declare
  %rest:path("/CSD/directory/{$name}/get/{$entity}/{$entityID}")
  %rest:GET
  function page:get_entity($name,$entity,$entityID)
{
  let $doc := csd_dm:open_document($name)
  let $entities:=
    switch($entity)
    case "provider" return $doc/csd:CSD/csd:providerDirectory/csd:provider
    case "facility" return $doc/csd:CSD/csd:facilityDirectory/csd:facility
    case "organization" return $doc/csd:CSD/csd:organizationDirectory/csd:organization
    case "service" return $doc/csd:CSD/csd:serviceDirectory/csd:service
    default return ()

  return  $entities[@entityID = $entityID] 

};





declare updating   
  %rest:path("/CSD/initSampleDirectory/directory/{$name}/load")
  %rest:GET
  function page:load($name)
{ 
(
  csd_lsd:load($name)   ,
  csd_webui:redirect_out("CSD/initSampleDirectory")
)
};



declare updating   
  %rest:path("/CSD/initSampleDirectory/directory/{$name}/reload")
  %rest:GET
  function page:reload($name)
{ 
(
  csd_dm:empty($name)   ,
  csd_webui:redirect_out(("CSD/initSampleDirectory/directory/",$name,"/load"))
)


};




declare
  %rest:path("/CSD/initSampleDirectory")
  %rest:GET
  %output:method("xhtml")
  function page:directory_list()
{ 
let $response :=
      <div class='row'>
 	<div class="col-md-8">
	  <h2>Sample Directories</h2>
	  <ul>
	    {for $name in csd_lsd:sample_directories()
	    order by $name
	    return 
	    <li>
	      <a href="{csd_webui:generateURL(('CSD/initSampleDirectory/directory',$name))}">{$name}</a>
	      <br/>
	      {page:services_menu($name)}
	    </li>
	    }
	  </ul>
	</div>
      </div>

return csd_webui:nocache(  csd_webui:wrapper($response))


};




declare 
  %rest:path("/CSD/documents.json")
  %rest:GET
  function page:export_function_details_json(){    
  (<rest:response>
    <output:serialization-parameters>
      <output:media-type value='application/json'/>
    </output:serialization-parameters>
  </rest:response>,
  xml-to-json( page:get_export_document_details())
    )
};

declare
  %rest:path("/CSD/documents.xml")
  %rest:GET
  function page:export_document_details_xml(){
    
    page:get_export_document_details()
};

declare function page:get_export_document_details() {
  <map xmlns="http://www.w3.org/2005/xpath-functions">
    {
      let $remote_docs :=  csd_psd:registered_directories()
      return 
        for $name in csd_dm:registered_documents()
	return 
	<map key="{string($name)}">
	  <string key="careServicesRequest">{csd_webui:generateURL(('CSD/csr/',$name,'/careServicesRequest'))}</string>
	  <map key="careServicesRequests">
	    {
	      for $function in (csr_proc:stored_functions(),csr_proc:stored_updating_functions())
	      let $urn:= string($function/@urn)
	      return <string key="{$urn}">{csd_webui:generateURL(('CSD/csr/',$name,'/careServicesRequest/',$urn))}</string>
	    }
	  </map>
	  {
	    if ($name = $remote_docs) 
	    then
	      <map key="cache">
	        <string key="update">{csd_webui:generateURL(("/CSD/pollService/directory" ,$name , "update_cache"))}</string>
	        <string key="empty">{csd_webui:generateURL(("/CSD/pollService/directory" ,$name , "empty_cache"))}</string>
	      </map>
	    else ()	  
	  }
	</map>
    }
  </map>
};



declare function page:services_menu($name) {
  <ul> 
    {if (not(csd_dm:document_source_exists($name))) then
    <li><a href="{csd_webui:generateURL(('CSD/initSampleDirectory/directory',$name,'load'))}">Initialize </a> {$name} </li>
  else 
    (
    <li><a href="{csd_webui:generateURL(('CSD/initSampleDirectory/directory',$name,'get'))}">Get </a> {$name}</li>,
    <li><a href="{csd_webui:generateURL(('CSD/initSampleDirectory/directory',$name,'reload'))}">Reload </a>{$name}</li>
  )
    }
  </ul>
};



