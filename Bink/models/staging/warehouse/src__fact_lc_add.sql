WITH source AS (
    SELECT * 
    FROM {{ source('BINK_SECURE', 'FACT_LOYALTY_CARD_ADD') }}
)

,renamed AS (
    SELECT
        EVENT_ID
        ,EVENT_DATE_TIME
        ,AUTH_TYPE
        ,EVENT_TYPE
        ,LOYALTY_CARD_ID
        ,LOYALTY_PLAN
        ,LOYALTY_PLAN_NAME
        ,IS_MOST_RECENT
        ,CHANNEL
        ,ORIGIN
        ,BRAND
        ,USER_ID
        ,EXTERNAL_USER_REF
        ,EMAIL_DOMAIN
        ,INSERTED_DATE_TIME
        ,UPDATED_DATE_TIME
    FROM source
    WHERE USER_ID IN (SELECT USER_ID FROM {{ref('src__fact_user')}}) -- required for creating consistent data sources
)

SELECT *
FROM renamed