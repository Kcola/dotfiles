function parse_har
    argparse 'm/match=' -- $argv

    if set -q _flag_match
        set match $_flag_match
    else
        echo "Error: --match is required"
        return 1
    end

    if count $argv >0
        set filePath $argv[-1]
    else
        echo "Error: filePath is required"
        return 1
    end

    echo '"$match"'

    jq '[.log.entries.[] | select(.request.url | contains("'$match'")) | select(.response.content.text != null) | select(.request.postData.text != null) | {correlationId: .response.headers.[] | select(.name == "x-ms-correlation-id") | .value, requestBody: .request.postData.text, response: .response.content.text | fromjson}]' $filePath
end
