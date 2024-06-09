*** Settings ***
Library     SeleniumLibrary
Library     RequestsLibrary
Library     OperatingSystem

*** Variables ***
${header}           //div[contains(@class,'menu-product-header')]
${price}            //div[contains(@class,'menu-product-price')]
${image}            //div[@class='menu-product-image']/img
${url}              https://online.kfc.co.in/menu
${download_path}    ./images

*** Test Cases ***
Restaurant_menu
    # Ensure the download directory exists
    Create Directory    ${download_path}

    Open Browser    ${url}  chrome
    Maximize Browser Window
    Sleep    10
    ${total_length}    Get Element Count    ${header}
    Log To Console    ${total_length}

    FOR    ${i}    IN RANGE    1    ${total_length}+1
        Log To Console    ${i}
        ${header_text}    Get Text    (//div[@class='menu-card-content']/div[contains(@class,'menu-product-header')])[${i}]
        Log To Console    ${header_text}
        ${price_text}    Get Text    (${price})[${i}]
        Log To Console    ${price_text}

        # Get the image source URL
        ${image_element}    Get WebElement    (//img[contains(@src,'https://orderserv-kfc-assets.yum.com/')])[${i}]
        ${image_url}       Get Element Attribute    ${image_element}    src
        Log To Console     ${image_url}

        # Sanitize the header text to create a valid filename
        ${sanitized_header}    Evaluate    ''.join(e if e.isalnum() or e == '_' else '_' for e in '''${header_text}''')
        Log To Console    ${sanitized_header}
        ${image_file}          Set Variable    ${download_path}/${sanitized_header}.jpg

        # Download and save the image
        Download Image         ${image_url}    ${image_file}

    END
    Close Browser

*** Keywords ***
Download Image
    [Arguments]    ${url}    ${file_path}
    ${response}    Get Request    ${url}
    Create Binary File    ${file_path}    ${response.content}
