# Put the current revision's attributes in a onerow datasource named "content".
# The detected content type is "content_revision".

content::get_content content_revision

if { ![string equal -length 4 "text" $content(mime_type)] } {
    # It's a file.
    cr_write_content -revision_id $content(revision_id)
    ad_script_abort
}

# Ordinary text/* mime type.
template::util::array_to_vars content

set text [cr_write_content -string -revision_id $revision_id]

set text [ad_html_text_convert -from $mime_type -to text/html $text]

set context [list $title]

set admin_p [permission::permission_p -object_id [ad_conn package_id] -party_id [ad_conn user_id] -privilege "admin"]
set manage_url "[ad_conn package_url]manage/[ad_conn path_info]"


ad_return_template

