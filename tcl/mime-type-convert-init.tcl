
set mime_convert_procs [list]

lappend mime_convert_procs "application/msword_to_text/html" "mime_type_convert::doc_to_html"

foreach {types c} $mime_convert_procs {

    nsv_set mime_convert_procs $types $c 

}

