select it_coversheet_reference_id,it_docmetadata_document_id, count(account_number) account_count from it_associated_account a,it_document_metadata m,it_cover_sheet s where a.it_docmetadata_document_id = m.document_id and m.it_coversheet_reference_id = s.reference_id group by (it_coversheet_reference_id,it_docmetadata_document_id) order by account_count desc;

select * from it_associated_account where account_short_name like '%&%';
account_number = 25642440;
select * from it_associated_account where account_number = '25642440';
select account_short_name from it_associated_account where account_number = '25642440';
select account_short_name, xmlelement(e,XMLCdata(account_short_name)) from it_associated_account where account_number = '25642440';
--select account_short_name, cast(xmlelement(e,account_short_name) as varchar2) from it_associated_account where account_number = '25642440';




select account_short_name, extractvalue(xmlelement(e,XMLCdata(account_short_name)),'//text()'),xmlelement(e,XMLCdata(account_short_name)).extract('//text()') from it_associated_account where account_number = '25642440';
select account_short_name, extractvalue(xmlelement(e,XMLCdata(account_short_name)),'//text()'),xmlelement(e,account_short_name),xmlelement(e,account_short_name).extract('E') from it_associated_account where account_number = '25642440';

--correct one;
select rtrim(replace(replace(xmlagg(xmlelement(e,XMLCdata(account_short_name||'|')).extract('//text()')).getclobval(),'<![CDATA[',''),']]>',''),'|') from it_associated_account where account_number = '25642440';

select * from it_coversheet_linked_data_view where COVERSHEET_REFERENCE_ID = 65;

select xmlagg(xmlelement(e,XMLCdata(account_short_name) || '|')).extract('//text()').getclobval() from it_associated_account where account_number = '25642440';



select xmlagg(extractvalue(xmlelement(e,XMLCdata(account_short_name)),'//text()')).getclobval() from it_associated_account where account_number = '25642440';
select rtrim(xmlagg(xmlelement(e,XMLCdata(account_short_name) || '|')).extract('//text()').getclobval(),'|') from it_associated_account where account_number = '25642440';









SHOW PARAMETER max_string_size;


  --backup sql for the view
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "TRUSTDB"."IT_COVERSHEET_LINKED_DATA_VIEW" ("COVERSHEET_REFERENCE_ID", "ACCOUNT_NUMBER", "ACCOUNT_SHORT_NAME", "ACCOUNT_ADMIN_CODE", "LPID", "DOCTYPE_CODE", "REFERENCE_NUMBER", "DOCUMENT_DATE", "COMMENTS", "CREATED_BY") AS 
  SELECT REFERENCE_ID AS COVERSHEET_REFERENCE_ID,
          (SELECT LISTAGG (ACCOUNT_NUMBER, '|')
                     WITHIN GROUP (ORDER BY ACCOUNT_NUMBER)
             FROM TRUSTDB.IT_ASSOCIATED_ACCOUNT
            WHERE IT_DOCMETADATA_DOCUMENT_ID = DOCUMENT_ID)
             AS ACCOUNT_NUMBER,
          (SELECT LISTAGG (ACCOUNT_SHORT_NAME, '|')
                     WITHIN GROUP (ORDER BY ACCOUNT_NUMBER)
             FROM TRUSTDB.IT_ASSOCIATED_ACCOUNT
            WHERE IT_DOCMETADATA_DOCUMENT_ID = DOCUMENT_ID)
             AS ACCOUNT_SHORT_NAME,
          (SELECT LISTAGG (ADMIN_CODE, '|')
                     WITHIN GROUP (ORDER BY ACCOUNT_NUMBER)
             FROM TRUSTDB.IT_ASSOCIATED_ACCOUNT
            WHERE IT_DOCMETADATA_DOCUMENT_ID = DOCUMENT_ID)
             AS ACCOUNT_ADMIN_CODE,
          (SELECT LISTAGG (LPID, '|') WITHIN GROUP (ORDER BY LPID)
             FROM (SELECT DISTINCT LPID
                     FROM TRUSTDB.IT_ASSOCIATED_INTERESTED_PARTY
                    WHERE IT_DOCMETADATA_DOCUMENT_ID = DOCUMENT_ID))
             AS LPID,
          (SELECT LISTAGG (NAME, '|') WITHIN GROUP (ORDER BY CODE)
             FROM TRUSTDB.IT_ASSOCIATED_DOCTYPE
            WHERE IT_DOCMETADATA_DOCUMENT_ID = DOCUMENT_ID)
             AS DOCTYPE_CODE,
          REFERENCE_NUMBER,
          TRUNC (DOCUMENT_DATE) AS DOCUMENT_DATE,
          COMMENTS,
          CREATED_BY
     FROM TRUSTDB.IT_COVER_SHEET, TRUSTDB.IT_DOCUMENT_METADATA
    WHERE REFERENCE_ID = IT_COVERSHEET_REFERENCE_ID;
--

--New Sql for the view

  SELECT REFERENCE_ID AS COVERSHEET_REFERENCE_ID,
       (SELECT rtrim(replace(replace(xmlagg(xmlelement(e,XMLCdata(ACCOUNT_NUMBER || '|'))).extract('//text()').getclobval(),'<![CDATA[',''),']]>',''),'|')
          FROM TRUSTDB.IT_ASSOCIATED_ACCOUNT
         WHERE IT_DOCMETADATA_DOCUMENT_ID = DOCUMENT_ID)
          AS ACCOUNT_NUMBER,
       (SELECT rtrim(replace(replace(xmlagg(xmlelement(e,XMLCdata(ACCOUNT_SHORT_NAME || '|'))).extract('//text()').getclobval(),'<![CDATA[',''),']]>',''),'|')
          FROM TRUSTDB.IT_ASSOCIATED_ACCOUNT
         WHERE IT_DOCMETADATA_DOCUMENT_ID = DOCUMENT_ID)
          AS ACCOUNT_SHORT_NAME,
       (SELECT rtrim(replace(replace(xmlagg(xmlelement(e,XMLCdata(ADMIN_CODE || '|'))).extract('//text()').getclobval(),'<![CDATA[',''),']]>',''),'|')
          FROM TRUSTDB.IT_ASSOCIATED_ACCOUNT
         WHERE IT_DOCMETADATA_DOCUMENT_ID = DOCUMENT_ID)
          AS ACCOUNT_ADMIN_CODE,
       (SELECT rtrim(replace(replace(xmlagg(xmlelement(e,XMLCdata(LPID || '|'))).extract('//text()').getclobval(),'<![CDATA[',''),']]>',''),'|')
          FROM 
          (SELECT DISTINCT LPID 
           FROM TRUSTDB.IT_ASSOCIATED_INTERESTED_PARTY
           WHERE IT_DOCMETADATA_DOCUMENT_ID = DOCUMENT_ID )
          ) AS LPID, 
       (SELECT rtrim(replace(replace(xmlagg(xmlelement(e,XMLCdata(NAME || '|'))).extract('//text()').getclobval(),'<![CDATA[',''),']]>',''),'|')
          FROM TRUSTDB.IT_ASSOCIATED_DOCTYPE
         WHERE IT_DOCMETADATA_DOCUMENT_ID = DOCUMENT_ID)
          AS DOCTYPE_CODE,
       REFERENCE_NUMBER,
       TRUNC (DOCUMENT_DATE) AS DOCUMENT_DATE,
       COMMENTS,
       CREATED_BY
  FROM TRUSTDB.IT_COVER_SHEET, TRUSTDB.IT_DOCUMENT_METADATA
  WHERE REFERENCE_ID = IT_COVERSHEET_REFERENCE_ID
  A;

-----



