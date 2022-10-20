*** Settings ***
Library  RequestsLibrary
Library  JSONLibrary


*** Variables ***
${base_url}                             http://localhost:8080
${get_taxRelief_endpoint}               ${base_url}/calculator/taxRelief
${get_taxReliefSummary_endpoint}        ${base_url}/calculator/taxReliefSummary
${insert_single_record_endpoint}        ${base_url}/calculator/insert
${insert_multiple_records_endpoint}     ${base_url}/calculator/insertMultiple
${insert_random_integer_endpoint}       ${base_url}/calculator/insertRandomToDatabaseForNoReason
${rake_database_endpoint}               ${base_url}/calculator/rakeDatabase
${upload_csv_file_endpoint}             ${base_url}/calculator/uploadLargeFileForInsertionToDatabase


*** Test Cases ***
Get_taxRelief
    ${response}=        GET                     ${get_taxRelief_endpoint}
    log to console      ${response.status_code}
    log to console      ${response.json()}
    ${status_code}=     convert to string       ${response.status_code}
    status should be    200


Get_tax_releif_summary
    ${response}=                    GET                     ${get_taxReliefSummary_endpoint}
    log to console                  ${response.json()}
    status should be                200
    ${total_number}=                get value from json     ${response.json()}    totalWorkingClassHeroes
    ${total_tax_amount}=            get value from json     ${response.json()}    totalTaxReliefAmount
#    should be equal                 ${total_number}[0]      0
#    should be equal                 ${total_tax_amount}[0]  4


Insert Single Record
    ${headers}=     create dictionary       Content-Type=application/json
    ${body}=        create dictionary       birthday=01101990   gender=m    name=Kiwi   natid=100001    salary=10000    tax=1000
    ${response}=    POST    ${INSERT_SINGLE_RECORD_ENDPOINT}    json=${body}     headers=${headers}
    status should be  202
    log to console                  ${response.content}
    ${resp_content}=    convert to string   ${response.content}
    should be equal  ${resp_content}    Alright

Insert Multiple Records
    ${headers}=     create dictionary       Content-Type=application/json
    ${working_class1}    create dictionary  birthday=01021991   gender=m    name=Nick   natid=9999    salary=45000    tax=7000
    ${working_class2}    create dictionary  birthday=01021992   gender=f    name=Mary   natid=10000    salary=56000    tax=9000
    ${body}=        create list     ${working_class1}       ${working_class2}
    ${response}=    POST      ${insert_multiple_records_endpoint}       json=${body}    headers=${headers}
    status should be  202
    log to console                  ${response.content}
    ${resp_content}=    convert to string   ${response.content}
    should be equal  ${resp_content}    Alright


Rake Database
    ${response}=      POST        ${rake_database_endpoint}
    ${response_str}  convert to string     ${response.content}
    should be equal  ${response_str}    Successfully raked DB


Insert Random Integer
    ${response}=        POST                    ${insert_random_integer_endpoint}   params=count=1
    status should be    200
    ${response_str}     convert to string       ${response.content}
    should contain      ${response_str}         Successfully inserted


Upload CSV File
    ${file}=  Get File For Streaming Upload      /Users/rongyao.ma/PycharmProjects/WorkingClass/testcase/workingClassHeroes.csv
    ${body}=        create dictionary       file=${file}
    ${response}=    POST                ${upload_csv_file_endpoint}     files=${body}
    log to console  ${response.content}
    status should be            200


