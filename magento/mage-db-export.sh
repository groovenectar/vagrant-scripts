#!/usr/bin/env bash

# Leave blank to prompt for any values
save_path=""
dbhost=""
dbuser=""
# You will be prompted for the password twice
dbname=""
dbprefix=""

overwrite=true
tiny=true # Ignore tables such as logs (recommended)
dump_data=true
dump_schema=true

echo
echo "+=========================+"
echo "| MAGENTO DATABASE EXPORT |"
echo "+=========================+"
echo

if [[ -z ${save_path} ]]; then
    # http://stackoverflow.com/a/9720193/425767
    read -p "Filename (blank for \"magento.sql\"): " save_path
    if [[ -z ${save_path} ]]; then
        save_path="magento.sql"
    fi
fi

if [[ -z ${dbhost} ]]; then
    read -p "Database Host (blank for \"localhost\"): " dbhost
    if [[ -z ${dbhost} ]]; then
        dbhost="localhost"
    fi
fi

if [[ -z ${dbuser} ]]; then
    read -p "Database User (blank for \"root\"): " dbuser
    if [[ -z ${dbuser} ]]; then
        dbuser="root"
    fi
fi

if [[ -z ${dbname} ]]; then
    read -p "Database Name (blank for \"magento\"): " dbname
    if [[ -z ${dbname} ]]; then
        dbname="magento"
    fi
fi

if [[ -z ${dbprefix} ]]; then
    read -p "Table Prefix (blank for none): " dbprefix
    if [[ -z ${dbprefix} ]]; then
        dbprefix=""
    fi
fi

if [[ "${overwrite}" = true ]]; then
    append=" (WILL be overwritten if exists)"
else
    append=" (Will NOT be overwritten if exists)"
fi

echo
echo "Using the following database information:"
echo
echo "* Filename: ${save_path}${append}"
echo "* Database Host: ${dbhost}"
echo "* Database User: ${dbuser}"
echo "* Database Name: ${dbname}"
echo "* Table Prefix: ${dbprefix}"
echo
echo "You may be prompted for the database password twice"
echo

# http://unix.stackexchange.com/a/293941/114856
read -n 1 -s -p "Press any key to continue..."
echo
echo

# http://inchoo.net/magento/magento-tip-get-a-small-sized-version-of-a-large-production-database/
ignore_tables=""
if [[ "${tiny}" = true ]]; then
    ignore_tables_array=(
        adminnotification_inbox
        aw_core_logger
        captcha_log
        dataflow_batch_export
        dataflow_batch_import
        log_customer
        log_quote
        log_summary
        log_summary_type
        log_url
        log_url_info
        log_visitor
        log_visitor_info
        log_visitor_online
        index_event
        report_event
        report_viewed_product_index
        report_compared_product_index
        catalog_compare_item
        catalogindex_aggregation
        catalogindex_aggregation_tag
        catalogindex_aggregation_to_tag
        cron_schedule
        smtppro_email_log
        sendfriend_log
        amx_audittrail_records
        core_session
        api_session
        dataflow_session
        persistent_session
    )

    for table in "${ignore_tables_array[@]}"
    do
        ignore_tables+="--ignore-table=${dbname}.${dbprefix}${table} "
    done
fi

if [[ "${overwrite}" = false && -f ${save_path} ]]; then
    echo "File exists. Aborting."
    echo
    exit
fi

> "${save_path}"

if [[ "${dump_schema}" = true ]]; then
    echo
    echo "Dumping structure"
    echo "-----------------"
    mysqldump --user="${dbuser}" -p --no-data "${dbname}" >> "${save_path}"
fi

echo

if [[ "${dump_data}" = true ]]; then
    echo
    echo "Dumping data"
    echo "------------"
    mysqldump ${ignore_tables}--user="${dbuser}" -p --no-create-info "${dbname}" >> "${save_path}"
fi

echo
echo
echo "Done."
echo
