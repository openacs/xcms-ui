ad_page_contract {
    list the revision of a item
} {
}

set package_url [ad_conn package_url]
set url_base "${package_url}manage/"
set current_url [ad_conn url]
set return_url [ad_conn url]
template::list::create \
    -name revision_list \
    -multirow revision_list \
    -key revision_id \
    -elements {
        creation_date {label "Date"}
        last_name {
            label "Author"
            display_template {@revision_list.first_names@ @revision_list.last_name@}
        }
        live_revision_id {
            label "Status"
            display_template {<if @revision_list.live_revision_id@ eq @revision_list.revision_id@>published</if>}
        }
        revision_id {
	    display_template {<a class="button" href="${return_url}?revision_id=@revision_list.revision_id@">View</a> <if @revision_list.live_revision_id@ ne @revision_list.revision_id@><a class="button" href="${url_base}item-publish?item_id=@revision_list.item_id@&revision_id=@revision_list.revision_id@&return_url=${return_url}">Publish Revision</a></if>}
        }
        
    }

bcms::revision::list_revisions -item_id $item_id -multirow_name revision_list
