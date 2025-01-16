SELECT parent, lead_add_id, front, final_second, final_third, final_fourth, final_fifth,
      IF(SUBSTRING_INDEX(LTRIM(true_a_6),' ',1) REGEXP '[0-9]', SUBSTRING_INDEX(LTRIM(true_a_6),' ',1)   , SUBSTRING_INDEX(LTRIM(true_a_6),' ',2)) as final_sixth,
      SUBSTRING(LTRIM(true_a_6),LENGTH(IF(SUBSTRING_INDEX(LTRIM(true_a_6),' ',1) REGEXP '[0-9]', SUBSTRING_INDEX(LTRIM(true_a_6),' ',1), SUBSTRING_INDEX(LTRIM(true_a_6),' ',2)))+2) as final_7,
      user_agent
FROM(
    SELECT parent, lead_add_id, front, final_second, final_third, final_fourth, user_agent,
            if(LTRIM(true_a_5) LIKE 'Brave%',SUBSTRING_INDEX(LTRIM(true_a_5),' ',2),SUBSTRING_INDEX(LTRIM(true_a_5),' ',1)) as final_fifth,
            SUBSTRING(LTRIM(true_a_5),LENGTH(if(LTRIM(true_a_5) LIKE 'Brave%',SUBSTRING_INDEX(LTRIM(true_a_5),' ',2),SUBSTRING_INDEX(LTRIM(true_a_5),' ',1)) ) + 2) as true_a_6
    FROM(
        SELECT parent, lead_add_id, lead_id, front, final_second, final_third, true_a_4, user_agent,
                if(LOCATE('KHTML',true_a_4) > 0, REPLACE(SUBSTRING_INDEX(true_a_4, ') ',1),'(',''), if(LOCATE('Gecko',true_a_4) > 0, SUBSTRING_INDEX(true_a_4,' ',2),'')) as final_fourth,
                if(LOCATE('KHTML',true_a_4) > 0, SUBSTRING(true_a_4,LOCATE(') ',true_a_4) + 1), if(LOCATE('Gecko',true_a_4) > 0, SUBSTRING_INDEX(true_a_4,' ',-1),true_a_4)) as true_a_5
        FROM(
            SELECT parent, lead_add_id, lead_id, front,  user_agent,
                    if(LEFT(true_second,1) = '(',SUBSTRING(true_second,2),true_second) as final_second, true_a_3,
                    if(LOCATE('AppleWebKit',true_a_3) > 0, SUBSTRING_INDEX(true_a_3,' (',1),'') as final_third,
                    if(LOCATE('AppleWebKit',true_a_3) > 0, SUBSTRING(true_a_3,LOCATE(' (',true_a_3)), true_a_3) as true_a_4
            FROM(
                SELECT *, if(LOCATE('AppleWebKit',u_a_2) > 0, SUBSTRING_INDEX(u_a_2,') AppleWebKit',1) , SUBSTRING_INDEX(u_a_2, ') ',1)) as true_second, 
                        REPLACE(SUBSTRING_INDEX(u_a_2, ') ',1),'(','') as mini_second,
                        if(LOCATE('AppleWebKit',u_a_2) > 0, SUBSTRING(u_a_2, LOCATE('AppleWebKit',u_a_2)), SUBSTRING(u_a_2,LOCATE(') ', u_a_2) + 1)) as true_a_3,
                        SUBSTRING(u_a_2,LOCATE(') ', u_a_2) + 1) as u_a_3
                FROM(
                    SELECT parent, lead_add_id, lead_id, user_agent,
                            SUBSTRING_INDEX(user_agent,' ',1) as front,
                            SUBSTRING(user_agent, LOCATE(' ',user_agent)+1) as u_a_2
                    FROM lms.leads_add_data
					where CAST(user_agent AS BINARY) LIKE 'Mozilla/5.0 (%'
					and created_date < '2024-09-19'
                ) t
            ) t
        ) t
    ) t
) t