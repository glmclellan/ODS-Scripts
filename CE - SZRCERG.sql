select FTVLOCN.FTVLOCN_TITLE "Location",
       SSBSECT.SSBSECT_CRN "CRN",
       SSBSECT.SSBSECT_TERM_CODE "Term_Code",
       SSBSECT.SSBSECT_SUBJ_CODE "Subj_code",
       SSBSECT.SSBSECT_CRSE_NUMB "Crse_Nmub",
       nvl(SSBSECT.SSBSECT_CRSE_TITLE,SCBCRSE.SCBCRSE_TITLE) "Crse_Title",
       SSBSECT.SSBSECT_INSM_CODE "INSM_code",
       SPRIDEN.SPRIDEN_ID "ID",
       SPRIDEN.SPRIDEN_FIRST_NAME "First_name",
       SPRIDEN.SPRIDEN_LAST_NAME "Last_Name",
       STVRSTS.STVRSTS_DESC "RSTS_Desc",
       SFRAREG.SFRAREG_ACTIVITY_DATE "Activity_Date",
       SFRAREG.SFRAREG_RSTS_DATE "RSTS_Date",
       siast_odsmgr.gzpkods.f_get_email_address(spriden_pidm, 'IA') "IA_Email",
       siast_odsmgr.gzpkods.f_get_email_address(spriden_pidm, 'EX') "EX_Email",
       siast_odsmgr.gzpkods.f_get_tel_number(spriden_pidm, 'PR') "PR_Phone",
       siast_odsmgr.gzpkods.f_get_tel_number(spriden_pidm, 'CR') "CR_Phone",
       siast_odsmgr.gzpkods.f_get_tel_number(spriden_pidm, 'MB') "MB_Phone"
  from SATURN.SFRAREG SFRAREG,
       SATURN.SSBSECT SSBSECT,
       SATURN.SPRIDEN SPRIDEN,
       SATURN.SCBCRSE SCBCRSE,
       SATURN.STVRSTS STVRSTS,
       FIMSMGR.FTVLOCN FTVLOCN
 where ( SFRAREG.SFRAREG_TERM_CODE = SSBSECT.SSBSECT_TERM_CODE
         and SFRAREG.SFRAREG_CRN = SSBSECT.SSBSECT_CRN
         and SFRAREG.SFRAREG_PIDM = SPRIDEN.SPRIDEN_PIDM
         and SFRAREG.SFRAREG_RSTS_CODE = STVRSTS.STVRSTS_CODE
         and SCBCRSE.SCBCRSE_SUBJ_CODE = SSBSECT.SSBSECT_SUBJ_CODE
         and SCBCRSE.SCBCRSE_CRSE_NUMB = SSBSECT.SSBSECT_CRSE_NUMB
         and SSBSECT.SSBSECT_CAMP_CODE = FTVLOCN.FTVLOCN_LOCN_CODE )
   and ( nvl(SCBCRSE.SCBCRSE_DIVS_CODE, 'TTTTTT') not in ('LAE')
         and SPRIDEN.SPRIDEN_CHANGE_IND is null
         and SSBSECT.SSBSECT_MAX_ENRL >0
         and FTVLOCN.FTVLOCN_EFF_DATE <= sysdate
         and FTVLOCN.FTVLOCN_NCHG_DATE > sysdate
         and FTVLOCN.FTVLOCN_COAS_CODE = 1
         and SCBCRSE.SCBCRSE_EFF_TERM = (select max ( scbcrse_eff_term )
                     from saturn.scbcrse
                    where scbcrse_subj_code = ssbsect_subj_code
                      and scbcrse_crse_numb = ssbsect_crse_numb
                      and scbcrse_eff_term <= ssbsect_term_code)
         and SSBSECT.SSBSECT_INSM_CODE in ('CE', 'MC', 'DUAL', 'CEUGC', 'CEPRO', 'CERSK', 'CEECE', 'CEGM', 'CENA') )
         and SFRAREG.SFRAREG_RSTS_DATE <= sysdate
 order by FTVLOCN.FTVLOCN_TITLE,
          SFRAREG.SFRAREG_CRN,
          SFRAREG.SFRAREG_TERM_CODE,
          SCBCRSE.SCBCRSE_SUBJ_CODE,
          SCBCRSE.SCBCRSE_CRSE_NUMB,
          SSBSECT.SSBSECT_INSM_CODE,
          SPRIDEN.SPRIDEN_LAST_NAME,
          SPRIDEN.SPRIDEN_FIRST_NAME
