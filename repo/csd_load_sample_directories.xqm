(:~
: This is the Care Services Discovery stored query registry
: @version 1.0
: @see https://github.com/openhie/openinfoman
:
:)
module namespace csd_lsd = "https://github.com/openhie/openinfoman/csd_lsd";

import module namespace csd_dm = "https://github.com/openhie/openinfoman/csd_dm" ;


declare variable $csd_lsd:base_path := concat(file:current-dir() ,"../resources/service_directories/");

declare function csd_lsd:fn_base_name($file,$ext) {
  let $old_base_name := fn:function-lookup(xs:QName("file:base-name"), 2)
  return
    if (not(exists($old_base_name))) then
      fn:replace(fn:function-lookup(xs:QName("file:name"), 1)($file), fn:concat($ext, "$"), "")
    else
      $old_base_name($file,$ext)
};

declare function csd_lsd:sample_directories() {
  let $files := file:list($csd_lsd:base_path,true(),'*.xml')
  for $file in $files
    return csd_lsd:fn_base_name($file,".xml")
};

declare function csd_lsd:get_document_names() {
  csd_dm:document_source(csd_lsd:sample_directories())
};

declare function csd_lsd:get_document_source($name) {
  concat($csd_lsd:base_path, "/" , $name,".xml")
};



declare function csd_lsd:valid_doc($name) {
  $name = csd_lsd:sample_directories()
};


declare updating function csd_lsd:load($name) {
  let $source := csd_lsd:get_document_source($name)
  let $doc := parse-xml(file:read-text($source))
  return csd_dm:empty($name,$doc)

};



