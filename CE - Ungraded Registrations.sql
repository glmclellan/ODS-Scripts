-- A0031A - UNGRADED REGISTRATIONS
-------------------------

  SELECT DISTINCT IA.INSTRUCTOR_ID,
                  IA.INSTRUCTOR_NAME,
                  IA.PRIMARY_IND,
                  SC.PERSON_UID,
                  SC.ID,
                  SC.ACADEMIC_YEAR,
                  SC.ACADEMIC_PERIOD,
                  SC.COURSE_IDENTIFICATION,
                  SC.COURSE_REFERENCE_NUMBER,
                  SC.START_DATE,
                  SC.END_DATE,
                  SC.REGISTRATION_STATUS,
                  SC.COLLEGE,
                  SC.COURSE_TITLE_SHORT,
                  SC.INSTRUCTION_METHOD_DESC,
                  SC.FINAL_GRADE_DATE,
                  SC.FINAL_GRADE_ROLL_IND,
                  SC.GRADE_TYPE_DESC,
                  SC.CAMPUS_DESC,
                  SC.START_DATE_SIAST,
                  SC.END_DATE_SIAST,
                  PD.LAST_NAME,
                  PD.FIRST_NAME
    FROM ODSMGR.INSTRUCTIONAL_ASSIGNMENT IA,
         SIAST_ODSMGR.STUDENT_COURSE_SIAST SC,
         SIAST_ODSMGR.PERSON_DETAIL_SIAST PD
   WHERE     (    (    SC.COURSE_REFERENCE_NUMBER = IA.COURSE_REFERENCE_NUMBER(+)
                   AND SC.ACADEMIC_PERIOD = IA.ACADEMIC_PERIOD(+))
              AND (PD.PERSON_UID = SC.PERSON_UID))
         AND (SC.END_DATE_SIAST < CURRENT_DATE)
         AND (SC.INSTRUCTION_METHOD <> 'MC')
         AND (SC.COLLEGE IN ('CE', '00'))
         AND (substr(SC.ACADEMIC_PERIOD,5,2) in ('11', '12'))
         AND (SC.REGISTRATION_STATUS IN ('OC', 'RE'))
         AND (    SC.ACADEMIC_PERIOD >= :Main_EB_Acad_PeriodStart
              AND SC.ACADEMIC_PERIOD <= :Main_EB_Acad_PeriodEnd)
         --$addfilter
--$beginorder
ORDER BY SC.COURSE_IDENTIFICATION ASC,
         SC.COURSE_TITLE_SHORT ASC,
         SC.CAMPUS_DESC ASC,
         SC.COLLEGE ASC,
         SC.ACADEMIC_PERIOD ASC,
         SC.COURSE_REFERENCE_NUMBER ASC,
         SC.INSTRUCTION_METHOD_DESC ASC,
         SC.ID ASC,
         PD.FIRST_NAME ASC,
         PD.LAST_NAME ASC,
         SC.REGISTRATION_STATUS ASC,
         SC.PERSON_UID ASC
--$endorder
