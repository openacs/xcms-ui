ad_library {

    @author Dave Bauer dave@thedesignexperience.org
    @creation-date 2004-01-31
    @cvs-id $Id

}


namespace eval mime_type_convert:: {}


ad_proc -public mime_type_convert::convert_file {
    filename
    from_type
    to_type
} {
    @param filename full path to file to be converted
    @param to_type type to convert to
} {

    #get procedure to convert with

    set proc_name [nsv_get mime_convert_procs ${from_type}_to_${to_type}]

    $proc_name $filename
    
}

ad_proc -public mime_type_convert::doc_to_html {
    filename
} {
    @param filename full path to file to be converted
} {

    # let's just start with inputting a Word file and outputting some xhtml

    set tmpdir [lindex [parameter::get -package_id [ad_conn subsite_id] -parameter TmpDir -default "/tmp"] 0]

    # create a temporary file to hold the converted data
    ns_log notice "DAVEB mime_type_convert ${filename} exists [file exists ${filename}]"
    
    set new_filename [file tail [ns_mktemp "${tmpdir}/fileXXXXXX"]]

    # convert to HTML
    exec /usr/bin/wvHtml --targetdir=${tmpdir} ${filename} ${new_filename}
    # clean up word HTML
    set err [catch {exec sh -c "(tidy -c -i -q ${tmpdir}/${new_filename} 2> /dev/null ;/bin/true)" } msg]

    #exec /usr/bin/tidy -e -m ${tmpdir}/${new_filename}
    # tidy is returning some info to STDERR and making this fail
    # if I catch it, the file is empty, not sure where the output is going!
    
#    return ${tmpdir}/${new_filename}
     return $msg
    
}

