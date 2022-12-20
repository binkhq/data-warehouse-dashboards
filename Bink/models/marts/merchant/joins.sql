/*
Created at: 20/12/2022
Created by: Anand Bhakta
Description: Query to satisfy merchant reporting on joins
Modified at:
Modified by:
*/

WITH joins AS (
    SELECT
        *
    FROM {{ref('src__fact_lc_add')}}
)

,users AS (
    SELECT 
        *
    FROM {{ref('src__dim_user')}}
)

,extract_joins AS (
    SELECT
        DATE_TRUNC('month', j.EVENT_DATE_TIME) AS DATE
        ,j.LOYALTY_PLAN
        ,j.LOYALTY_CARD_ID
        ,j.AUTH_TYPE
        ,CONTAINS(u.EMAIL, 'e2e.bink.com') AS TESTER
    FROM
        joins j
    LEFT JOIN
        users u ON u.USER_ID = j.USER_ID
    WHERE
        AUTH_TYPE IN ('JOIN', 'REGISTER')
        AND 
        EVENT_TYPE = 'SUCCESS'
    
)

,metrics AS (
    SELECT
        DATE
        ,LOYALTY_PLAN
        ,COUNT(DISTINCT LOYALTY_CARD_ID) AS J001 --do we want to be counting a unique id?
        ,NULL AS J002 --need pll and opt-in for the rest
        ,NULL AS J003
        ,NULL AS J004
        ,NULL AS J005
        ,NULL AS J006
        ,NULL AS J007
    FROM 
        extract_joins
    WHERE
        TESTER = FALSE
    GROUP BY
        DATE
        ,LOYALTY_PLAN
)

SELECT
    *
FROM
    metrics