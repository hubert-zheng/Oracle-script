
---day 1
select * from SYS_CODE_VALUES_V t where code_name = '利率种类';

select * from sys_codes;

SELECT v.code_value AS value_code, v.code_value_name AS value_name
  FROM sys_code_values_v v
 WHERE v.code = 'CHANCE_MODIFY_LOAN_INTETEST_RATE_TYPE'
   AND v.code_enabled_flag = 'Y'
   AND v.code_value_enabled_flag = 'Y'
   
   
   select t1.lease_channel as value_code, t1.description as value_name from hls_lease_channel t1 where t1.enabled_flag = 'Y'
   
   delete sys_


---day 2 ~ 5
select * from hls_bp_master;
hls_bp_master_lv;

select * from prj_chance_lv;

select * from prj_chance;

PRJ_CHANCE_PKG.PRJ_CHANCE_APPROVE;

HLS_BP_MASTER;

select * from hls_bp_master_contact_info;
hls_bp_master_contact_info_lv;

hls_workflow_pkg;

hls_document_type;

sys_condition_matching;

create table org_unit_link(
       unit_code number,
       unit_name varchar2(30),
       lead_unit varchar2(30)
)
select * from org_unit_link;
select * from exp_org_unit;   --parent_unit_id
select * from fnd_companies;
select * from Exp_Org_Position;
select * from exp_employees;
select * from fnd_descriptions;

insert into org_unit_link values (select t1.unit_code,t2. from exp_org_unit t1,fnd_descriptions t2 where t1.description_id = t2.description_id(+));
select t1.unit_code,t2.description_text from exp_org_unit t1,fnd_descriptions t2 where t1.description_id = t2.description_id(+);
SELECT * FROM Temporary;


create table Temporary (
       employee_id number,
       employee_name varchar2(30),
       email varchar2(50),
       movephone number,
       phone number
)

SELECT* FROM TABLE(XYG_PUB_DATA_UPLOAD_PKG.CONVER_EXCEL_TO_TAB(XYG_ALD_FILE_PKG.CONVERT_FILE_BLOB('XYG_BATFILE','D:/inputdate.xlsx'),'',1));
      
       v_employee_code number;
       v_name varchar2(30);
       v_email varchar2(50);
       v_mobil number;
       v_phone number;
;

----数据由临时表导入到exp_employees表
select * from EXP_EMPLOYEES;
declare
       v_id number;
       v_exp_employees exp_employees%rowtype;
       cursor loopend is select * from Temporary;
begin
       v_id := 2;
       
       for v_dtls in loopend loop
       v_exp_employees.employee_id     := v_id;
       v_exp_employees.employee_code   := v_id;
       v_exp_employees.name            := v_dtls.employee_name;
       v_exp_employees.email           := v_dtls.email;
       v_exp_employees.mobil           := v_dtls.movephone;
       v_exp_employees.phone           := v_dtls.phone;
       v_exp_employees.enabled_flag    := 'Y';
       v_exp_employees.created_by       := 922;
       v_exp_employees.creation_date     := sysdate;
       v_exp_employees.last_updated_by := 1;
       v_exp_employees.last_update_date:= sysdate;
       
       INSERT INTO exp_employees values v_exp_employees;
       
       v_id := v_id + 1;
       
       end loop;
end;
select * from exp_employees;
select * from Exp_Org_Position;  -- position_id  --unit_id 
SELECT * FROM EXP_ORG_UNIT;   ---部门表  --desc
select * from fnd_descriptions t where t.description_id = 13544
select * from FND_DESCRIPTIONS t where t.description_text='一级岗位';
select t.position_id,t1.* from EXP_ORG_POSITION t,FND_DESCRIPTIONS t1 where t.description_id = t1.description_id and t1.description_text = '董事长' and t1.language = 'ZHS';
select * from Exp_Employee_Jobs;
select * from EXP_EMPLOYEE_ASSIGNS;   -- employee_id  -- position_id  exp_employee_assigns

 

insert into EXP_EMPLOYEES(EXP_EMPLOYEES_S.NEXTVAL,EMPLOYEE_CODE,NAME,Email,MOBIL,PHONE) select t.employee_id,t.employee_name,t.email,t.movephone,t.phone from Temporary t;


create table Temporary1 AS SELECT * FROM Temporary WHERE 1=2;
SELECT * FROM Temporary1;

SELECT t2.email,T1.DESCRIPTION_TEXT,T2.EMPLOYEE_NAME,t1.creation_date FROM FND_DESCRIPTIONS T1,Temporary1 T2 WHERE T2.ONE_POSITION = '董事长' and t1.description_text= t2.one_position;

----员工岗位录入
declare
       v_id number;
       position_id number;
       v_employee_code varchar2(20);
       v_employee_assigns_id number;
       v_exp_employees exp_employees%rowtype;
       v_exp_employee_assigns exp_employee_assigns%rowtype;
       cursor loopend is select * from Temporary;
begin
       v_id := exp_employees_s.nextval;
       v_employee_assigns_id    := exp_employee_assigns_s.nextval;
       for v_dtls in loopend loop
       v_exp_employees.employee_id     := v_id;
        if v_id < 10 then 
       v_employee_code                 := '000'||v_id;
       v_exp_employees.employee_code   := v_employee_code;
       end if;
       if v_id >= 10 and v_id < 100 then
       v_employee_code                 := '00'||v_id;
       v_exp_employees.employee_code   := v_employee_code;
       end if;
       if v_id >= 100 and v_id < 1000 then
       v_employee_code                 := '0'||v_id;
       v_exp_employees.employee_code   := v_employee_code;
       end if;
       v_exp_employees.name            := v_dtls.employee_name;
       v_exp_employees.email           := v_dtls.email;
       v_exp_employees.mobil           := v_dtls.movephone;
       v_exp_employees.phone           := v_dtls.phone;
       v_exp_employees.enabled_flag    := 'Y';
       if v_dtls.employee_type = '管理人员' then
       v_exp_employees.employee_type_id := 22;
       end if;
       if v_dtls.employee_type = '普通员工' then
       v_exp_employees.employee_type_id := 1;
       end if;
       v_exp_employees.created_by       := 922;
       v_exp_employees.creation_date     := sysdate;
       v_exp_employees.last_updated_by := 922;
       v_exp_employees.last_update_date:= sysdate;
       --员工岗位关联表
       select t3.position_id
         into position_id
        from FND_DESCRIPTIONS t2, EXP_ORG_POSITION t3
        where  t3.description_id = t2.description_id
          and t2.description_text =  v_dtls.one_position 
          and t2.language = 'ZHS'
          and rownum = 1;  
       
       v_exp_employee_assigns.position_id    := position_id;
       v_exp_employee_assigns.employees_assign_id  := exp_employee_assigns_s.nextval;
       v_exp_employee_assigns.employee_id := v_id;
       v_exp_employee_assigns.company_id  := 241;
       
       
       v_exp_employee_assigns.primary_position_flag                := 'N';
       v_exp_employee_assigns.enabled_flag                         := 'Y';
       v_exp_employee_assigns.created_by                           := 922;
       v_exp_employee_assigns.creation_date                        := sysdate;
       v_exp_employee_assigns.last_updated_by                      := 922;
       v_exp_employee_assigns.last_update_date                     :=sysdate;
       

       
      INSERT INTO exp_employees values v_exp_employees;
      -- v_exp_employee_assigns.employee_id  then
      INSERT INTO exp_employee_assigns  values  v_exp_employee_assigns;
      -- end if;
       v_id := v_id + 1;
       v_employee_assigns_id     := v_employee_assigns_id + 1;
       
       end loop;
end;


 ---- day  6   
 CON_CONTRACT_LAW_LV1;
 
 prj_chance_lv;

select * from TEMPORARY1;
----导入用户 就把员工设为用户，员工代码就是账号，员工姓名就是描述，角色都是系统管理员，密码统一设置一个好记的
select * from exp_employees;
select * from Exp_Org_Position;
select * from FND_DESCRIPTIONS t where t.description_text='一级岗位';
select t.position_id,t1.* from EXP_ORG_POSITION t,FND_DESCRIPTIONS t1 where t.description_id = t1.description_id and t1.description_text = '董事长' and t1.language = 'ZHS';
select * from Exp_Employee_Jobs;
select * from EXP_EMPLOYEE_ASSIGNS;   --exp_employee_assigns

select * from sys_user;  --用户定义
select * from sys_role;  --角色权限
select * from sys_role_vl;   --
select * from fnd_descriptions t where t.ref_table = 'SYS_ROLE';


----付款先决条件
select * from con_contract_payment_terms;
--在表con_contract_payment_terms添加5字段    确认标志   确认时间   确认人   备注     附件数量（以f_md开头的都是附件）
con_contract_payment_terms_pkg;
--在con_contract_payment_terms_pkg 包里添加校验方法 check_
-- 附件至少上传了  X个
-- 必须标记为Y的是否全部确认
attachment_num 
con_contract_payment_terms;attachment_num ;
cashflow_id ;
f_md;


-----day  7
select * from con_contract t where t.contract_number = 'KJZLA2015-004'
select * from con_contract_cashflow;
付款条件 
prj_project 
select * from CON_CONTRACT_V;
select t.payment_condition, t.payment_condition_result from con_contract t;
CON_CONTRACT_PAYMENT_TERMS_PKG;

select *
      from con_contract_payment_terms t
     where t.payment_terms_id = p_payment_terms_id;
     
     
     
     
SELECT t1.CONTRACT_ID,t1.CALC_SESSION_ID,t1.CONTRACT_NUMBER,t1.CONTRACT_NAME,t1.BUSINESS_TYPE,t1.BUSINESS_TYPE_DESC,t1.DOCUMENT_TYPE,t1.DOCUMENT_TYPE_DESC,t1.DOCUMENT_CATEGORY,t1.DOCUMENT_CATEGORY_DESC,t1.PROJECT_ID,t1.PROJECT_NUMBER,t1.PROJECT_NAME,t1.COMPANY_ID,t1.LEASE_ORGANIZATION,t1.LEASE_ORGANIZATION_DESC,t1.LEASE_CHANNEL,t1.LEASE_CHANNEL_DESC,t1.DIVISION,t1.DIVISION_DESC,t1.BP_ID_TENANT,t1.BP_NAME,t1.BP_ID_AGENT_LEVEL1,t1.BP_ID_AGENT_LEVEL2,t1.BP_ID_AGENT_LEVEL3,t1.OWNER_USER_ID,t1.EMPLOYEE_ID,t1.EMPLOYEE_CODE,t1.EMPLOYEE_NAME,t1.UNIT_ID,t1.UNIT_CODE,t1.UNIT_NAME,t1.EMPLOYEE_ID_OF_MANAGER,t1.EMPLOYEE_CODE_OF_MANAGER,t1.EMPLOYEE_NAME_OF_MANAGER,t1.FACTORING_TYPE,t1.DESCRIPTION,t1.PRICE_LIST,t1.CALC_METHOD,t1.INCEPTION_OF_LEASE,t1.LEASE_START_DATE,t1.FIRST_PAY_DATE,t1.LAST_PAY_DATE,t1.LEASE_END_DATE,t1.LEASE_TIMES,t1.PAY_TIMES,t1.ANNUAL_PAY_TIMES,t1.LEASE_TERM,t1.PAY_TYPE,t1.CURRENCY,t1.CURRENCY_DESC,t1.CURRENCY_PRECISION,t1.MACHINERY_AMOUNT,t1.PARTS_AMOUNT,t1.LEASE_ITEM_AMOUNT,t1.LEASE_ITEM_COST,t1.DOWN_PAYMENT,t1.DOWN_PAYMENT_RATIO,t1.FINANCE_AMOUNT,t1.NET_FINANCE_AMOUNT,t1.TOTAL_INTEREST,t1.TOTAL_RENTAL,t1.TOTAL_FEE,t1.CONTRACT_AMOUNT,t1.TAX_TYPE_ID,t1.VAT_FLAG,t1.VAT_RATE,t1.VAT_INPUT,t1.VAT_TOTAL_INTEREST,t1.VAT_TOTAL_PRINCIPAL,t1.VAT_TOTAL_RENTAL,t1.VAT_TOTAL_FEE,t1.LEASE_CHARGE,t1.LEASE_CHARGE_RATIO,t1.LEASE_MGT_FEE,t1.LEASE_MGT_FEE_RATIO,t1.LEASE_MGT_FEE_RULE,t1.DEPOSIT,t1.DEPOSIT_RATIO,t1.DEPOSIT_DEDUCTION,t1.RESIDUAL_VALUE,t1.RESIDUAL_RATIO,t1.BALLOON,t1.BALLOON_RATIO,t1.INTERIM_RENT_PERIOD,t1.INTERIM_TIMES,t1.INTERIM_RENTAL,t1.INSURANCE_FEE,t1.INSURANCE_RATE,t1.COMMISSION_PAYABLE,t1.COMMISSION_RECEIVABLE,t1.THIRD_PARTY_DEPOSIT,t1.PROMISE_TO_PAY,t1.OTHER_FEE,t1.OTHER_PAYMENT,t1.ROUNDING_OBJECT,t1.ROUNDING_METHOD,t1.INT_RATE_FIXING_WAY,t1.INT_RATE_FIXING_RANGE,t1.INT_RATE_DISPLAY,t1.BASE_RATE_TYPE,t1.BASE_RATE,t1.INT_RATE,t1.INT_RATE_IMPLICIT,t1.INT_RATE_TYPE,t1.FLT_RATE_PROFILE,t1.FLT_RATE_ADJ_METHOD,t1.FLT_SIMULATE_STEP,t1.FLT_SIMULATE_RANGE,t1.FLT_UNIT_ADJ_AMT,t1.FLT_EXECUTE_TIMES_RULE,t1.FLT_INT_RATE_ADJ_DATE,t1.INT_RATE_PRECISION,t1.IRR,t1.IRR_AFTER_TAX,t1.INT_RATE_IMPLICIT_AFTER_TAX,t1.IRR_RESERVED1,t1.IRR_RESERVED2,t1.IRR_RESERVED3,t1.PMT,t1.PMT_FIRST,t1.ANNUAL_MEAN_RATE,t1.TOTAL_SALESTAX,t1.BIZ_DAY_CONVENTION,t1.CALC_WITH_RESIDUAL_VALUE,t1.EXCHANGE_RATE_TYPE,t1.EXCHANGE_RATE_TYPE_DESC,t1.EXCHANGE_RATE_QUOTATION,t1.EXCHANGE_RATE,t1.PENALTY_PROFILE,t1.GRACE_PERIOD,t1.PENALTY_RATE,t1.PENALTY_CALC_BASE,t1.PENALTY_TOTAL_BASE_RATIO,t1.CREDIT_WRITE_OFF_ORDER,t1.FIN_INCOME_RECOGNIZE_METHOD,t1.EARLY_TERMINATION_PROFILE,t1.PAYMENT_METHOD_ID,t1.TELEX_TRANSFER_BANK_ID,t1.TT_BANK_BRANCH_NAME,t1.TT_BANK_ACCOUNT_NUM,t1.TT_BANK_ACCOUNT_NAME,t1.TT_REMARK,t1.DIRECT_DEBIT_BANK_ID,t1.DD_BANK_BRANCH_NAME,t1.DD_BANK_ACCOUNT_NUM,t1.DD_BANK_ACCOUNT_NAME,t1.DD_AGREEMENT_NO,t1.DD_AGREEMENT_STATUS,t1.DD_REMARK,t1.PURCHASE_ORDER_NO,t1.CONTRACT_STATUS,t1.CONTRACT_STATUS_DESC,t1.USER_STATUS_1,t1.USER_STATUS_2,t1.USER_STATUS_3,t1.PRINT_STATUS,t1.PRINT_TIMES,t1.FIRST_PRINT_DATE,t1.FIRST_PRINT_BY,t1.DELIVERY_STATUS,t1.DELIVERY_DATE,t1.BILLING_METHOD,t1.BILLING_METHOD_DESC,t1.BILLING_STATUS,t1.SIGNING_DATE,t1.ORIGINAL_RECALL_DATE,t1.LEASE_CARD_RECALL_DATE,t1.EARLY_TERMINATION_DATE,t1.TERMINATION_DATE,t1.ASSIGNMENT_AGREEMENT_NO,t1.ASSIGNMENT_DATE,t1.BTB_PAYMENT_DATE,t1.BTB_INT_RATE,t1.BTB_INT_RATE_IMPLICIT,t1.BTB_FINANCE_AMOUNT,t1.BTB_NET_FINANCE_AMOUNT,t1.BTB_TOTAL_REPAYMENT,t1.BTB_TOTAL_INTEREST,t1.BTB_TOTAL_FEE_PV,t1.BTB_TOTAL_FEE,t1.BTB_FINANCE_RATIO,t1.BTB_INTEREST_MARGIN,t1.BTB_VAT_INTEREST,t1.BTB_VAT_FEE,t1.BTB_INTEREST_AFTER_TAX,t1.BTB_FEE_AFTER_TAX,t1.CDD_LIST_ID,t1.VAT_RATE_OF_INTEREST,t1.HD_USER_COL_D01,t1.HD_USER_COL_D02,t1.HD_USER_COL_D03,t1.HD_USER_COL_D04,t1.HD_USER_COL_D05,t1.HD_USER_COL_V01,t1.HD_USER_COL_V02,t1.HD_USER_COL_V03,t1.HD_USER_COL_V04,t1.HD_USER_COL_V05,t1.HD_USER_COL_V06,t1.HD_USER_COL_V07,t1.HD_USER_COL_V08,t1.HD_USER_COL_V09,t1.HD_USER_COL_V10,t1.HD_USER_COL_N01,t1.HD_USER_COL_N02,t1.HD_USER_COL_N03,t1.HD_USER_COL_N04,t1.HD_USER_COL_N05,t1.HD_USER_COL_N06,t1.HD_USER_COL_N07,t1.HD_USER_COL_N08,t1.HD_USER_COL_N09,t1.HD_USER_COL_N10,t1.HD_USER_COL_N11,t1.HD_USER_COL_N12,t1.HD_USER_COL_N13,t1.HD_USER_COL_N14,t1.HD_USER_COL_N15,t1.PRJ_SEARCH_TERM_1,t1.PRJ_SEARCH_TERM_2,t1.CON_SEARCH_TERM_1,t1.CON_SEARCH_TERM_2,t1.finish_flag
FROM CON_CONTRACT_V t1
WHERE CONTRACT_ID = 77
ORDER BY t1.contract_number desc


SELECT t1.CONTRACT_ID,t1.CALC_SESSION_ID,t1.CONTRACT_NUMBER,t1.CONTRACT_NAME,t1.BUSINESS_TYPE,t1.BUSINESS_TYPE_DESC,t1.DOCUMENT_TYPE,t1.DOCUMENT_TYPE_DESC,t1.DOCUMENT_CATEGORY,t1.DOCUMENT_CATEGORY_DESC,t1.PROJECT_ID,t1.PROJECT_NUMBER,t1.PROJECT_NAME,t1.COMPANY_ID,t1.LEASE_ORGANIZATION,t1.LEASE_ORGANIZATION_DESC,t1.LEASE_CHANNEL,t1.LEASE_CHANNEL_DESC,t1.DIVISION,t1.DIVISION_DESC,t1.BP_ID_TENANT,t1.BP_NAME,t1.BP_ID_AGENT_LEVEL1,t1.BP_ID_AGENT_LEVEL2,t1.BP_ID_AGENT_LEVEL3,t1.OWNER_USER_ID,t1.EMPLOYEE_ID,t1.EMPLOYEE_CODE,t1.EMPLOYEE_NAME,t1.UNIT_ID,t1.UNIT_CODE,t1.UNIT_NAME,t1.EMPLOYEE_ID_OF_MANAGER,t1.EMPLOYEE_CODE_OF_MANAGER,t1.EMPLOYEE_NAME_OF_MANAGER,t1.FACTORING_TYPE,t1.DESCRIPTION,t1.PRICE_LIST,t1.CALC_METHOD,t1.INCEPTION_OF_LEASE,t1.LEASE_START_DATE,t1.FIRST_PAY_DATE,t1.LAST_PAY_DATE,t1.LEASE_END_DATE,t1.LEASE_TIMES,t1.PAY_TIMES,t1.ANNUAL_PAY_TIMES,t1.LEASE_TERM,t1.PAY_TYPE,t1.CURRENCY,t1.CURRENCY_DESC,t1.CURRENCY_PRECISION,t1.MACHINERY_AMOUNT,t1.PARTS_AMOUNT,t1.LEASE_ITEM_AMOUNT,t1.LEASE_ITEM_COST,t1.DOWN_PAYMENT,t1.DOWN_PAYMENT_RATIO,t1.FINANCE_AMOUNT,t1.NET_FINANCE_AMOUNT,t1.TOTAL_INTEREST,t1.TOTAL_RENTAL,t1.TOTAL_FEE,t1.CONTRACT_AMOUNT,t1.TAX_TYPE_ID,t1.VAT_FLAG,t1.VAT_RATE,t1.VAT_INPUT,t1.VAT_TOTAL_INTEREST,t1.VAT_TOTAL_PRINCIPAL,t1.VAT_TOTAL_RENTAL,t1.VAT_TOTAL_FEE,t1.LEASE_CHARGE,t1.LEASE_CHARGE_RATIO,t1.LEASE_MGT_FEE,t1.LEASE_MGT_FEE_RATIO,t1.LEASE_MGT_FEE_RULE,t1.DEPOSIT,t1.DEPOSIT_RATIO,t1.DEPOSIT_DEDUCTION,t1.RESIDUAL_VALUE,t1.RESIDUAL_RATIO,t1.BALLOON,t1.BALLOON_RATIO,t1.INTERIM_RENT_PERIOD,t1.INTERIM_TIMES,t1.INTERIM_RENTAL,t1.INSURANCE_FEE,t1.INSURANCE_RATE,t1.COMMISSION_PAYABLE,t1.COMMISSION_RECEIVABLE,t1.THIRD_PARTY_DEPOSIT,t1.PROMISE_TO_PAY,t1.OTHER_FEE,t1.OTHER_PAYMENT,t1.ROUNDING_OBJECT,t1.ROUNDING_METHOD,t1.INT_RATE_FIXING_WAY,t1.INT_RATE_FIXING_RANGE,t1.INT_RATE_DISPLAY,t1.BASE_RATE_TYPE,t1.BASE_RATE,t1.INT_RATE,t1.INT_RATE_IMPLICIT,t1.INT_RATE_TYPE,t1.FLT_RATE_PROFILE,t1.FLT_RATE_ADJ_METHOD,t1.FLT_SIMULATE_STEP,t1.FLT_SIMULATE_RANGE,t1.FLT_UNIT_ADJ_AMT,t1.FLT_EXECUTE_TIMES_RULE,t1.FLT_INT_RATE_ADJ_DATE,t1.INT_RATE_PRECISION,t1.IRR,t1.IRR_AFTER_TAX,t1.INT_RATE_IMPLICIT_AFTER_TAX,t1.IRR_RESERVED1,t1.IRR_RESERVED2,t1.IRR_RESERVED3,t1.PMT,t1.PMT_FIRST,t1.ANNUAL_MEAN_RATE,t1.TOTAL_SALESTAX,t1.BIZ_DAY_CONVENTION,t1.CALC_WITH_RESIDUAL_VALUE,t1.EXCHANGE_RATE_TYPE,t1.EXCHANGE_RATE_TYPE_DESC,t1.EXCHANGE_RATE_QUOTATION,t1.EXCHANGE_RATE,t1.PENALTY_PROFILE,t1.GRACE_PERIOD,t1.PENALTY_RATE,t1.PENALTY_CALC_BASE,t1.PENALTY_TOTAL_BASE_RATIO,t1.CREDIT_WRITE_OFF_ORDER,t1.FIN_INCOME_RECOGNIZE_METHOD,t1.EARLY_TERMINATION_PROFILE,t1.PAYMENT_METHOD_ID,t1.TELEX_TRANSFER_BANK_ID,t1.TT_BANK_BRANCH_NAME,t1.TT_BANK_ACCOUNT_NUM,t1.TT_BANK_ACCOUNT_NAME,t1.TT_REMARK,t1.DIRECT_DEBIT_BANK_ID,t1.DD_BANK_BRANCH_NAME,t1.DD_BANK_ACCOUNT_NUM,t1.DD_BANK_ACCOUNT_NAME,t1.DD_AGREEMENT_NO,t1.DD_AGREEMENT_STATUS,t1.DD_REMARK,t1.PURCHASE_ORDER_NO,t1.CONTRACT_STATUS,t1.CONTRACT_STATUS_DESC,t1.USER_STATUS_1,t1.USER_STATUS_2,t1.USER_STATUS_3,t1.PRINT_STATUS,t1.PRINT_TIMES,t1.FIRST_PRINT_DATE,t1.FIRST_PRINT_BY,t1.DELIVERY_STATUS,t1.DELIVERY_DATE,t1.BILLING_METHOD,t1.BILLING_METHOD_DESC,t1.BILLING_STATUS,t1.SIGNING_DATE,t1.ORIGINAL_RECALL_DATE,t1.LEASE_CARD_RECALL_DATE,t1.EARLY_TERMINATION_DATE,t1.TERMINATION_DATE,t1.ASSIGNMENT_AGREEMENT_NO,t1.ASSIGNMENT_DATE,t1.BTB_PAYMENT_DATE,t1.BTB_INT_RATE,t1.BTB_INT_RATE_IMPLICIT,t1.BTB_FINANCE_AMOUNT,t1.BTB_NET_FINANCE_AMOUNT,t1.BTB_TOTAL_REPAYMENT,t1.BTB_TOTAL_INTEREST,t1.BTB_TOTAL_FEE_PV,t1.BTB_TOTAL_FEE,t1.BTB_FINANCE_RATIO,t1.BTB_INTEREST_MARGIN,t1.BTB_VAT_INTEREST,t1.BTB_VAT_FEE,t1.BTB_INTEREST_AFTER_TAX,t1.BTB_FEE_AFTER_TAX,t1.CDD_LIST_ID,t1.VAT_RATE_OF_INTEREST,t1.HD_USER_COL_D01,t1.HD_USER_COL_D02,t1.HD_USER_COL_D03,t1.HD_USER_COL_D04,t1.HD_USER_COL_D05,t1.HD_USER_COL_V01,t1.HD_USER_COL_V02,t1.HD_USER_COL_V03,t1.HD_USER_COL_V04,t1.HD_USER_COL_V05,t1.HD_USER_COL_V06,t1.HD_USER_COL_V07,t1.HD_USER_COL_V08,t1.HD_USER_COL_V09,t1.HD_USER_COL_V10,t1.HD_USER_COL_N01,t1.HD_USER_COL_N02,t1.HD_USER_COL_N03,t1.HD_USER_COL_N04,t1.HD_USER_COL_N05,t1.HD_USER_COL_N06,t1.HD_USER_COL_N07,t1.HD_USER_COL_N08,t1.HD_USER_COL_N09,t1.HD_USER_COL_N10,t1.HD_USER_COL_N11,t1.HD_USER_COL_N12,t1.HD_USER_COL_N13,t1.HD_USER_COL_N14,t1.HD_USER_COL_N15,t1.PRJ_SEARCH_TERM_1,t1.PRJ_SEARCH_TERM_2,t1.CON_SEARCH_TERM_1,t1.CON_SEARCH_TERM_2,t1.finish_flag,t1.PAYMENT_CONDITION,t1.PAYMENT_CONDITION_RESULT
FROM CON_CONTRACT_V t1
WHERE CONTRACT_ID = 77
ORDER BY t1.contract_number desc


select t.* 
            	from con_contract t where t.contract_id =77
              
select t.contract_id,t.payment_condition, t.payment_condition_result 
            	from con_contract t
            	 WHERE t.contract_id=77
            
            



select * from csh_payment_req_hd;
select * from hls_bp_master;

select t.payment_condition,t.payment_condition_result from prj_project t;



---- day 8  付款申请创建·付款条件  (后期与执行**书进行数据对接)

select t.contract_id,t.payment_condition, t.payment_condition_result,t.confirm_flag,t.confirm_date,t.confirm_person,t.attachment_num
            	from con_contract t;

prj_project

select * from CON_CONTRACT;

CSH_PAYMENT_REQ_PKG  --- 在CSH_PAYMENT_REQ_PKG里加了个check_con_payment_confirm


CON_CONTRACT_PAYMENT_TERMS_PKG;
select *
                     from con_contract t
                    where t.contract_id = p_contract_id;
                    
----附件
select * from fnd_atm_attachment;     --attachment_id & source_pk_value 
select * from fnd_atm_attachment_multi;
select * from fnd_atm_attachment_del_buffer;
---fnd_atm_attachment_pkg;
select * from fnd_atm_file_source;
select * from fnd_atm_file_type;
select * from fnd_atm_file_types;
fnd_atm_file_pkg;
select * from fnd_attach_documents;

select * from con_contract;

select count(1) from fnd_atm_attachment_multi t where t.table_name = 'CON_CONTRACT' and exists(select t1.attachment_id from fnd_atm_attachment t1 where t1.attachment_id=t.attachment_id);


select t.contract_id,
       t.payment_condition,
       t.payment_condition_result,
       nvl(t.confirm_flag, 'N') confirm_flag,
       t.confirm_date,
       (select u.description
          from sys_user u
         where u.user_id = t.confirm_person),
       t.attachment_num
  from con_contract t;
select t.user_id from sys_user t where t.description = ;


select count(1)
        
        from fnd_atm_attachment_multi t
       where t.table_name = 'CON_CONTRACT'
         and exists (select t1.attachment_id
                from fnd_atm_attachment t1
               where t1.attachment_id = t.attachment_id
                 and t1.file_path is not null)

select * from fnd_atm_attachment_multi;


----   day 8  (1)     工作流审批规则定义
select * from zj_
select * from zj_wfl_workflow_rules;
select * from ZJ_WFL_WORKFLOW_RULES;


select rule_code,
       decode(rule_type, RECIPIENT_RULE,
       description,
       procedure_name,
       sys_flag,
       parameter_1_type,
       parameter_1_desc,
       parameter_1_url,
       parameter_2_type,
       parameter_2_desc,
       parameter_2_url,
       parameter_3_type,
       parameter_3_desc,
       parameter_3_url,
       parameter_4_type,
       parameter_4_desc,
       parameter_4_url,
       approver_flag,
       notice_flag,
       parameter_5_type,
       parameter_5_desc,
       parameter_5_url,
       enabled_flag
  from zj_wfl_workflow_rules;



----- day  8  (2)  合同起租
select t.inception_of_lease,t.lease_start_date,t.due_inception_date,t.last_update_date,t.* from con_contract t where t.contract_number='KJZLA2015-003';
select c.* from con_contract_incept_wfl c;  suggest_incept_date;
alter table con_contract_incept_wfl drop column incept_date;

con_contract_incept_apply_pkg.workflow_finish;
--合同包.起租    预计起租日2015-12-09
con_contract_pkg.contract_incept;
select t.created_by from con_contract t;
due_inception_date 
--
select *
  from (select a.contract_id,
               a.contract_number,
               a.contract_name,
               a.finance_amount,
               b.loan_amount,
               b.loan_date,
               a.pre_incept_date,
               c.employee_suggest_dec,
               c.suggest_incept_date,
               c.lease_condition,
               c.wfl_instance_id,
               a.lease_start_date,
               a.last_update_date
          from con_contract a,
               con_contract_incept_wfl c,
               (select t2.contract_id,
                       sum(t2.write_off_due_amount) loan_amount,
                       max(t2.write_off_date) loan_date
                  from csh_write_off t2, con_contract_cashflow t3
                 where t2.reversed_flag = 'N'
                   and t2.contract_id = t3.contract_id
                   and t2.cashflow_id = t3.cashflow_id
                   and t2.cf_item = t3.cf_item
                 group by t2.contract_id) b
         where a.contract_id = c.contract_id
           and c.contract_id = b.contract_id(+)) t;

--用印表     
create table hls_signet_of_bill(
       signet_id        number           primary key,
       signet_type      varchar2(50),
       bill_id          number,
       created_by       number,
       creation_date    date,
       last_update_by   number,
       last_update_date date,
       bill_type        varchar2(50)
)
--用印-单据关联表
create table hls_signet_of_bill_link(
       signet_bill_link_id      number     primary key,
       signet_id                number,
       signet_type              varchar2(50),
       bill_id                  number,
       created_by               number,
       creation_date            date,
       last_update_by           number,
       last_update_date         date,
       status                   varchar2(50),
       bill_type                varchar2(50)       
)

create table hls_signet_of_bill_log(
       signet_of_bill_log_id    number     primary key,
       signet_bill_link_id      number,
       signet_id                number,
       signet_type              varchar2(50),
       bill_id                  number,
       bill_type                varchar2(50),
       status                   varchar2(50),
       created_by               number,
       creation_date            date,
       last_update_by           number,
       last_update_date         date
       
)

--忘记带前缀
drop table signet_of_bill;
drop table signet_of_bill_link;

select * from hls_signet_of_bill;
select * from hls_signet_of_bill;
select * from hls_signet_of_bill_link;
select * from hls_signet_of_bill_log;
select t.last_updated_by  from con_contract t; 
insert into hls_signet_of_bill(signet_id,signet_type,con_code,signet_matter,apply_signet_method,apply_signet_date,due_re_signet_date,approve_status)
values (hls_signet_of_)
select * from con_contract_lv;
select * from sys_user;
select * from sys_user where description ='艾思文';


---ORACLE 往外网发送邮件，
--在ACL里注册 邮箱地址

--- 创建表 - 添加备注 - 导出表脚本（备份，移植可用） - 再运行一次 - 

select * from HLS_COMPANY_SEAL_DEFINE;
select * from HLS_COMPANY_SEAL_APPLY_HD;
select * from HLS_COMPANY_SEAL_APPLY_LN;

delete HLS_COMPANY_SEAL_DEFINE where define_id =1;


select * from 

---- day 15/12/28
--工作流类型
select * from ZJ_WFL_WORKFLOW_TYPE;
zj_wfl_workflow_pkg.delete_wfl_type
--工作流定义
select * from zj_wfl_workflow;
select * from zj_wfl_workflow_v;
select * from zj_wfl_workflow_node where node_id=1781;  --工作流节点
select * from zj_wfl_workflow_node_action;   --审批节点
select * from zj_wfl_workflow_assign_rule;   --审批规则
select * from zj_wfl_workflow_instance;      --审批情况

select * from zj_wfl_workflow_node_branch;
select * from zj_wfl_workflow_node_action where node_id = 1781;
zj_wfl_workflow_pkg.delete_wfl_workflow;
zj_wfl_workflow_pkg.workflow_handle;
zj_wfl_workflow_pkg.workflow_handle;
--消息模板定义
select * from ZJ_SYS_NOTIFY_TEMPLATE;


--工作流调用过程
select * from ZJ_WFL_WORKFLOW_PROCEDURE;
zj_wfl_workflow_pkg.delete_wfl_procedure;
--工作流页面
select * from ZJ_WFL_WORKFLOW_SERVICE;
zj_wfl_workflow_pkg.delete_wfl_service
--工作流分配（公司）
select * from ZJ_WFL_WORKFLOW_ASSIGNS;
select t1.assign_id,
				       t1.workflow_id,
				       w.workflow_code,
				       w.workflow_desc,
				       w.workflow_type_id,
				       w.workflow_type_code,
				       w.workflow_type_desc,
				       w.sub_category,
				       w.sub_category_desc,
				       t1.company_id,
				       c.company_code,
				       c.company_short_name as company_name,
				       t1.enabled_flag
				  from zj_wfl_workflow_assigns t1
				 inner join zj_wfl_workflow_v w
				    on w.workflow_id = t1.workflow_id
				 inner join zj_wfl_workflow_companies_vl c
				    on c.company_id = t1.company_id
				#WHERE_CLAUSE#
				order by w.workflow_type_code,w.workflow_code;
        
--工作流审批人定义   关联公司  再关联到具体审批人
select * from ZJ_WFL_WORKFLOW_COMPANIES_VL;

--业务规则参数定义
select * from ZJ_WFL_BUSINESS_RULE_PARAS; 

--工作流业务规则定义
select * from ZJ_WFL_BUSINESS_RULE_DETAILS;

zj_wfl_approver_pkg;

select * from con_contract;

select * from zj_wfl_approve_record;


---- day  15/12/29
select * from Tre_Funds_Reservation;
SELECT * FROM CON_CONTRACT;
SELECT * FROM FND_

select * from TRE_FINANCE_RESERVATION;
--资金预约表
create table TRE_FINANCE_RESERVATION(
       RESERVATION_ID                            NUMBER,
       RESERVATION_CODE                          VARCHAR2(30),
       CONTRACT_ID                               NUMBER,
       CONTRACT_NAME                             NUMBER,
       RESERVATION_PERSON_ID                     NUMBER,
       RESERVATION_PERSON_UNIT_ID                NUMBER,
       RESERVATION_TYPE                          VARCHAR2(30),
       RESERVATION_AMOUNT                        NUMBER,
       RESERVATION_DATE                          DATE,
       BANK_ACCOUNT_ID                           NUMBER,
       BANK_ACCOUNT_NAME                         VARCHAR2(2000),
       BANK_BRANCH_ID                            NUMBER,
       STATUS                                    VARCHAR2(30),
       creation_date                             DATE,
       created_by                                NUMBER,
       last_update_date                          DATE,
       last_updated_by                           NUMBER
       
);

select * from TRE_FINANCE_RESERVATION;


select * from csh_bank;   --银行
select * from csh_bank_branch;  --支行
SELECT * FROM csh_bank_account;   --账户

select t.bank_account_id,
       t.bank_account_code,
       t.bank_account_name,
       t.bank_account_num,
       t1.bank_branch_id,
       t1.bank_branch_name,
       t1.bank_branch_code
  from csh_bank_account t, csh_bank_branch t1
 where t.bank_branch_id = t1.bank_branch_id
   and t.company_id = 241

select * from con_contract;


select * from HLS_SALESMAN_V;
select * from exp_employees;
SELECT t.unit_id unit_id, t.unit_code unit_code, t2.description_text unit_desc
  FROM EXP_ORG_UNIT t, fnd_descriptions t2
 where t.description_id = t2.description_id
   and t2.language = 'ZHS';
   
select * from sys_user;   --employee_id    1582
select * from exp_employees;    --employee_id
select * from exp_employee_assigns;  -- primary_position_flag 'Y' 主岗位   position_id
select * from exp_org_position;     --unit_id
select * from exp_org_unit;
select * from fnd_descriptions;     --description_id

insert into Tre_Funds_Reservation
  (Reservation_Id,
   Contract_Id,
   Reservation_Person_Id,
   Reservation_Unit_Id,
   Reservation_Type,
   Reserve_Amount,
   Reservation_Date,
   Bank_Account_Id,
   Bank_Branch_Id,
   Status)
values
  (Tre_Funds_Reservation_s.Nextval,
  44,
  1582,
  291,
  
  )
  select Tre_Funds_Reservation_s.Nextval from dual;

select t1.user_id,t2.name,t2.employee_code, t4.unit_id, t5.unit_code, t6.description_text
  from sys_user             t1,
       exp_employees        t2,
       exp_employee_assigns t3,
       exp_org_position     t4,
       exp_org_unit         t5,
       fnd_descriptions     t6

 where t1.employee_id = t3.employee_id
   and t1.employee_id = t2.employee_id
   and t3.position_id = t4.position_id
   and t4.unit_id = t5.unit_id
   and t5.description_id = t6.description_id
   and t6.language = 'ZHS'
 and   user_id = 1582

tre510_save_pkg.reserve;
select  from con_contract c;

select * from Tre_Funds_Reservation;

select t1.contract_id,
       t1.reservation_person_id,
       t1.reservation_unit_id,
       t1.reservation_type,
       t1.reserve_amount,
       t1.reservation_date,
       t1.bank_account_id,
       t1.bank_branch_id,
       t1.status
  from Tre_Funds_Reservation t1
  
  delete from Tre_Funds_Reservation where contract_id = 77;



  
  
  
  
  select * from
          	(select t1.reservation_id,
             t1.contract_id,
			       (select c.contract_name
			          from con_contract c
			         where c.contract_id = t1.contract_id) contract_name,
			       t1.contract_number,
			       t1.contract_number contract_number_desc,
			       t1.reservation_person_id,
			       (select s.description
			          from sys_user s
			         where s.user_id = t1.reservation_person_id) reservation_person_desc,
			       t1.reservation_unit_id,
			       (select fd.description_text
			          from exp_org_unit u,fnd_descriptions fd
			         where u.unit_id = t1.reservation_unit_id
               and   u.description_id=fd.description_id
               and   fd.language='ZHS') reservation_unit_desc,
			       t1.reservation_type,
			       (select c1.code_value_name
			          from sys_code_values_v c1
			         where c1.code = 'RESERVE_STATUS'
			           and c1.code_value = nvl(t1.status, 'NOT')) as reservation_type_desc,
             t1.reserve_amount,
			       t1.reservation_date,
			       t1.reservation_date reservation_date_from,
			       t1.reservation_date reservation_date_to,
			       t1.bank_account_id,
			       (select csh.bank_account_name
			          from csh_bank_account csh
			         where csh.bank_account_id = t1.bank_account_id) bank_account_name_desc,
			       (select csh.bank_account_num
			          from csh_bank_account csh
			         where csh.bank_account_id = t1.bank_account_id) bank_account_desc,
			       (select csh.bank_account_code
			          from csh_bank_account csh
			         where csh.bank_account_id = t1.bank_account_id) bank_account_code,
			       t1.bank_branch_id,
			       (select cbb.bank_branch_name
			          from csh_bank_branch cbb
			         where cbb.bank_branch_id = t1.bank_branch_id) bank_branch_desc,
               (select cbb.bank_branch_code
			            from csh_bank_branch cbb
			           where cbb.bank_branch_id =t1.bank_branch_id) bank_branch_code,
             t1.status,
             decode(t1.status,'NOT','新建','RESERVING','预约中','RESERVED','已预约')status_desc
			  from tre_funds_reservation t1
        where nvl(t1.confirm_status,'UNCONFIRMED')='UNCONFIRMED'
        and   t1.status in ('RESERVING','RESERVED')
        ) t

---- day  15/12/30
delete tre_funds_reservation t where t.reservation_id=22; 
select * from tre_funds_reservation;   --  1582  1587
select * from sys_user where user_id=1582;

update tre_funds_reservation t
   set t.status = 'NOT',
       t.confirm_status = 'CONFIRMED'
 where t.reservation_id = 10;
 
select * from exp_emp_user_a_v;


select c.contract_name, c.contract_number, u.employee_name, r.created_by

      from tre_funds_reservation r, con_contract c, exp_emp_user_a_v u
     where r.contract_id = c.contract_id
       and r.created_by = u.user_id
       and r.reservation_id = 22;
       
       
select * from  tre_funds_reservation r where r.reservation_id =22;



select * from con_contract;
       
zj_wfl_workflow_pkg;
sys_notice_msg_pkg.create_notice_msg


select t1.user_id,t2.name,t4.unit_id, t5.unit_code, t6.description_text unit_desc
				  from sys_user             t1,
				       exp_employees        t2,
				       exp_employee_assigns t3,
				       exp_org_position     t4,
				       exp_org_unit         t5,
				       fnd_descriptions     t6
				
				 where t1.employee_id = t3.employee_id
				   and t1.employee_id = t2.employee_id
				   and t3.position_id = t4.position_id
				   and t4.unit_id = t5.unit_id
				   and t5.description_id = t6.description_id
				   and t6.language = 'ZHS'
           
           
           SELECT t.unit_id, t.unit_code, t2.description_text unit_desc
				  FROM EXP_ORG_UNIT t, fnd_descriptions t2
				 where t.description_id = t2.description_id
				   and t2.language = 'ZHS'
           
           
           select * from tre_funds_reservation;
           delete tre_funds_reservation where reservation_person_id = 1;
           
           select c.contract_id, c.contract_number, c.contract_name
             from con_contract c
            where data_class = 'NORMAL';

           select t.user_id,t.description from sys_user t;
            
tre510_save_pkg.reserve;           

               select c.contract_name, c.contract_number, u.description, r.created_by

      from tre_funds_reservation r, con_contract c, sys_user u
     where r.contract_id = c.contract_id
       and r.created_by = u.user_id
       and r.reservation_id = 23;
               
       
       
----  day 2015/12/31
hls_company_seal_apply_pkg

select * from hls_company_seal_apply_hd;
select * from hls_company_seal_apply_ln;

select * from tre_funds_reservation;

tre_funds_reservation_pkg;
hls_workflow_pkg;
zj_wfl_workflow_start_pkg;
workflow_assign_check;

--付款申请创建中，
select * from csh_payment_req_hd;
select * from CSH_PAYMENT_REQ_HD_LV;
select * from csh_payment_req_ln;
select * from CSH_PAYMENT_REQ_DEBT_LN_LV;
take_lease_flag 
select * from con_contract;

select * from con_contract_lease_item;

--抵押物
SELECT cc.contract_id,
       cc.contract_number, --合同编号
       cc.contract_name, --合同名称
       
       cc.bp_id_vender_n, --供应商
       
       li.SHORT_NAME, --租赁物简称
       li.full_name, --租赁物全称
       li.take_lease_status,
       li.repeat_lease_flag,
       li.fh_lease_nameplate,
       li.saving_position
  FROM con_contract_lv cc,    li
 WHERE cc.data_class = 'NORMAL'
   AND cc.contract_id = li.contract_id;
  
   update con_contract_lease_item t
   set t.take_lease_status=,
       t.repeat_lease_flag=,
       t.fh_lease_nameplate=,
       t.saving_position=
   where t.contract_lease_item_id=

select * from con_contract_lease_item;

SELECT cc.contract_id,
                 
					       cc.contract_number, --合同编号
					       cc.contract_name, --合同名称
					       li.contract_lease_item_id,
                           cc.project_id_c,
                           cc.project_id_n,
					       cc.bp_id_vender_n, --供应商
					       li.SHORT_NAME, --租赁物简称
					       li.full_name, --租赁物全称
					       li.take_lease_status,  --是否验收状态
					       li.repeat_lease_flag,  --重复租赁标识
					       li.fh_lease_nameplate,  --丰汇租赁铭牌
					       li.saving_position    --存放位置
					  FROM con_contract_lv cc, con_contract_lease_item li
					 WHERE cc.data_class = 'NORMAL'
					   AND cc.contract_id = li.contract_id
					   AND cc.contract_id = 34
         --AND cc.contract_id = ${/parameter/@contract_id}
         select t.contract_id,t.contract_number,t.contract_name from con_contract t;
         
         
         select * from exp_employee_assigns;
         
         
         TRE_FUNDS_RESERVATION_PKG
         
         
         
---- day 2016/01/04
select * from con_contract_lease_item;
select * from con_lease_item_check_detail;
select * from con_lease_item_check;
insert into con_contract_lease_item
  (contract_lease_item_id,
   contract_id,
   lease_item_id,
   short_name,
   full_name,
   take_lease_status,
   repeat_lease_flag,
   fh_lease_nameplate,
   saving_position)
values
  (con_contract_lease_item_s.nextval,
  '',
  '',
  '',
  '',
  '',
  '');
  
  select * from sys_code_values t1,fnd_descriptions t2 where t1.
  select * from sys_codes where code_id = '2737';
  select * from sys_code_values_v ;
  select * from sys_code_values_vl;
  select * from sys_codes_vl v where v.code='take_lease_status';
  select * from sys_code_values t where t.code_value='TAKING';
  select * from fnd_descriptions t where t.description_text='已验收';
  select v.code_value_name
    from sys_code_values_v v
   where v.code = 'TAKE_LEASE_STATUS'
     and v.code_value = 'TAKED';
     
     select * from hls_company_seal_apply_ln;
     select * from hls_company_seal_apply_hd;
     select * from hls_company_seal_define;
     
     hls_company_seal_apply_pkg;

select * from con_contract_lease_item;
con_contract_lease_item_pkg;
select t.lease_item_code,t.short_name,t.full_name from hls_lease_item t;

delete con_contract_lease_item t where t.contract_lease_item_id = 29; 

select * from con_contract_lease_item;

select * from con_contract_lv cc;
select * from con_contract t where t.;
select li.short_name,li.full_name from con_contract_lease_item li where li.contract_id=?;
select * from hls_lease_item;    --1532
select * from sys_user where user_id = 1532;
select * from con_contract;

select p.chance_id,p.COMPANY_PROFIT_FORECAST from prj_chance p;

create table con_contract_lease_item_detail(
       con_contract_lease_item_detail_id     number,
       contract_lease_item_id                number,
       short_name,                           varchar2(200),
       full_name,                            varchar2(2000),
       take_lease_status                     varchar2(30),
       repeat_lease_flag                     varchar2(1),
       fh_lease_nameplate                    varchar2(200),
       saving_position                       varchar2(200)
);

select * from con_contract_lease_item_;
select * from prj_chance_lv;
prj_chance;

tre_funds_reservation_pkg

select * from hls_lease_item;
select * from con_contract_lease_item ;


SELECT t1.bp_id             AS value_code,
       t1.bp_name           AS value_name,
       t1.bp_code  ,
       t1.industry,
      (select description from hls_stat_class where class_id = t1.industry)industry_n,
      (select risk_cue from hls_stat_class where class_id = t1.industry)industry_risk_cue,
       t1.actual_controller
  FROM hls_bp_master t1
 WHERE t1.enabled_flag = 'Y'
       AND t1.bp_category = 'TENANT'
      AND nvl(t1.blacklist_flag,'N') = 'N';
      select bp_name from hls_bp_master t1 where t1.bp_id = 78 
      and t1.enabled_flag = 'Y'
      AND t1.bp_category = 'TENANT'
      AND nvl(t1.blacklist_flag,'N') = 'N';
      
      
      
      select hli.lease_item_id,hli.short_name,hli.full_name from con_contract_lease_item cli,hls_lease_item hli where cli.lease_item_id = hli.lease_item_id
      select hli.lease_item_id,hli.short_name,hli.full_name from con_contract_lease_item cli,hls_lease_item hli where cli.lease_item_id = hli.lease_item_id and cli.contract_id=34；
    ;
   ---day 2016/01/05
   con_contract_lease_item_detail;
   
   
   
   select eea.employee_id mgr_employee_id,
            		   eea.employee_code mgr_employee_code,
            		   eea.employee_name mgr_employee_name
				  from exp_emp_assign_e_v eea
				 where eea.position_id in
				       (select chief_position_id
				          from exp_org_unit
				         where unit_id =320)
   --部门  
   select t1.description_text,t.* from exp_org_unit t,fnd_descriptions t1 where t.description_id=t1.description_id and t.unit_id=344;  --   产业投资部
   select * from exp_emp_assign_e_v v where v.position_id = 907 
   
   select * from fnd_descriptions t1 where t1.description_text = '投行事业部';
   select * from exp_org_unit u where u.unit_code='4005'   --298 节能环保业务部    297  投行事业部    293  房地产金融部
   
   
   
   
   SELECT tt1.company_id,
				       tt3.lease_organization,
				       tt3.description,
				       tt4.unit_id,
				       tt4.unit_name
				  FROM fnd_companies          tt1,
				       hls_lease_org_assign   tt2,
				       hls_lease_organization tt3,
				       exp_org_unit_v         tt4
				 WHERE tt1.company_id = tt2.company_id
				       AND tt2.enabled_flag = 'Y'
				       AND tt2.lease_organization = tt3.lease_organization
				       AND tt3.enabled_flag = 'Y'
				       AND tt2.unit_id = tt4.unit_id
				       AND tt4.enabled_flag = 'Y'
   
      select * from exp_org_unit u where u.unit_id=293
      
      select * from exp_org_unit_v;
      
      select * from hls_lease_org_assign;
      
      
      
SELECT t1.employee_id AS value_code,
       t1.name        AS value_name,
       t1.employee_code,
       t1.position_name,
       (SELECT unit_name FROM exp_org_unit_v WHERE unit_id = t1.unit_id)unit_name
  FROM hls_salesman_v t1
           
  select * from hls_salesman_v;
  select * from exp_employees e where e.employee_code='0414'   ----414
  select * from  hls_salesman_v
select * from exp_employee_assigns e where e.employee_id = 414;
  
          select * from exp_org_unit_v;
          select * from hls_lease_org_assign;
          select * from hls_lease_organization;

   select t1.description_text,t.* from exp_org_unit t,fnd_descriptions t1 where t.description_id=t1.description_id and t.unit_id=294;  --907

 
                    
                    
                    
                    con_contract_pkg.contract_incept(p_contract_id => )
                    ----错误点位  hls_fin_calculator_excel_pkg.excel_if
                     ---- 1  hls_fin_calculator_excel_pkg.excel_if  (execute immediate v_sql using out v_return)
                     ---- 2  hls_fin_calculator_excel_pkg.excel_sum  (v_return := nvl(v_return,0) + nvl(Column_list(c_L||i||'('||j||')').value,0))
                     ---- 3  execute immediate v_sql using out v_return;
                     ---- 4  excel_xnpv(cashflow(n).cashflow_date := to_date(Column_list(c_L||i||'('||j||')').value,'yyyy-mm-dd'))
                     ---- 5  
                     calculate_main
                     hls_fin_calculator_ccr_pkg.create_calculate;
                     gld_common_pkg.get_company_currency_code;
                      hls_fin_calculator_custom_pkg.before_calculate
                     
                     select t.functional_currency_code
    
                      from gld_set_of_books_vl t
                     where t.set_of_books_id =
                           (select c.set_of_books_id
                              from fnd_companies c
                             where c.company_id = 214)
                       and t.enabled_flag = 'Y';
                       
                       select * from hls_fin_calculator_hd;
                       
                       hls_fin_calculator_core_pkg.main;
                       
                       
                       hls_fin_calculator_std_pkg.post_calculate_cashflow;
                       
tre_funds_reservation_pkg;
hls_workflow_pkg;
zj_wfl_workflow_start_pkg;
workflow_assign_check;

-- (独立)单据，如合同、项目等
 --通过工作流实例关联单据和工作流
--(独立)工作流

--工作流包设计流程   
--hls_workflow_pkg.workflow_start
--zj_wfl_workflow_start_pkg.workflow_start

select * from zj_wfl_workflow;   --工作流 (n个工作流节点)
select * from zj_wfl_workflow_node;  --工作流节点
select * from zj_wfl_workflow_assign_action;
select * from zj_wfl_workflow_instance;   --工作流实例

----合同起租工作流  
--(工作流类型参数：CONTRACT_ID、CONTRACT_NUMBER、OWNER_USER_ID}
--(工作流过程定义：起租流程-审批拒绝：hcl_con_incept_wfl_pkg.con_contract_incept_reject(P_CONTRACT_ID,P_USER_ID)、起租流程-审批通过(hcl_con_incept_wfl_pkg.con_contract_incept_approved(P_CONTRACT_ID,P_USER_ID)))
--(工作流页面定义：起租流程审批界面(modules/cont/CON503/con503_contract_incept_wfl.screen),参数：contract_id，contract_number)
--(工作流定义：合同起租工作流 CONTRACT_LEASE_START 节点：开始节点0、普通节点-营业部长审批20(同意/拒绝)、普通节点-合同管理课长审批30(同意/拒绝)、结束节点(结束审批通过-调用之前工作流过程-起租流程-审批通过、审批未通过-调用审批未通过过程))




---融资模块视图

select * from csh_bank_account_v;

select * from tre_loan_contract_;


select * from HLS_DOCUMENT_TYPE;


select t1.document_type,
				       t1.document_type_desc as description,
				       t1.document_category,
				       t1.document_category_desc,
				       t1.business_type,
				       t1.business_type_desc,
				       t1.status_profile,
				       t1.coding_rule,
				       t1.coding_rule_desc,
				       t1.printing_format,
				       t1.printing_format_desc,
				       t1.approval_method,
				       t1.approval_method_desc,
				       t1.ln_starting,
				       t1.ln_step_length,
				       t1.ref_document_type,
				       t1.ref_document_type_desc,
				       t1.enabled_flag,
				       t1.workflow_id,
				       t1.workflow_desc,
				       t1.ref_v01,
				       t1.ref_v02,
				       t1.ref_v03,
				       t1.ref_v04,
				       t1.ref_v05,
				       t1.ref_n01,
				       t1.ref_n02,
				       t1.ref_n03,
				       t1.ref_n04,
				       t1.ref_n05,
				       t1.ref_d01,
				       t1.ref_d02,
				       t1.ref_d03,
				       t1.ref_d04,
				       t1.ref_d05
				  from hls_document_type_v t1;
          
          
          select * from CON_CONTRACT_V;
          
          select * from HLS_DOCUMENT_TYPE;
          
          
          
          select t1.document_type,
				       t1.document_type_desc as description,
				       t1.document_category,
				       t1.document_category_desc,
				       t1.business_type,
				       t1.business_type_desc,
				       t1.status_profile,
				       t1.coding_rule,
				       t1.coding_rule_desc,
				       t1.printing_format,
				       t1.printing_format_desc,
				       t1.approval_method,
				       t1.approval_method_desc,
				       t1.ln_starting,
				       t1.ln_step_length,
				       t1.ref_document_type,
				       t1.ref_document_type_desc,
				       t1.enabled_flag,
				       t1.workflow_id,
				       t1.workflow_desc,
				       t1.ref_v01,
				       t1.ref_v02,
				       t1.ref_v03,
				       t1.ref_v04,
				       t1.ref_v05,
				       t1.ref_n01,
				       t1.ref_n02,
				       t1.ref_n03,
				       t1.ref_n04,
				       t1.ref_n05,
				       t1.ref_d01,
				       t1.ref_d02,
				       t1.ref_d03,
				       t1.ref_d04,
				       t1.ref_d05
				  from hls_document_type_v t1
          where document_category = 'CONTRACT'
          --CON_FOR_BANK  CON_FOR_LOAN   CON_FOR_LEASE
          
          select * from hls_document_type t where t.document_category='CONTRACT' and t.coding_rule='AUTO';
          
          select * from HLS_DOCUMENT_TYPE_V where document_category='CONTRACT';
          
          select * from sys_codes;
          select * from sys_code_values where code_value='CON_FOR_BANK';
---- day 2016/01/07         
          select * from tre_loan_contract;
          select * from tre_loan_contract_lv;
         
          TRE_LOAN_CON_REPAYMENT_PLAN
          select * from hls_bp_master_role;
          drop index TRE_LOAN_CON_REPAYMENT_PLAN_U1 on TRE_LOAN_CON_REPAYMENT_PLAN


          select * from tre_loan_contract_jev;
          
          --商业伙伴录入 hls_bp_master_create
          --商业伙伴维护 hls_bp_master_modify
          
          select * from con_contract_lease_item
          CON_CONTRACT_LEASE_ITEM
          
          select * from CON_CONTRACT_CONTENT;

          select * from hls_bp_master_role;
          select * from tre_loan_contract
          
          select * from tre_loan_contract;

          select * from hls_bp_master_bank_account_lv;

--变更
CON_CHANGE_REQ_CALC_ITFC_PKG.CREATE_CHANGE_REQ

con_contract_history_pkg.create_change_req  

con_contract_pkg.get_contract_rec

con_contract_verify_pkg.contract_verify

con_change_req_custom_pkg.after_create_change_req    

con_change_req_custom_pkg.after_create_change_req

----day 2016/01/08
select 1
        from dual
       where exists (select 1
                       from con_contract_cashflow
                      where contract_id = 34
                        and cf_type in (0,12)
                        and times > 0);
select * from con_contract_cashflow;
con_contract_status_lv

select * from hls_doc_layout_config;

SELECT              p.project_number,
                    p.project_name,
                    pqv.price_list,
                    pqv.price_list_name
                    pqv.contract_seq,
                    pqv.version,
                    hdv.ref_document_type contract_type,
                    hdv.ref_document_type_desc contract_type_desc,
                    pbv.bp_id,
                    pbv.contract_seq bp_contract_seq,
                    pbv.bp_code,
                    pbv.bp_name,
                    pqv.document_id project_id,
                    hfh.billing_method
                    --nanshan_individual_pkg.string_combination(p_sql => 'select t.short_name from prj_project_lease_item t where t.project_id=',p_compare_column_val => p.project_id,p_division_symbol => ',') lease_item,
                    --nanshan_individual_pkg.string_combination(p_sql => 'select t.mortgage_name from prj_project_mortgage t where t.project_id=',p_compare_column_val => p.project_id,p_division_symbol => ',') mortgage,
                    --nanshan_individual_pkg.string_combination(p_sql => 'select t.bp_name from prj_project_bp_v t where t.bp_category=''GUARANTOR'' AND t.project_id=',p_compare_column_val => p.project_id,p_division_symbol => ',') guarantor
                FROM
                    prj_quotation_v pqv,
                    hls_fin_calculator_hd hfh,
                    prj_project_bp_v pbv,
                    hls_document_type_v hdv,
                    prj_project p 
                ORDER BY
                    pqv.contract_seq
                    
select * from prj_project_bp_v;

--增加附件校验   CSH_PAYMENT_REQ_PKG.check_csh_attachment_confirm
CSH_PAYMENT_REQ_PKG.payment_submit

select * from csh_payment_req_hd;payment_req_ln_id  ref_doc_id 
csh_payment_req_hd
CSH_PAYMENT_REQ_LN

select * from CSH_PAYMENT_REQ_DEBT_LN_LV;

select *
      
        from fnd_atm_attachment_multi t
       where t.table_name = 'CON_CONTRACT'
         --and t.table_pk_value = 679
         and exists (select t1.attachment_id
                from fnd_atm_attachment t1
               where t1.attachment_id = t.attachment_id
                 and t1.file_path is not null);


SELECT cc.contract_id,
					       cc.contract_number, --合同编号
					       cc.contract_name, --合同名称
					       cc.project_id,
                           cc.project_id_c,
                           cc.project_id_n,
					       cc.bp_id_vender_n, --供应商
					       li.contract_lease_item_id, --租赁物id
					       li.lease_item_id,
					       li.SHORT_NAME, --租赁物简称
					       li.full_name, --租赁物全称
					       li.take_lease_status,  --是否验收状态
					       (  select v.code_value_name
							    from sys_code_values_v v
							   where v.code = 'TAKE_LEASE_STATUS'
							     and v.code_value = li.take_lease_status
							 ) take_lease_status_desc,
					       li.repeat_lease_flag,  --重复租赁标识
					       li.fh_lease_nameplate,  --丰汇租赁铭牌
					       li.saving_position    --存放位置
					      
					  FROM con_contract_lv cc, con_contract_lease_item li
					  --,csh_payment_req_ln pl
					 WHERE cc.data_class = 'NORMAL'
					   --and cc.contract_id = pl.ref_doc_id
					   AND cc.contract_id = li.contract_id

----立项    
       --信息填写，提交审批1
       hls_document_workflow_pkg.document_submit
       --立项申请 审批 校验
       --校验1 立项时项目经理的正确性  prj_chance_service_mgr_pkg.check_chance_service_manager
             --  获取当前合同信息 con_contract_pkg.get_contract_rec
             --  判断 data_class 数据种类  若 为 CHANGE_REQ (变更申请)则  hls_document_compare_pkg.con_contract_compare   &&   con_contract_history_pkg.submit_change_req
             -- 文档类型判断 document_compare( ? sys_code里没有描述 ? )  hls_doc_layout_config       &&    con_contract_change_req_pkg.submit_con_change_req
                 --  若 为 TARGET  则 target_test_pkg.target_submit
                 --  若 为 CHANCE 
                 
                 
---- day 2016/01/11
select d.description from hls_fin_calculator_hd h, hls_price_list d where h.calc_session_id = calc_session_id and h.price_list = d.price_list;

select * from hls_document_type_v v where v.enabled_flag='Y' and v.document_type in ('PRJ_FOR_BANK','PRJ_FOR_LOAN','PRJ_FOR_LEASE');
--项目创建合同
con_contract_pkg.save_contract_from_project();
--复核  loan_contract_status=LOAN_C_STATUS_020
tre_con_trust_loans.tre_submit_check

tre_loan_contract_lv

select * from tre_loan_contract t where t.loan_contract_id;
--710
select * from TRE_LOAN_CONTRACT_720_LV;
--720
select * from TRE_LOAN_CONTRACT_ALL_LV;

SELECT * FROM TRE_LOAN_CONTRACT_CLOSE_LV

SELECT V.CODE_VALUE_NAME  FROM SYS_CODE_VALUES_V V WHERE V.CODE = 'LOAN_BUSINESS_TYPE' AND 
select * from sys_codes_vl where 
select t.close_type,t.close_date,t.close_reason from tre_loan_contract t where t.loan_contract_number='CON-test-11111'

select close_type,
       (select v.code_value_name
          from sys_code_values_v v
         where v.code = 'LOAN_CON_CLOSE_TYPE'
           and v.code_value = close_type) close_type_n,
       close_date,
       close_reason
  from tre_loan_contract
 where loan_contract_id = '396';

--还款计划
select * from tre_loan_con_repayment_plan;

select * from hls_doc_category_db_object where document_category='INVESTMENT_AND_LOAN';


select first_party,first_party_n from tre_loan_contract_lv;

select second_party,second_party_n from tre_loan_contract_lv group by second_party,second_party_n;


---- day 2016/01/12  
--项目创建合同
con_contract_pkg.save_contract_from_project

select * from prj_project; 

SELECT * FROM PRJ_PROJECT_V;

select * from tre_loan_contract;

select t.contract_status,t.* from con_contract t where t.contract_number='CON201601007';

           
      
con_contract_dun_import_pkg.import_interface

select * from fnd_interface_headers;

--excel导入还款计划
select * from tre_loan_con_repayment_plan;    

REPAYMENT_TYPE --还款项目  sys_code  LOAN_REPAYMENT_TYPE
REPAYMENT_DATE --计划还款日
AMOUNT --还款总额
PRINCIPAL --本金
INTEREST  --利息

select tre_loan_con_repayment_plan_s.nextval header_id from dual;

select * from fnd_interface_headers;

select * from prj_project_v;

select status from fnd_interface_headers where header_id=

select t.search_term_1,t.search_term_2 from PRJ_PROJECT t;

select layout_code id,layout_code code,description from hls_doc_layout where enabled_flag = 'Y' order by layout_code;
select * from hls_bp_type;

select 'TRE_CON' id,'TRE_CON' code, '融资合同' description from dual;
select 'BANK' id,'BANK' code, '银行机构类型' description from dual;
select 'NOT_BANK' id,'NOT_BANK' code, '非银行机构类型' description from dual;
select 'BANK'
select * from 
select v.* from sys_code_values_v v where v.code = 'LOAN_BUSINESS_TYPE' and v.code_value like 'B_%';   --银行
select v.* from sys_code_values_v v where v.code = 'LOAN_BUSINESS_TYPE' and v.code_value like 'NB_%';  --非银行
--机构类型
select v.code_value id,v.code_value code,code_value_name description from sys_code_values_v v where v.code = 'LOAN_PARTY_TYPE';
--业务类型
select v.code_value id,v.code_value code,code_value_name description from sys_code_values_v v where v.code='LOAN_BUSINESS_TYPE';

select * from sys_code_values;

SELECT code_value      id,       code_value      code,       code_value_name description  FROM sys_code_values_v WHERE code = 'HLS211_BP_CLASS'       AND code_value_enabled_flag = 'Y' ORDER BY code_value

SELECT 'BP_PARTNER' id, 'BP_PARTNER' code, '商业伙伴' description
  FROM dual;

SELECT bp_type id, bp_type code, description
  FROM hls_bp_type
 WHERE enabled_flag = 'Y'
 ORDER BY bp_type;

SELECT code_value id, code_value code, code_value_name description
  FROM sys_code_values_v
 WHERE code = 'HLS211_BP_CLASS'
   AND code_value_enabled_flag = 'Y'
 ORDER BY code_value;



--   2016/01/13 
BEGIN
                    sys_condition_layout_pkg.matching_condition( 
                    p_condition_code =>'LA00', 
                    p_company_id =>${/session/@company_id}, 
                    p_role_id =>${/session/@role_id}, 
                    p_user_id =>${/session/@user_id}, 
                    p_function_code =>${/parameter/@function_code}, 
                    p_currency =>${@currency}, 
                    p_lease_org =>${@lease_organization}, 
                    p_lease_channel =>${@lease_channel}, 
                    p_division =>${@division}, 
                    p_business_type =>${@business_type}, 
                    p_document_category =>${@document_category}, 
                    p_document_type =>${@document_type}, 
                    p_bp_class =>${@bp_class}, 
                    p_cond_para1 =>${@cond_para1}, 
                    p_cond_para2 =>${@cond_para2}, 
                    p_cond_para3 =>${@cond_para3}, 
                    p_cond_para4 =>${@cond_para4}, 
                    p_cond_para5 =>${@cond_para5}, 
                    p_layout_code =>${@layout_code},
                   p_bp_category        =>${@bp_category},
                   p_bp_type            =>${@bp_type},
                   p_lease_item_type     =>${@lease_item_type},
                    p_mortgage_type     =>${@mortgage_type},
                   p_mortgage_ast_classfication =>${@mortgage_ast_classfication},
                   p_mortgage_asset_detail   =>${@mortgage_asset_detail},
                   p_bp_type_tenant          =>${@bp_type_tenant},
                   p_bp_type_vender          =>${@bp_type_vender},
                   p_bp_type_guarantor       =>${@bp_type_guarantor},
                   p_workflow                =>${@workflow},
                   p_workflow_node           =>${@workflow_node},
                   p_business_type_2nd       =>${@business_type_2nd},
                   p_document_category_2nd   =>${@document_category_2nd},
                   p_document_type_2nd       =>${@document_type_2nd}
                    );
                END;
                
                
                sys_condition_pkg.insert_condition_matching
                select layout_code id,layout_code code,description from hls_doc_layout where enabled_flag = 'Y' and layout_code like 'TRE_CON%' order by layout_code
                
                select document_category id,document_category code,description from hls_document_category where enabled_flag = 'Y' order by document_category
                select document_type id,document_type code,description from hls_document_type where enabled_flag = 'Y' order by document_type
                
               
        select t1.cf_item,
				       t1.cf_item_desc as description,
				       t1.enabled_flag,
				       t1.cf_type,
				       t1.cf_type_desc,
				       t1.cf_direction,
				       t1.cf_direction_desc,
				       t1.reserved_flag,
				       t1.system_flag,
				       t1.write_off_order,
				       t1.calc_penalty,
				       t1.billing_desc,
               t1.ref_cf_item
				  from hls_cashflow_item_v t1
          
          hls_cashflow_item_v
          
          select * from HLS_CASHFLOW_TYPE_V;
          select * from hls_cashflow_item;
          select * from HLS_CASHFLOW_TYPE;
          
          select * from tre_loan_contract;
          select * from tre_loan_con_repayment_plan
          select * from tre_loan_contract_withdraw;
          select * from sys_code_values_v v where v.code = 'INFLOW';
          
          select * from TRE_LOAN_CONTRACT_ALL_LV;
          select * from tre_loan_con_withdraw_810_lv;
          
          
 -- day 2016/01/14
 
 sys_condition_layout_pkg.matching_condition
 
 tre_loan_contract
 select * from tre_loan_contract;   --- loan_contract_id 532
 select * from tre_loan_contract_withdraw
 select * from tre_loan_con_repayment_plan pp where pp.loan_contract_id=532;
 select * from tre_loan_con_repayment_plan_s.nextval
 --loan_contract_id
---excel导入
 select * from tre_loan_con_re_plan_temp;
 select PAYMENT_PLAN_TEMP_S from dual;
 select * from tre_loan_con_re_plan_temp;
 select * from tre_loan_con_re_plan_temp;
 --1 临时表
 create table tre_loan_con_re_plan_temp(
       session_id                         number,
       repayment_plan_id                  number,
       loan_contract_id                   number,
       contract_id                        number,
       repayment_type                     varchar2(30),   --还款项目
       cashflow_id                        number,
       times                              number,
       rental                             number,
       deposit_date                       date,
       maturity_date                      date, 
       repayment_date                     date,   --计划还款日
       expire_date                        date,
       discount_days                      number,
       amount                             number, --还款总额
       principal                          number, --本金
       interest                           number, --利息
       amount_implicit_rt                 number, 
       factoring_fee                      number, 
       factoring_fee_pv                   number, 
       residue_rental                     number, 
       creation_date                      date, 
       created_by                         number, 
       last_update_date                   date, 
       last_updated_by                    number, 
       ref_v01                            varchar2(2000), 
       ref_v02                            varchar2(2000), 
       ref_v03                            varchar2(2000), 
       ref_v04                            varchar2(2000),
       ref_v05                            varchar2(2000),
       ref_n01                            number, 
       ref_n02                            number,
       ref_n03                            number,
       ref_n04                            number,
       ref_n05                            number,
       ref_d01                            date,
       ref_d02                            date,
       ref_d03                            date,
       ref_d04                            date,
       ref_d05                            date,
       withdraw_id                        number 
 )
 
 hls_lease_item_pkg.import_lease_item_list
 hls_lease_item_pkg.delete_lease_item_list_temp
 hls_lease_item_pkg.ins_lease_item_temp_detail
 
 select * from tre_loan_con_re_plan_temp;
  select * from fnd_interface_headers;
  select * from fnd_interface_lines l where l.header_id=61;
  
  select * from TRE_LOAN_CON_RE_PLAN_TEMP;
  select * from TRE_LOAN_CON_RE_PLAN_TEMP t1 where t1.session_id = 33186 
  
  select v.code_value
    from sys_code_values_vl v
   where v.code_value_name = '本金';
  
  select t.repayment_type_desc,
         (select v.code_value
    from sys_code_values_vl v
   where v.code_value_name = repayment_type_desc)repayment_type,
         t.repayment_date,
         t.amount,
         t.principal,
         t.interest
    from tre_loan_con_re_plan_temp t
            
    select * from tre_loan_con_re_plan_temp;
    
 --租赁物导入逻辑 
 --1.删除租赁物临时表数据  （hls_lease_item_list_temp）hls_lease_item_pkg.delete_lease_item_list_temp
 --2.从系统临时表中获取拨并插入到租赁物临时表中  （系统临时头表：fnd_interface_headers 系统临时行表：fnd_interface_lines） hls_lease_item_pkg.ins_lease_item_temp_detail
 --3.用租赁物临时表展示 ---   
 --4.确定导入：导入到真正的租赁物表   hls_lease_item_pkg.import_lease_item_list
 
 
 hls_lease_item_pkg.import_lease_item_list
 tre_loan_con_rpt_plan_pkg
 tre_loan_con_repayment_pkg.
 
 tre_loan_con_rptp_excel_upload
 delete_imp_rpt_temp   --删除还款计划临时表之前的遗留数据  bm文件名：loan_con_repayment_temp_delete
 insert_imp_rpt_temp   --插入   bm文件名：loan_con_repayment_temp_insert
 
 select * from hls_lease_item_list
 select * from  HLS_LEASE_ITEM_LIST_TEMP;
 
 select * from fnd_interface_headers;
 select * from fnd_interface_lines;
 
 select t1.value_code,t1.value_name
                 from (select e.employee_id as value_code, e.name as value_name
					  from exp_org_unit u, exp_employee_assigns a, exp_employees e
					 where u.unit_id in(7,8,9)
					   and u.chief_position_id = a.position_id
					   and u.company_id = a.company_id
					   and a.employee_id = e.employee_id
					   and a.enabled_flag = 'Y'
					   and e.enabled_flag = 'Y'
					   and u.company_id =241)t1;
             
             
            select * from TRE_LOAN_CONTRACT_ALL_LV
            tre_loan_contract_710_lv
            tre_loan_contract_lv;
            select * from tre_loan_contract;    --528
            select * from tre_loan_contract_withdraw;
            insert into tre_loan_contract_withdraw(withdraw_id,loan_contract_id,withdraw_number,withdraw_date,withdraw_amount,status,reversed_flag,note,c)
            
            
            select * from PRJ_PROJECT_V;   --21 
            prj_project_v
             select * from prj_project_bp;  -- 41
             select * from 
            
            prj_project_pkg.update_prj_project_status
            
            select * from fnd_interface_headers;
            select * from fnd_interface_lines;
            select * from HLS_LEASE_ITEM_LIST;
            
            select t1.value_code,t1.value_name
                 from (select e.employee_code as value_code, e.name as value_name
					  from exp_org_unit u, exp_employee_assigns a, exp_employees e
					 where u.chief_position_id = a.position_id
					   and u.company_id = a.company_id
					   and a.employee_id = e.employee_id
					   and a.enabled_flag = 'Y'
					   and e.enabled_flag = 'Y'
					   and u.company_id = 241)t1
             
             
             select * from 
             
             select l.*
                                  from fnd_interface_lines l
                                 where l.header_id = 48
                                   and l.line_number <> 0
                                 order by l.line_id;
                                 
                                 prj_project_pkg.update_prj_project_status
                                 
                                select * from prj_project;
                                
                                select * from hls_price_list;
                                select * from prj_project;
                                select * from prj_project_v;
                                
            ----项目生成合同  prj_project_create_contract.bm                    
                SELECT p.project_number,
                       p.project_name,
                       pqv.price_list_name        price_list_n,
                       pqv.contract_seq,
                       pqv.version,
                       hdv.ref_document_type      contract_type,
                       hdv.ref_document_type_desc contract_type_desc,
                       pbv.bp_id,
                       pbv.contract_seq           bp_contract_seq,
                       pbv.bp_code,
                       pbv.bp_name,
                       pqv.document_id            project_id,
                       hfh.billing_method,
                       p.document_type
                --nanshan_individual_pkg.string_combination(p_sql => 'select t.short_name from prj_project_lease_item t where t.project_id=',p_compare_column_val => p.project_id,p_division_symbol => ',') lease_item,
                --nanshan_individual_pkg.string_combination(p_sql => 'select t.mortgage_name from prj_project_mortgage t where t.project_id=',p_compare_column_val => p.project_id,p_division_symbol => ',') mortgage,
                --nanshan_individual_pkg.string_combination(p_sql => 'select t.bp_name from prj_project_bp_v t where t.bp_category=''GUARANTOR'' AND t.project_id=',p_compare_column_val => p.project_id,p_division_symbol => ',') guarantor
                  FROM prj_quotation_v       pqv,
                       hls_fin_calculator_hd hfh,
                       prj_project_bp_v      pbv,
                       hls_document_type_v   hdv,
                       prj_project           p
                 where pqv.document_category = 'PROJECT'
                   AND hfh.calc_session_id = pqv.calc_session_id
                   AND pbv.project_id(+) = pqv.document_id
                   AND pbv.bp_category(+) = 'TENANT'
                   --AND pbv.contract_seq(+) = pqv.contract_seq
                   --and pqv.document_id = 541
                   --and pqv.quotation_type = 'MAJOR'
                   and pqv.enabled_flag = 'Y'
                   AND p.project_id = pqv.document_id
                   and hdv.document_type(+) =
                      decode(p.document_type,
                             'CHANNEL_PRJ',
                             'PRJLB',
                             p.document_type)
                   and nvl(pqv.create_contract_flag, 'N') = 'N'
                   and nvl(p.execute_approve_status,'APPROVING')='APPROVED';
                 
                  select * from prj_project_bp_v v where v.project_id = 541;
                  execute_approve_status 
                  select * from prj_project_v;
                
                select * from CON_CONTRACT_V;
                select v.* from prj_project_bp v where v.project_id = 541;
                select * from prj_project_bp_v v where v.project_id = 536;
                
                select p.document_type from prj_project p where p.project_id =541;
                select * from tre_loan_con_repayment_plan;
                
                select * from prj_project ;
                
                
                select sum(1)
     --into v_calc_session_num
       from hls_fin_calculator_hd hfch
      where hfch.calc_successful = 'Y'
        and hfch.calc_session_id in
            (select t.calc_session_id
               from prj_quotation t
              where t.document_category = 'PROJECT'
                and t.document_id = 513
                and nvl(t.create_contract_flag, 'N') != 'Y')
                
                select t.*
               from prj_quotation t
              where t.document_category = 'PROJECT'
                and t.document_id = 513
                and nvl(t.create_contract_flag, 'N') != 'Y'
                
                
                select * from fnd_interface_lines l where l.header_id=51;
                select * from fnd_interface_headers;
                
                ---day  2016/01/15
                
                select * from prj_project;
select * from prj_quotation pq where pq.document_category='PROJECT' AND PQ.DOCUMENT_ID=541;  -- calc_session_id  299  300
select * from hls_fin_calculator_hd ch where ch.calc_session_id in (299,300);
select * from hls_fin_calculator_ln cl where cl.calc_session_id in (299,300);

hls_fin_calculator_itfc_pkg.calculate

hls_fin_calculator_std_pkg.post_calculate_cashflow

con_contract_pkg

hls_fin_calculator_std_pkg.post_calculate_cashflow

hls_fin_calculator_core_pkg.main;

PRJ_PROJECT_PKG
select * from prj_project p where p.project_id=541;

prj_project_pkg.update_prj_project_status;

 select sum(1)
   
      from hls_fin_calculator_hd hfch
     where hfch.calc_successful = 'Y'
     and hfch.calc_session_id in
           (select pq.calc_session_id
              from prj_quotation pq
             where pq.document_category = 'PROJECT'
               and pq.document_id = 541)
               
               select * from hls_fin_calculator_hd;
               select * from hls_fin_calculator_ln;
               
               select * from prj_quotation;
               
     select sum(1)
     into v_calc_session_num
       from hls_fin_calculator_hd hfch
      where hfch.calc_successful = 'Y'
        and hfch.calc_session_id in
            (select t.calc_session_id
               from prj_quotation t
              where t.document_category = 'PROJECT'
                and t.document_id = 541
                and nvl(t.create_contract_flag, 'N') != 'Y')
                
                
                select * from prj_quotation t where t.document_category = 'PROJECT'
                and t.document_id = 536;
                prj_project
                
                SELECT bp_id
        --INTO v_bp_id_tenant
        FROM prj_project_bp
       WHERE project_id = 541
             AND bp_category = 'TENANT'
             AND bp_id IS NOT NULL
             AND contract_seq = 1;
             
              SELECT taxpayer_type INTO v_taxpayer_type FROM hls_bp_master WHERE bp_id = v_bp_id_tenant;
              
              
---day 2016/01/18
--在页面添加过滤条件 - execute_approve_status = 'APPROVED' 
--在包 con_contract_pkg 中创建合同加 execute_approve_status的校验
select * from prj_project_v;
select * from prj_project 


con_contract_pkg
              
--提款编码
select * from tre_loan_contract; number_times 
select * from tre_loan_contract_withdraw;
select * from TRE_LOAN_CON_WITHDRAW_ALL_LV;
select * from tre_loan_con_withdraw_810_lv;
select * from tre_loan_con_withdraw_detail;
select sum(1)
     -- into v_withdraw_number
      from tre_loan_contract_withdraw t
     where t.loan_contract_id = 528
       and t.withdraw_number like 'testtt' || '%';
       
       select t1.* FROM TRE_LOAN_CONTRACT_WITHDRAW T1,tre_loan_contract_all_lv tc
  WHERE t1.loan_contract_id=tc.loan_contract_id AND t1.status IN ('LOAN_CW_STATUS_01','LOAN_CW_STATUS_02');   -- status ??
        select * from tre_loan_contract_all_lv;  -- 528
        select * from TRE_LOAN_CONTRACT_WITHDRAW;   --  526 
              
        
        select *
     --into v_withdraw_number
      from tre_loan_contract_withdraw t
     where t.loan_contract_id = 528
       --and t.withdraw_number like 'testttt' || '%';

  
select * from TRE_LOAN_CONTRACT_820S_LV
SELECT * FROM TRE_LOAN_CONTRACT_WITHDRAW;
tre
select * from tre_loan_con_withdraw_810_lv
select * from tre_loan_con_withdraw_all_lv
select * from tre_loan_con_rpp_ni_v;
select * from TRE_LOAN_CON_RPP_NI_V;

HLS_DOC_CATEGORY_DB_OBJECT

    		tre_loan_con_withdraw_810_lv
        tre_loan_con_withdraw_811_lv
        HLS_DOC_CATEGORY_DB_OBJECT
        select * from tre_loan_contract_withdraw;
        select * from TRE_LOAN_CON_WITHDRAW_840_LV;
        select * from TRE_LOAN_CONTRACT_REPAYMENT;
select * from TRE_LOAN_CONTRACT_WITHDRAW;-- 712   --712
select * from tre_loan_contract_withdraw t where t.withdraw_id = 654
select * from tre_loan_con_repayment_plan p where p.loan_contract_id=712;
select * from tre_loan_con_repayment_plan t where t.loan_contract_id=713 and t.withdraw_id is null
select * from TRE_LOAN_CON_RPP_NI_V p where p.loan_contract_id=713;


select t.confirm_flag from con_contract t where t.contract_number = 'CON201601025' T WHERE T.LOAN_CONTRACT_ID=696;

select t.withdraw_id  from TRE_LOAN_CONTRACT_WITHDRAW t where t.loan_contract_id = p_loan_contract_id and t.withdraw_number = p_withdraw_number;

SELECT V.CODE_VALUE AS VALUE_CODE, V.CODE_VALUE_NAME AS VALUE_NAME
  FROM SYS_CODE_VALUES_V V
 WHERE V.CODE = 'LOAN_REPAYMENT_TYPE'
   AND V.CODE_ENABLED_FLAG = 'Y'
   AND V.CODE_VALUE_ENABLED_FLAG = 'Y'
   ORDER BY v.order_seq 
   ---- day 2016/01/20
   select * from tre_loan_con_repayment_plan t1 where t1.loan_contract_id = 528 
   select * from tre_loan_con_repayment_plan t where t.loan_contract_id= 615
   tre_loan_con_repayment_plan_s;
   --loan_contract_id:615  withdraw_id:589  
   
   con_contract_lease_item_detail.save_before_validate;
   con_contract_li_detail_pkg;
   
   CSH_PAYMENT_REQ_PKG.payment_submit
   
   HLS_LEASE_ITEM_LIST_PK;
   HLS_LEASE_ITEM_PKG;
   --包名加后缀
   tre_loan_con_rptp_upload_pkg   
   tre_loan_con_rptp_excel_upload;
   tre_con_trust_loans;
   tre_con_trust_loans_pkg
   select * from tre_loan_contract_withdraw;  -- 712 709
   select * from tre_loan_contract_withdraw;
   --还款 
   select * from tre_loan_contract_repayment; 
   select * from nvl(select t.withdraw_id from TRE_LOAN_CONTRACT_WITHDRAW t where t.loan_contract_id = 712 and t.withdraw_number = 'BANK_FACTORING-11',-1) t;
   
   select * from HLS_COMPANY_SEAL_DEFINE;
   
select * from  
(SELECT t1.DEFINE_ID,
       t1.SEAL_CODE,
       t1.SEAL_DESC,
       t1.COMPANY_ID,
       c.company_full_name,
       t1.ALLOW_BORROW_FLAG,
       t1.BORROW_FLAG,
       t1.BROKEN_FLAG,
       t1.ENABLED_FLAG
  FROM HLS_COMPANY_SEAL_DEFINE t1, fnd_companies c
  where t1.company_id = c.company_id)
  #

----
(select company_full_name
          from fnd_companies
         where company_id = company_id) AS company_desc,
         
         
---- excel上传
tre_loan_con_rptp_upload_pkg.import_imp_rpt_temp;


tre_con_trust_loans_pkg;

tre_loan_con_repayment_pkg;
tre_loan_con_rptp_upload_pkg;

select v.code_value,v.code_value_name,v.*
      from sys_code_values_vl v
     where v.code_value_name in ('利息','本金','还本付息','发行费','手续费','委贷费','保证金');

select * from sys_code_values_v v where v.code = 'LOAN_REPAYMENT_TYPE';

select v.code_value,v.code_value_name,v.*
      --into v_repayment_type
      from sys_code_values_v v
     where v.code = 'LOAN_REPAYMENT_TYPE'
     and   v.code_value_name in ('利息','本金','还本付息','发行费','手续费','委贷费','保证金');
     
     
---- 付款申请先决条件
select * from prj_project_pay_condition;  -- 741
select *
                     from prj_project_pay_condition t
                    where t.project_id = 741
                    select * from con_contract t where t.project_id = 741;


--付款条件确认
CSH_PAYMENT_REQ_PKG.check_csh_attachment_confirm
--选择付款合同确定校验
CSH_PAYMENT_REQ_PKG.check_con_payment_confirm


select t.project_id,t.* from con_contract t where t.contract_number='KJZLA2015-005'   --238
select *
                     from prj_project_pay_condition t
                    where t.project_id = 238
 SELECT
                    *
                FROM
                    (SELECT cc.contract_id,
					       cc.contract_number, --合同编号
					       cc.contract_name, --合同名称
					       cc.project_id,
                           cc.project_id_c,
                           cc.project_id_n,
					       cc.bp_id_vender_n, --供应商
					       li.contract_lease_item_id, --租赁物id
					       li.lease_item_id,
					       li.SHORT_NAME, --租赁物简称
					       li.full_name, --租赁物全称
					       li.take_lease_status,  --是否验收状态
					       (  select v.code_value_name
							    from sys_code_values_v v
							   where v.code = 'TAKE_LEASE_STATUS'
							     and v.code_value = li.take_lease_status
							 ) take_lease_status_desc,
					       li.repeat_lease_flag,  --重复租赁标识
					       li.fh_lease_nameplate,  --丰汇租赁铭牌
					       li.saving_position    --存放位置
					       --,pl.payment_req_ln_id
					  FROM con_contract_lv cc, con_contract_lease_item li
					  --,csh_payment_req_ln pl
					 WHERE cc.data_class = 'NORMAL'
					   --and cc.contract_id = pl.ref_doc_id
					   AND cc.contract_id = li.contract_id
					   --AND cc.contract_id = ${@contract_id}
                    ) cc;
                 
             select v. from con_contract_lv v;
             select * from csh_payment_req_hd h where h.payment_req_id = 762;  --approval_status
             
             select * from sys_user;
             
             --功能表
             select * from sys_function;
             select * from csh_transaction;
             
             --付款提交审批
             CSH_PAYMENT_REQ_PKG.payment_submit
             --1.租赁物附件校验   e_con_payment_attachment_err
             --2.锁定 csh_payment_req_hd
             --3.判断是否重复提交   e_status_error
             --4.行表支付总金额判断 （csh_payment_req_amount_check） 本次申请支付金额与已申请支付金额之和大于剩余未支付金额
             --5.判断预付款现金事物id校验
             --6.判断审批方式 （是否走工作流：） select approval_method into v_approval_method from hls_document_type  where document_category = v_csh_payment_req_hd_rec.document_category and document_type = v_csh_payment_req_hd_rec.document_type;  if v_approval_method = 'WORK_FLOW' then SELECT t.attachment_number FROM prj_project_pay_condition t where t.condition_id;
             --7.修改审批状态、提交状态
             
             select * from csh_payment_req_hd;
             
             select * from 
--登录  （不同ip可登录，同ip不可重复登录）
hls_sys_session_pkg.get_session_info
sys_login_pkg.role_select
select * from sys_user_logins;
sys_session_pkg.create_session
select * from sys_role; --角色
select * from sys_user;

SELECT v.code_value AS value_code, v.code_value_name AS value_name
  FROM sys_code_values_v v
 WHERE v.code = 'PRJ400_CHANCE_STATUS'
   AND v.code_enabled_flag = 'Y'
   AND v.code_value_enabled_flag = 'Y'
   
   select * from csh_payment_req_hd;   submitted_flag
   
   select v.code_value_name
          from sys_code_values_v v
         where v.code = 'PRJ400_CHANCE_STATUS'
           and v.code_value = 'NEW'
con_contract

con_contract_pkg.save_contract_from_project


      SELECT *
       -- INTO v_bp_id_tenant
        FROM prj_project_bp
       WHERE project_id = 766
             AND bp_category = 'TENANT'
             AND bp_id IS NOT NULL
             AND bp_seq = p_contract_seq;
             
             AND bp_seq = 1;
             
             select t.number_of_tenant,t.* from prj_project t where t.project_id=766;
             
             select * from prj_project_bp t where t.project_id = 766;
             
             select * from prj_project_bp_lv;
             SELECT DESCRIPTION FROM hls_bp_category WHERE bp_category = 'TENANT';
             
             select * from tre_loan_contract t where t.loan_contract_id = 853;
             CSH_PAYMENT_REQ_PKG.check_csh_attachment_confirm
             
             select * from prj_project_pay_condition;

             select nvl(ppc.confirm_flag,'N')
                            from prj_project_pay_condition ppc
                           where ppc.project_id = 638
                             and nvl(ppc.confirm_flag,'N') = 'N'
                             group by ppc.confirm_flag
              select t.project_id from con_contract t where t.contract_number = 'CON201601035';  --638
              
              
-- day 2016/01/26
select * from tre_loan_con_repayment_plan;
select * from tre_loan_con_rpp_ni_v
tre_loan_con_repayment_pkg.tre_loan_con_repayment_submit;
hls_company_seal_apply_pkg.submit_seal_apply;

select * from fnd_atm_attachment_multi;
select * from fnd_atm_attachment;

--还款
select * from tre_loan_con_repayment_plan;
select * from tre_loan_con_rpp_issue_v;

select * from tre_loan_contract_all_lv;
select * from tre_loan_contract;
HLS_DOC_CATEGORY_DB_OBJECT


---合同起租  
con_contract_incept_apply_pkg.workflow_start


--项目创建合同
select v.project_status,v.* from PRJ_PROJECT_V v where v.project_number = 'PRJ2016000025';     --PRJ2016000025    638

select c.project_id,c.* from con_contract c where c.contract_number = 'CON201601035'

select * from prj_project p where p.project_number = 'PRJ2016000025';
select * from sys_user v where v.user_id = 1528

con_contract_pkg.save_contract_from_project

--报价
select * from hls_fin_calculator_hd h;
select * from hls_fin_calculator_ln l;

select * from prj_quotation_v;
select * from hls_fin_calculator_hd;
select * from prj_project_bp_v;
select * from hls_document_type_v;
select * from prj_project;

SELECT
                	p.project_number,
                    p.project_name,
                    pqv.price_list_name price_list_n,
                    pqv.contract_seq,
                    pqv.version,
                    hdv.ref_document_type contract_type,
                    hdv.ref_document_type_desc contract_type_desc,
                    pbv.bp_id,
                    pbv.contract_seq bp_contract_seq,
                    pbv.bp_code,
                    pbv.bp_name,
                    pqv.document_id project_id,
                    hfh.billing_method,
                    pqv.document_category,
                    pqv.calc_session_id,
                    nanshan_individual_pkg.string_combination(p_sql => 'select t.short_name from prj_project_lease_item t where t.project_id=',p_compare_column_val => p.project_id,p_division_symbol => ',') lease_item,
                    nanshan_individual_pkg.string_combination(p_sql => 'select t.mortgage_name from prj_project_mortgage t where t.project_id=',p_compare_column_val => p.project_id,p_division_symbol => ',') mortgage,
                    nanshan_individual_pkg.string_combination(p_sql => 'select t.bp_name from prj_project_bp_v t where t.bp_category=''GUARANTOR'' AND t.project_id=',p_compare_column_val => p.project_id,p_division_symbol => ',') guarantor
                FROM
                    prj_quotation_v pqv,
                    hls_fin_calculator_hd hfh,
                    prj_project_bp_v pbv,
                    hls_document_type_v hdv,
                    prj_project p 
                where p.project_id = 638
                and pqv.document_category ='PROJECT'
                and hfh.calc_session_id = pqv.calc_session_id
                and pbv.project_id(+)=pqv.document_id
                and pbv.bp_category(+) = 'TENANT'
                and pqv.document_id = 638
                --and pqv.enabled_flag = 'Y'
                and p.project_id = pqv.document_id
                and hdv.document_type(+) = decode(p.document_type,'CHANNEL_PRJ','PRJLB',p.document_type)
                and nvl(pqv.create_contract_flag,'N')='N'
                ORDER BY
                    pqv.contract_seq


select * from PRJ_PROJECT_V v where v.execute_approve_status = 'APPROVED' and v.project_status in('APPROVED','APPROVED_SECOND','CONTRACT_CREATED')



 select sum(1)
     --into v_calc_session_num
       from hls_fin_calculator_hd hfch
      where hfch.calc_successful = 'Y'
        and hfch.calc_session_id in
            (select t.calc_session_id
               from prj_quotation t
              where t.document_category = 'PROJECT'
                and t.document_id = 638
                and t.enabled_flag = 'Y'
                and nvl(t.create_contract_flag, 'N') != 'Y');
                
                
                select * from sys_user;
                
                select * from hls_bp_master;
                
                
--- day 2016/01/27
--校验  金额>0
CSH_PAYMENT_REQ_PKG.payment_submit;
select * from csh_payment_req_ln;

CSH_PAYMENT_REQ_PKG.del_csh_payment_req_hd
tre_loan_con_withdraw_pkg.insert_withdraw

tre_con_trust_loans_pkg.tre_submit_check

select * into v_withdraw_id from daul where exit
    (select t.withdraw_id
      from TRE_LOAN_CONTRACT_WITHDRAW t
     where t.loan_contract_id

select * from TRE_LOAN_CONTRACT_WITHDRAW t;



SELECT COUNT(C.CONTENT_ID)
    --  INTO V_COUNT_CONTENT
      FROM CON_CONTRACT_CONTENT C
     WHERE CONTRACT_ID in
           (SELECT C.CONTRACT_ID
              FROM CON_CONTRACT C
             WHERE C.CONTRACT_NUMBER = 'KJZLA2015-003');
             
             
                 SELECT COUNT(DISTINCT F.TABLE_PK_VALUE)
      --INTO V_COUNT_NUMBER
      FROM FND_ATM_ATTACHMENT_MULTI F
     WHERE F.TABLE_NAME = 'CON_CONTRACT_CONTENT_1'
       AND F.TABLE_PK_VALUE IN
           (SELECT C.CONTENT_ID
              FROM CON_CONTRACT_CONTENT C
             WHERE CONTRACT_ID in
                   (SELECT C.CONTRACT_ID
                      FROM CON_CONTRACT C
                     WHERE C.CONTRACT_NUMBER = 'KJZLA2015-003'));
                     
                     
                     tre_funds_reservation_pkg.submit_tre_reservation
                     
                     
                     select * from tre_loan_con_repayment_plan;
--- day  2016/01/29                
  select
       t1.repayment_plan_id,
       t1.loan_contract_id,
       t1.repayment_type,
       (SELECT V.CODE_VALUE_NAME   FROM SYS_CODE_VALUES_V V WHERE V.CODE = 'LOAN_REPAYMENT_TYPE' AND v.code_value=t1.repayment_type)repayment_type_n,
       t1.amount,
       t1.repayment_date,
       t1.principal,
       t1.interest,
       t1.withdraw_id
  from tre_loan_con_repayment_plan t1
                     select * from TRE_LOAN_CON_REPAYMENT_PLAN t1 #WHERE_CLAUSE#
                     
                     tre_con_trust_loans_pkg.tre_submit_check
                     
                     
                     select * from tre_loan_contract t where t.loan_contract_id = 953
                     
                     select * from tre_loan_contract t where t.loan_contract_id = 984
                     
                     tre_con_trust_loans_pkg.tre_submit_check;
                     
                     select * from TRE_LOAN_CON_REPAYMENT_ALL_LV;
                     select * from TRE_LOAN_CON_RPP_ALL_LV
                     
                     SELECT RPP.REPAYMENT_PLAN_ID,
       RPP.LOAN_CONTRACT_ID,
     ${@withdraw_id}  withdraw_id,
       RPP.REPAYMENT_TYPE,
       RPP.REPAYMENT_TYPE_N,
       RPP.REPAYMENT_DATE,
       RPP.AMOUNT
  FROM TRE_LOAN_CON_RPP_ALL_LV RPP
WHERE RPP.loan_contract_id=${@loan_contract_id}

TRE_LOAN_CONTRACT_ALL_LV;

HLS_DOC_CATEGORY_DB_OBJECT

select * from tre_loan_con_custody_af_lv;  -- 保管户账户资金
select * from tre_loan_con_custody_cf_lv;  -- 保管户理财
select * from tre_loan_con_custody_sf_lv;  -- 保管户保证基金
tre_loan_con_
select * from tre_loan_con_other_funds;  -- 980  979
select * from tre_loan_contract t where t.loan_contract_id = 979;

select * from PRJ_PROJECT_APPROVAL;


select * from
          	(select t1.reservation_id, 
          		   t1.contract_id,
			       (select c.contract_name
			          from con_contract c
			         where c.contract_id = t1.contract_id) contract_name,
			       t1.contract_number,
			       t1.contract_number contract_number_desc,
			       t1.reservation_person_id,
			       (select s.description
			          from sys_user s
			         where s.user_id = t1.reservation_person_id) reservation_person_desc,
			       t1.reservation_unit_id,
			       (select fd.description_text
			          from exp_org_unit u,fnd_descriptions fd
			         where u.unit_id = t1.reservation_unit_id
               		   and u.description_id=fd.description_id
               		   and fd.language='ZHS') reservation_unit_desc,
			       t1.reservation_type,
			       (select c1.code_value_name
			          from sys_code_values_v c1
			         where c1.code = 'RESERVATION_TYPE'
			           and c1.code_value = t1.reservation_type) as reservation_type_desc,
			       t1.reserve_amount,
			       t1.reservation_date,
			       t1.reservation_date reservation_date_from,
			       t1.reservation_date reservation_date_to,
			       t1.bank_account_id,
			       (select csh.bank_account_name
			          from csh_bank_account csh
			         where csh.bank_account_id = t1.bank_account_id) bank_account_name_desc,
			       (select csh.bank_account_num
			          from csh_bank_account csh
			         where csh.bank_account_id = t1.bank_account_id) bank_account_desc,
			       (select csh.bank_account_code
			          from csh_bank_account csh
			         where csh.bank_account_id = t1.bank_account_id) bank_account_code,
			       t1.bank_branch_id,
			       (select cbb.bank_branch_name
			          from csh_bank_branch cbb
			         where cbb.bank_branch_id = t1.bank_branch_id) bank_branch_desc,
               (select cbb.bank_branch_code
			            from csh_bank_branch cbb
			           where cbb.bank_branch_id =t1.bank_branch_id) bank_branch_code,
			       nvl(t1.status,'NOT')status,
             	   decode(nvl(t1.status,'NOT'),'NOT','新建','RESERVING','提交','RESERVED','已预约','RETURN','退回')status_desc,
             	   t1.paid_date_fin,
			       t1.confirm_status,
			       (select c2.code_value_name
			          from sys_code_values_v c2
			         where c2.code = 'RESERVATION_CONFIRM_STATUS'
			           and c2.code_value = t1.confirm_status) as confirm_status_desc,
			       t1.apply_remarks,
			       t1.description_fin,
			       t1.paid_date,
			       t1.paid_probability
			  from tre_funds_reservation t1
			  where t1.reservation_person_id = 1
			  ) t


select * from tre_loan_con_rpp_issue_v;   --amount、


select * from tre_loan_con_repayment_plan; 


tre_loan_con_rptp_upload_pkg.import_imp_rpt_temp

select * from tre_loan_con_withdraw_810_lv;
select * from tre_loan_con_withdraw_820_lv;
select * from TRE_LOAN_CON_WITHDRAW_ALL_LV;


select * from tre_loan_con_rpp_issue_v;

select * from tre_loan_contract;


tre_loan_con_rptp_upload_pkg.import_imp_rpt_temp

select * from TRE_FUNDS_RESERVATION

select * from aut_trx_user_authorize;

select * from tre_loan_con_withdraw_840_lv;
select * from tre_loan_contract_repayment;
select * from tre_loan_con_repayment_plan;   -- withdraw_id  repayment_plan_id   repayment_id 
tre_loan_con_repayment_pkg.tre_loan_con_repayment_submit;

 select * from tre_loan_con_repayment_plan t where t.withdraw_id = 792;
 --实际还款表
 select * from tre_loan_contract_repayment;   --720(4)  578(3) 535   
 --还款计划表 (带withdraw_id的为提款下的还款计划)
 select * from tre_loan_con_repayment_plan t where t.withdraw_id = 805;
 select * from tre_loan_con_repayment_plan t where t.repayment_plan_id = 578;  --805
 
select * from tre_loan_con_repayment_plan t where t.withdraw_id = 792;

 select * from tre_loan_contract_repayment t,tre_loan_con_repayment_plan tp where t.repayment_plan_id = tp.repayment_plan_id and tp.withdraw_id = 792;
 
select * from TRE_LOAN_CON_WITHDRAW_840_LV;

select * from tre_loan_con_repayment_860_lv;
select * from tre_loan_con_repayment_850_lv;
select * from tre_loan_contract_repayment;
Tre_Loan_Con_Withdraw_840_Lv
tre_loan_contract_all_lv

select * from prj_chance_service_managers;
select * from prj_chance_service_managers_lv;
select c.
             		from con_contract c,prj_project p,prj_chance_service_managers_lv pc
            	 where data_class = 'NORMAL'
                 and c.project_id = p.project_id
                 and p.chance_id = pc.chance_id
                 and pc.user_id
                 
                 
                 
                 select t.repayment_id,t.status
                  from tre_loan_contract_repayment t, tre_loan_con_repayment_plan tp
                  where t.repayment_plan_id = tp.repayment_plan_id
                  and tp.withdraw_id = 805
                  and t.status in ('LOAN_CRP_STATUS_01','LOAN_CRP_STATUS_02')
                  
      
      select * from tre_loan_contract_repayment;
      
      select t.repayment_id
       --into v_repayment_id
       from tre_loan_contract_repayment t, tre_loan_con_repayment_plan tp
      where t.repayment_plan_id = tp.repayment_plan_id
        and tp.withdraw_id = 805;
        
        select * from  
  
      
      select * from TRE_LOAN_CON_OTHER_FUNDS;
      select * from prj_project;
      
      
      
      select * from tre_loan_contract_lv;
      
      select * from tre_loan_con_rpp_issue_v t where t.loan_contract_id = 1118;
      SELECT t1.REPAYMENT_PLAN_ID,t1.LOAN_CONTRACT_ID,t1.REPAYMENT_TYPE,t1.AMOUNT,t1.REPAYMENT_DATE,t1.REF_V01,t1.REF_V02,t1.REF_N01,t1.REF_N02
FROM tre_loan_con_rpp_ni_v t1
WHERE loan_contract_id=1118 AND LOAN_CONTRACT_ID = 1118


SELECT
                    d.column_name,
                    d.grid_order_seq,
                    NVL(d.grid_order_type, 'ASCENDING') grid_order_type,
                    d.data_type
                FROM
                    hls_doc_layout_config d
                WHERE
                    d.layout_code     = 'TRE_CON_NB_TRUST_LOANS_FH1' AND
                    d.tab_code        = 'G_ISSUE_FEE_INFO' AND
                    d.grid_order_seq IS NOT NULL AND
                    d.enabled_flag    = 'Y'
                ORDER BY
                    d.grid_order_seq
                    
            
      select t1.base_table_pk query_field1,
    				(select distinct base_table_pk
		             from hls_doc_layout_tab d
		            where d.layout_code = t1.layout_code
		              and d.base_table = t1.parent_table) query_field2
			  from hls_doc_layout_tab t1
			   WHERE t1.layout_code='TRE_CON_NB_TRUST_LOANS_FH1' AND t1.tab_code = 'G_ISSUE_FEE_INFO' AND t1.enabled_flag='Y'
    	 
      principal interest 
      select * from tre_loan_con_repayment_860_lv;
      delete from tre_loan_contract t where t.loan_contract_number like 'test%';
      select * from tre_loan_con_repayment_plan;
      
      SELECT rpp.withdraw_id FROM  tre_loan_con_repayment_plan rpp WHERE rpp.repayment_plan_id IN (
      SELECT rp.repayment_plan_id from TRE_LOAN_CONTRACT_REPAYMENT rp WHERE rp.status='LOAN_CRP_STATUS_03'
      )
      
      select * from TRE_LOAN_CON_REPAYMENT_ALL_LV;
      select * from tre_loan_contract t where t.loan_contract_number = 'QY-20160130';
      select * from sys_user;
      select * from TRE_LOAN_CON_RE_PLAN_TEMP;
      
      tre_loan_con_rptp_upload_pkg.insert_imp_rpt_temp
      
      tre_loan_con_repayment_pkg.tre_loan_con_repayment_submit
      
      tre_loan_con_repayment_pkg
      
      tre_loan_con_withdraw_pkg
      
      
      tre_con_trust_loans_pkg.tre_submit_check
      
      select * from tre_loan_con_repayment_plan t where t.repayment_type = 'ISSUE_FEE' and t.withdraw_id is null;
      
       == 
           select t.amount,t.principal     
      from tre_loan_con_repayment_plan t
      where 
         t.repayment_type = 'CAPITAL';
         
         select t.net_finance_amount from tre_loan_contract t where t.loan_contract_number = '111'
         
         
         tre_loan_con_withdraw_pkg.submit_withdraw
         
         select * from tre_loan_contract_withdraw;
         select * from tre_loan_con_repayment_plan;
         
         
         tre_loan_con_repayment_pkg.tre_loan_con_repayment_submit
         
         select * from tre_loan_contract_repayment;
         
         select * from tre_loan_con_repayment_plan;
         
         select * from sys_user;
         
         
         select * from CON_CONTRACT_CASHFLOW_V t where t.cf_status='RELEASE'   and t.write_off_flag !='FULL'    and t.due_amount !=0 and t.contract_number = 'CON201601031' and t.cf_type = 1 and t.cf_direction='INFLOW' and t.contract_writeoff_status='Y' and t. ;
         
select *
  from CON_CONTRACT_CASHFLOW_V t
 WHERE t.cf_status = 'RELEASE'
   and t.write_off_flag != 'FULL'
   and t.due_amount != 0
   AND CF_DIRECTION = 'INFLOW'
   AND t.contract_number = 'CON201601044'
   --AND due_date <= to_date(?, 'yyyy-mm-dd')
   AND t.write_off_flag != 'FULL'
   AND t.cf_type != 0
   AND ('Y' = 'Y' and t.contract_status not in ('NEW', 'PENDING'))
   AND CURRENCY = 'CNY'
   AND t.cf_type = 1
     
   
   select t.contract_status,t.* from con_contract t where t.contract_number='CON201601045'
   
   select *
  from con_contract          t,
       con_contract_cashflow ca,
       prj_project           p,
       hls_bp_master         b,
       hls_cashflow_type     ct,
       hls_cashflow_item     ci
 where t.contract_id = ca.contract_id
   and t.project_id = p.project_id
   and t.bp_id_tenant = b.bp_id
   and ca.cf_type = ct.cf_type
   and ca.cf_item = ci.cf_item
  /* and t.data_class = 'NORMAL'
   and ca.cf_direction='OUTFLOW'
   and ca.cf_status = 'RELEASE'
   and ca.write_off_flag!='FULL'
   and t.contract_status = 'INCEPT'*/
   and ca.cf_item in (52)
   and t.contract_number = 'CON201601045';
   
   
     
     
SELECT t1.CONTRACT_ID,
       t1.CONTRACT_NUMBER,
       t1.CONTRACT_STATUS,
       t1.CURRENCY,
       t1.DOCUMENT_CATEGORY,
       t1.PROJECT_ID,
       t1.BP_ID_TENANT,
       t1.PROJECT_NUMBER,
       t1.PROJECT_NAME,
       t1.BP_CODE,
       t1.BP_NAME,
       t1.CASHFLOW_ID,
       t1.CF_ITEM,
       t1.CF_ITEM_NAME,
       t1.CF_TYPE,
       t1.CF_TYPE_NAME,
       t1.CF_DIRECTION,
       t1.CF_STATUS,
       t1.TIMES,
       t1.DUE_DATE,
       t1.DUE_AMOUNT,
       t1.PRINCIPAL,
       t1.INTEREST,
       t1.DUE_AMOUNT_CNY,
       t1.PRINCIPAL_CNY,
       t1.INTEREST_CNY,
       t1.PENALTY,
       t1.PENALTY_CASHFLOW_ID,
       t1.OUTSTANDING_RENTAL,
       t1.OUTSTANDING_PRINCIPAL,
       t1.OUTSTANDING_INTEREST,
       t1.INTEREST_ACCRUAL_BALANCE,
       t1.PRINCIPAL_IMPLICIT_RATE,
       t1.INTEREST_IMPLICIT_RATE,
       t1.VAT_DUE_AMOUNT,
       t1.VAT_PRINCIPAL,
       t1.VAT_INTEREST,
       t1.NET_DUE_AMOUNT,
       t1.NET_PRINCIPAL,
       t1.NET_INTEREST,
       t1.EQUAL_FLAG,
       t1.MANUAL_FLAG,
       t1.FIX_PRINCIPAL_FLAG,
       t1.FIX_RENTAL_FLAG,
       t1.SALESTAX,
       t1.CALC_LINE_ID,
       t1.OVERDUE_STATUS,
       t1.OVERDUE_BOOK_DATE,
       t1.OVERDUE_AMOUNT,
       t1.OVERDUE_PRINCIPAL,
       t1.OVERDUE_INTEREST,
       t1.OVERDUE_REMARK,
       t1.RECEIVED_AMOUNT,
       t1.RECEIVED_PRINCIPAL,
       t1.RECEIVED_INTEREST,
       t1.RECEIVED_AMOUNT_CNY,
       t1.RECEIVED_PRINCIPAL_CNY,
       t1.RECEIVED_INTEREST_CNY,
       t1.WRITE_OFF_FLAG,
       decode(t1.write_off_flag,
              'FULL',
              '已支付',
              'PARTIAL',
              '部分',
              'NOT',
              '未付') AS payment_precondition_status,
       t1.FULL_WRITE_OFF_DATE,
       t1.PENALTY_PROCESS_STATUS,
       t1.UNRECEIVED_AMOUNT,
       t1.UNRECEIVED_PRINCIPAL,
       t1.UNRECEIVED_INTEREST,
       t1.UNRECEIVED_AMOUNT_CNY,
       t1.UNRECEIVED_PRINCIPAL_CNY,
       t1.UNRECEIVED_INTEREST_CNY,
       t1.WRITE_OFF_ORDER,
       t1.WRITE_OFF_ORDER100,
       t1.WRITE_OFF_ORDER101,
       (select r.rent_bank_account
          from tre_funds_reservation r
         where r.project_id = t1.project_id) AS rent_bank_account,
       (select r.deposit_bank_account
          from tre_funds_reservation r
         where r.project_id = t1.project_id) AS deposit_bank_account
  FROM CON_CONTRACT_CASHFLOW_V t1
 WHERE t1.cf_status = 'RELEASE'
   and t1.contract_status not in ('CANCEL', 'PENDING')
   AND CASHFLOW_ID = 1526
 ORDER BY t1.due_date, t1.write_off_order, t1.times
 
 
 
 
    SELECT sysdate now_time,
           to_date('3000-01-01', 'yyyy-mm-dd') never_date,
           gld_common_pkg.get_gld_period_name(241, sysdate) now_period_name,
           gld_common_pkg.get_gld_internal_period_num(241,
                                                      gld_common_pkg.get_gld_period_name(241,
                                                                                         sysdate)) now_internal_period_num,
           CASE
             WHEN 'N' = 'Y' AND 'N' = 'Y' AND
                  (SELECT check_authority
                     FROM aut_company_authority_setup
                    WHERE company_id = 241
                      AND authority_usage = NVL(null, null)) = 'Y' THEN
              'Y'
             ELSE
              ''
           END authority_flag
      FROM dual;
            
      select * from sys_user;
      select * from csh_deduction_cashflow_out_lv
      select * from csh_deduction_cashflow_out_lv 
 
 
 SELECT t1.CF_TYPE,t1.DESCRIPTION,t1.CF_DIRECTION,t1.cf_direction_desc;
FROM HLS_CASHFLOW_TYPE_V t1
WHERE t1.enabled_flag='Y' AND t1.customizable='Y' AND t1.cf_direction='INFLOW'
     
         --增信  融资合同关联租赁合同
            select * from tre_loan_contract_repayment
            
            select t.* from tre_loan_contract_repayment t,tre_loan_con_repayment_plan tp
                       where t.repayment_plan_id = tp.repayment_plan_id
                         and tp.withdraw_id = 805;
         
         select * from tre_loan_con_relate_contract
         select tc.* from tre_loan_contract t,tre_loan_con_relate_contract tc where t.loan_contract_id = tc.loan_contract_id and t.loan_contract_status in ('LOAN_C_STATUS_020','LOAN_C_STATUS_030','LOAN_C_STATUS_040','LOAN_C_STATUS_050','LOAN_C_STATUS_060','LOAN_C_STATUS_070','LOAN_C_STATUS_080','LOAN_C_STATUS_090');
         
         
         select *
    			from TRE_LOAN_CON_REPAYMENT_ALL_LV;
          
         select *  
         from TRE_LOAN_CONTRACT_REPAYMENT;
         
         
     --- 2016/02/15
     --如果是本机的话，把@FH_DEV去掉；
     --如果不是，运行netca，添加连接标示符。或者使用@ip:端口号:servicename的方式代替@orcl
     --远程备份
     --expdp fh_test/fh_test@FH_DEV schemas=fh_test directory=SYSLOAD_FILE_DIR dumpfile=fh_test_backups_2016_02_15.dmp logfile=fh_test_backups_2016_02_15.log
     --本机备份
     --expdp fh_test/fh_test schemas=fh_test directory=SYSLOAD_FILE_DIR dumpfile=fh_test_backups_2016_02_15.dmp logfile=fh_test_backups_2016_02_15.log
     
     select * from tre_loan_contract_lv;
     tre_con_trust_loans_pkg.tre_submit_check
     
     HLS_DOC_CATEGORY_DB_OBJECT
     
     select * from tre_loan_con_repayment_850_lv;
     
     SELECT RPP.REPAYMENT_PLAN_ID,
       RPP.LOAN_CONTRACT_ID,
       RPP.WITHDRAW_ID  withdraw_id,
       RPP.REPAYMENT_TYPE,
       RPP.REPAYMENT_TYPE_N,
       TO_char(RPP.REPAYMENT_DATE,'yyyy-mm-dd') REPAYMENT_DATE,
       RPP.AMOUNT REPAYMENT_AMOUNT,
       RPP.principal,RPP.interest
  FROM TRE_LOAN_CON_RPP_ALL_LV RPP
 WHERE RPP.withdraw_id =825
 
 TRE_LOAN_CON_RPP_ALL_LV
 select * from tre_loan_con_repayment_850_lv;tre_loan_contract_all_lv;
 
     select c.*
     -- into v_loan_contract
      from tre_loan_contract_withdraw w,tre_loan_contract c
     where w.withdraw_id = 833
       and w.loan_contract_id = c.loan_contract_id;
       
     select w.status,c.loan_amount,c.*
     -- into v_loan_contract
      from tre_loan_contract_withdraw w,tre_loan_contract c
     where w.loan_contract_id = c.loan_contract_id
       --and w.status in ('LOAN_CW_STATUS_03','LOAN_CW_STATUS_04')
       and w.loan_contract_id in (select t.loan_contract_id from tre_loan_contract_withdraw t where t.withdraw_id = 833)
       
    select sum(w.withdraw_amount)
      from tre_loan_contract_withdraw w,tre_loan_contract c
     where w.loan_contract_id = c.loan_contract_id 
       and w.loan_contract_id in (select t.loan_contract_id from tre_loan_contract_withdraw t where t.withdraw_id = 833)
       
         select t.withdraw_amount
      -- into v_the_withdraw_amount
       from tre_loan_contract_withdraw t
      where t.withdraw_id = 833;
      
      select * from ast_collection_record;
      select sysdate from dual;
      select * from sys_user;
      
      
      --2016/02/18
--凭证头
select * from hls_journal_header;
--凭证行
select * from hls_journal_detail;

TRE_LOAN_CON_RE_PLAN_TEMP

--凭证头
select * from hls_journal_header;
--凭证行
select * from hls_journal_detail;
hls_journal_

select * from hls_journal_interface;

create table hls_journal_interface(
       record_id  number,
       journal_id number,
       period_year     number,
       period_num     number,
       create_journal_date date,
       
)
select * from hls_journal_interface;
create SEQUENCE hls_journal_interface_s INCREMENT   BY   1;

create table hcl_journal_sap_intf_log
(
	"LOG_ID" NUMBER NOT NULL ENABLE, 
	"JOURNAL_HEADER_ID" NUMBER, 
	"JOURNAL_LINE_ID" NUMBER, 
	"ERROR_LOG" VARCHAR2(2000), 
	"CREATION_DATE" DATE DEFAULT sysdate NOT NULL ENABLE
)
create table hls_journal_sap_intf_log as select * from hcl_journal_sap_intf_log where 1=0;
drop table hcl_journal_sap_intf_log;

create table hcl_journal_sap_log(
"LOG_ID" NUMBER NOT NULL ENABLE, 
	"LOG_DATE" DATE, 
	"BATCH_NUMBER" VARCHAR2(30), 
	"MESSAGE" VARCHAR2(2000), 
	"CREATION_DATE" DATE DEFAULT sysdate NOT NULL ENABLE, 
	"CREATED_BY" NUMBER NOT NULL ENABLE
)
create table hls_journal_sap_log as select * from hcl_journal_sap_log where 1=0;
drop table hcl_journal_sap_log;

--加索引  hls_journal_sap_log_s
create SEQUENCE hcl_journal_sap_intf_log_s INCREMENT   BY   1; 
drop  sequence  hcl_journal_sap_intf_log_s;
drop sequence hls_journal_sap_log_s;

create SEQUENCE hls_journal_sap_intf_log_s INCREMENT   BY   1; 
create SEQUENCE hls_journal_sap_log_s INCREMENT   BY   1;

create SEQUENCE hls_journal_sap_log_s INCREMENT   BY   1; 


create table hls_journal_interface_history as select * from hls_journal_interface where 1=0;

select * from hcl_journal_sap_intf_log;
--接口日志表   hls_journal_sap_intf_log 索引 hls_journal_sap_intf_log_s   日志信息表 hls_journal_sap_log 索引 hls_journal_sap_log_s
create table hls_journal_sap_log as select * from hcl_journal_sap_intf_log where 1=0;
drop table hls_journal_interface_history;
select * from hls_journal_sap_log;

hcl_journal_sap_intf_log
select * from tre

  select t.* from hls_journal_interface t union
    select th.record_id,th.journal_id,th.period_year,th.period_monthh,th.creathe_journal_dathe,th.journal_thype,th.journal_num,th.creathe_journal_person,th.original_journal_num,th.accounthing_subjecths_num,th.nothe1,th.nothe2,th.remarks,th.balance_thype_num,th.doc_cathegory_num,th.doc_cathegory_dathe,th.currency,th.exchange_rathe,th.price,th.num_dr,th.num_cr,th.amounth_dr,th.amounth_cr,th.amounth_fuc_dr,th.amounth_fuc_cr,th.unith_code,th.employee_code,th.bp_code,th.projecth_thype_code,th.projecth_code,th.salesman,th.ref_01,th.ref_02,th.ref_03,th.ref_04,th.ref_05,th.ref_06,th.ref_07,th.ref_08,th.ref_09,th.ref_10,th.ref_11,th.ref_12,th.ref_13,th.ref_14,th.ref_15,th.ref_16,th.cf_ithem,th.cf_ithem_dr,th.cf_ithem_cr,th.sendfilename,th.sapsendflag,th.sendthime,th.sendthimes,th.creathed_by,th.creathion_dathe,th.lasth_updathed_by,th.lasth_updathe_dathe,th.bathch_number,th.jq_seq from hls_journal_interface_history th

select * from dba_directories

select * from hls_journal_header_s;


SELECT *
                        FROM (SELECT *
                                FROM hls_journal_header t
                               WHERE nvl(t.export_flag, 'N') <> 'Y'
                                 AND t.company_id = 241
                                 AND trunc(t.creation_date) >=
                                     trunc(SYSDATE - 14) --取最近N天的凭证
                              --and t.journal_num in ('S2015091400448','S2015091400449') --add by 5390
                               ORDER BY t.journal_num)  -- 881  883  885 886 884
                               

select * from hls_journal_header;                               
                               select * from hls_journal_interface_v;
                               
INSERT INTO hls_journal_sap_log
      (log_id, log_date, batch_number, message, created_by,creation_date )
    VALUES
      (hls_journal_sap_log_s.nextval,
       trunc(SYSDATE),
       241,
       '',
       1);
       
       SELECT    rownum rw,
           l.*,
           ga.account_code,
           hh.journal_num || '-' || l.line_num journal_dtl,
           hh.je_transaction_code,
           hh.journal_num,
           trunc(hh.journal_date) journal_date
        
      FROM hls_journal_detail l, gld_accounts ga, hls_journal_header hh
     WHERE l.journal_header_id =881
       AND l.account_id = ga.account_id
       AND hh.journal_header_id = l.journal_header_id;
       
       
       
       select * from exp_employee_assigns;
       
       select count(1) from hls_journal_detail l where l.journal_header_id =881;
       
       INSERT INTO hls_journal_interface(,)
       
       delete from hls_journal_interface;
       select *  from hls_journal_interface;
       
       
       --
       select unit_code from exp_org_unit u where u.unit_id = ;
       
       select * from exp_employees e where e.employee_id;
       
       select * from hls_bp_master;
       
       con_contract_pkg
       
        CSH_PAYMENT_REQ_PKG.payment_submit
        
        
        
        SELECT t.journal_header_id, t.journal_num
                                FROM hls_journal_header t
                               WHERE nvl(t.export_flag, 'N') <> 'Y'
                                 AND t.company_id = g_company_id
                                 AND trunc(t.creation_date) >=
                                     trunc(SYSDATE - 16) --取最近N天的凭证
                              --and t.journal_num in ('S2015091400448','S2015091400449') --add by 5390
                               ORDER BY t.journal_num)
                               
                               
                               select * from sys_user;  --1582
                               
                               select * from hls_journal_interface t order by t.journal_id;
                               
                               SELECT t.batch_number
                        FROM hls_journal_interface t
                       WHERE t.sapsendflag = 'N'
                         AND t.batch_number = '2016-02-18 18:52:48'
                         --AND t.bukrs = c_company.comp
                       GROUP BY t.batch_number 
                       
                       
                       SELECT DISTINCT (t.journal_id) AS journal_id,
                                        t.journal_num
                          FROM hls_journal_interface t
                         WHERE 
                         t.sapsendflag = 'N'
                         ORDER BY to_number(t.journal_num)
                         
                         select * from hls_journal_sap_log order by batch_number;
                         
                         select * from hls_journal_header;
                         update hls_journal_header t set t.export_flag = 'Y' where t.journal_header_id in (881,883,885,886,884);
                         
                         
                               SELECT 1
        --INTO v_1
        FROM hls_journal_interface_v
       WHERE journal_id = 881;
       
       
       UPDATE hls_journal_interface t
           SET t.sendfilename = '201602181B0701ZH_CB00.txt'
         WHERE t.batch_number = '2016-02-18 19:41:32'
           AND t.sapsendflag = 'N';
           
                   select * from hls_journal_interface order by batch_number;
           
           select * from hls_journal_interface t 
           where t.batch_number = '2016-02-18 19:41:32'
           AND t.sapsendflag = 'N';
           
           SELECT DISTINCT (t.journal_id) AS journal_id,
                                        t.journal_num
                          FROM hls_journal_interface t
                         WHERE t.sendfilename = p_filename
                           AND t.sapsendflag = 'N'
                         ORDER BY to_number(t.journal_num)
                         
                         
                         
                         
                         SELECT journal_header_id, journal_num, rownum rw
                        FROM (SELECT t.journal_header_id, t.journal_num
                                FROM hls_journal_header t
                               WHERE nvl(t.export_flag, 'N') <> 'Y'
                                 AND t.company_id = 241
                                 AND trunc(t.creation_date) >=
                                     trunc(SYSDATE - 10) --取最近N天的凭证
                              --and t.journal_num in ('S2015091400448','S2015091400449') --add by 5390
                               ORDER BY t.journal_num)
                               
                               
                               
                               SELECT * FROM hls_journal_sap_log;
                               
                               select * from hls_journal_interface;
                               
                      SELECT t.batch_number
                        FROM hls_journal_interface t
                       WHERE t.sapsendflag = 'N'
                         AND t.batch_number = '2016-02-18 20:26:12'
                         
                         SELECT DISTINCT (t.journal_id) AS journal_id,
                                        t.journal_num
                          FROM hls_journal_interface t
                         WHERE t.sendfilename = p_filename
                           AND t.sapsendflag = 'N'
                         ORDER BY to_number(t.journal_num)
                         
                         
                         
                         SELECT DISTINCT (t.journal_id) AS journal_id,
                                        t.journal_num
                          FROM hls_journal_interface t
                         WHERE t.sendfilename = '201602191B0701ZH_CB00.txt'
                           AND t.sapsendflag = 'N'
                         ORDER BY to_number(t.journal_num)
                         
                         
                         select * from hls_journal_interface;
                         delete from hls_journal_interface;
                         select * from hls_journal_header;
                         
                         
                         
                         
                          SELECT l.*,
           ga.account_code,
           hh.journal_num || '-' || l.line_num journal_dtl,
           hh.je_transaction_code,
           hh.journal_num,
           trunc(hh.journal_date) journal_date
      FROM hls_journal_detail l, gld_accounts ga, hls_journal_header hh
     WHERE l.journal_header_id = p_hd_id
       AND l.account_id = ga.account_id
       AND hh.journal_header_id = l.journal_header_id;
       
       
       
           SELECT *
      --INTO v_bp_id
      FROM con_contract  t2,
           hls_bp_master t3
     WHERE t3.bp_id = t2.bp_id_tenant
           AND t2.contract_id = 77;
           
           
          SELECT * FROM con_contract_lease_item
          
          select t3.bp_id_vender,t1.* from con_contract t1,hls_bp_master t2,con_contract_lease_item t3
          where t1.bp_id_tenant = t2.bp_id
          and   t1.contract_id = t3.contract_id
          and   t1.contract_id = 77;
          
          
          select t2.bp_id_vender
            from con_contract t1, prj_project t2
           where t1.project_id = t2.project_id
             and t1.contract_id = 77
          
          
          
    SELECT hbm.bp_id
      --INTO v_bp_id
      FROM con_contract  c,
           prj_project   p,
           hls_bp_master hbm
     WHERE c.project_id = p.project_id
     and   p.bp_id_vender = hbm.bp_id
     
     select p.bp_id_vender from prj_project p;
     
     
     CSH_PAYMENT_REQ_PKG.check_csh_attachment_confirm;
     
     select * from con_contract;
     
     select * from PRJ_CHANCE_V
     
     select * from HLS_DIVISION;
     select * from csh_payment_req_ln;
     
     select p.division
       from csh_payment_req_ln l,
            con_contract       c,
            prj_project_v      p,
            csh_payment_req_hd h
      where l.ref_doc_id = c.contract_id
        and c.project_id = p.project_id
        and l.payment_req_id = h.payment_req_id
        and h.payment_req_id = 1337;
        
        
        select * from csh_payment_req_hd h where h.payment_req_id=1336
     
select * from SYS_ROLE_FUNCTION_GROUP;  --role_id  475
select * from sys_role s where s.role_id = 475;  -- 12054
select * from fnd_descriptions f where f.description_id = 12054;

     
insert into SYS_ROLE_FUNCTION_GROUP (ROLE_FUNCTION_GROUP_ID, ROLE_ID, FUNCTION_GROUP_ID, LAYOUT_SEQUENCE, ENABLED_FLAG, PARENT_ROLE_FUNCTION_GROUP_ID, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
values (6217, 534, 241, 80, 'Y', null, 1, to_date('18-02-2016 13:53:10', 'dd-mm-yyyy hh24:mi:ss'), 1, to_date('18-02-2016 13:53:10', 'dd-mm-yyyy hh24:mi:ss'));



SELECT t1.employee_id AS value_code,
       t1.name        AS value_name,
       t1.employee_code,
       t1.position_name,
       (SELECT unit_name FROM exp_org_unit_v WHERE unit_id = t1.unit_id)unit_name
  FROM hls_salesman_v t1
  
  
  
  SELECT DISTINCT t.employee_id,s
                t.employee_code,
                t.name,
                t.email,
                t.mobil,
                t.phone,
                t.bank_of_deposit,
                t.bank_account,
                t.id_type,
                t.id_code,
                t.notes,
                t.national_identifier,
                a.company_id,
                b.UNIT_ID,
                b.POSITION_ID,
                b.position_code,
                b.description position_name
  FROM exp_employee_assigns a,
       exp_employees        t,
       exp_org_position_vl  b
 WHERE t.employee_id = a.employee_id
       AND b.position_id = a.position_id
       AND b.company_id = a.company_id
       AND b.enabled_flag = 'Y'
       AND b.position_type in ('SALES','MANAGER')
       AND a.enabled_flag = 'Y'
       and t.name like '杨%';
  
select * from exp_employees t where t.name like '杨%';   --836
select * from exp_employee_assigns t where t.employee_id = 836;   --836   1069
select t.POSITION_TYPE from exp_org_position_vl t where t.POSITION_ID= 1069.


select * from  tre_funds_reservation_return
--资金预约回退表
select * from tre_funds_reservation_return;
create table tre_funds_reservation_return(
       return_id number,
       reservation_id number,
       contract_id    number,
       return_date    date,
       return_person_id     number,
       created_by           number,
       creation_date        date,
       last_updated_by      number,
       last_update_date     date
       
);
create sequence tre_funds_reservation_return_s INCREMENT   BY   1;
create table tre_funds_reservation_temp(
       reservation_id number,
       status varchar2(30)
)

SELECT * FROM tre_funds_reservation_temp
delete from tre_funds_reservation_temp;

select t.description from sys_user t where t.user_id = ${/session/@user_id};

tre_funds_reservation_pkg.roll_back_reservation


   select * from con_contract_v c where c.contract_number = 'KJZLA2015-005'
   
      select * from csh_payment_req_hd h where h.payment_req_number='PRQ16020003'   --181/87/86/85
      
      
      select * from CSH_PAYMENT_REQ_DEBT_LN_LV

SELECT * FROM tre_funds_reservation_temp
create sequence tre_funds_reservation_temp_s INCREMENT   BY   1;
tre_funds_reservation_pkg.delete_temp_tre_funds

select * from sys_user t where t.description like '%周';
select * from TRE_FUNDS_RESERVATION_TEMP
	

select c.contract_id, c.contract_number, c.contract_name,pc.user_id
             		from con_contract c,prj_project p,prj_chance_service_managers_lv pc
            	 where data_class = 'NORMAL'
                 and c.project_id = p.project_id
                 and p.chance_id = pc.chance_id
                 
                 --1528
select * from sys_user;--1528

select * from prj_chance_service_managers;

select * from con_contract c where c.contract_id = 821;


PRJ_EXECUTE_APPROVE_STATUS


SELECT v.code_value value_code,
  v.code_value_name value_name
FROM sys_code_values_v v
Where V.Code                  = 'PRJ_EXECUTE_APPROVE_STATUS'
AND v.code_enabled_flag = 'Y'
AND v.code_value_enabled_flag = 'Y'


 select * from 
              (select c.contract_id, c.contract_number, c.contract_name
                 from con_contract c,prj_project p,prj_chance_service_managers_lv pc
            	 where data_class = 'NORMAL'
                 and c.project_id = p.project_id
                 and p.chance_id = pc.chance_id
                 ) t
                 
                 
                 select * from con_contract;
                 
                 
select eo.unit_id
  from exp_employees        e,
       EXP_EMPLOYEE_ASSIGNS ea,
       Exp_Org_Position     eo,
       EXP_ORG_UNIT         eu
 where 
    e.employee_id = ea.employee_id
   and ea.position_id = eo.position_id 
   and eo.unit_id = eu.unit_id;      
   
   select * from 
   
   tre_loan_con_repayment_pkg;
   
   zgc_individual_pkg.overdue_collection_submit
   
   GET_PROJECT_HOST_MANAGER
   
   
   zj_wfl_workflow_rules;
   
   nanshan_prj_workflow_pkg.get_project_host_manager;
   
   
   SELECT t2.user_id,
                               t2.user_name,
                               t3.EMPLOYEE_ID,
                               t3.NAME
                          FROM prj_project_service_managers t1,
                               zj_wfl_users_v               t2,
                               COMPLOYS_DES_NAME_LV         t3
                         WHERE 
                              t1.enabled_flag = 'Y'
                               AND t1.host_manager_flag = 'Y'
                               AND t1.employee_id = t2.employee_id
                               and t2.user_id = t3.USER_ID;
                               
                               
   select * from exp_org_position;   --parent_position_id  上级岗位
   select * from COMPLOYS_DES_NAME_LV
   select * from HLS_LEASE_ORGANIZATION;
   
   SELECT t3.EMPLOYEE_ID,
                               t3.name
                          FROM prj_project_service_managers t1,
                               zj_wfl_users_v               t2,
                               COMPLOYS_DES_NAME_LV         t3
                         WHERE t1.project_id = 518
                               AND t1.enabled_flag = 'Y'
                               AND t1.host_manager_flag = 'Y'
                               AND t1.employee_id = t2.employee_id
                               AND t2.user_id = t3.USER_ID;
                               
                               select * from prj_project_service_managers t where t.project_id = 518;  -- 425
                               select * from zj_wfl_users_v t where t.employee_id = 425
                               
                               select * from sys_user;
                               
                               
                               SELECT t3.EMPLOYEE_ID,
                               t3.name
                          FROM prj_project_service_managers t1,
                               zj_wfl_users_v               t2,
                               COMPLOYS_DES_NAME_LV         t3
                         WHERE t1.enabled_flag = 'Y'
                               AND t1.host_manager_flag = 'Y'
                               AND t1.employee_id = t2.employee_id
                               AND t2.user_id = t3.USER_ID
                               
                               
                               
                               select * from prj_project p where p.project_number = 'PRJ2016000017'    -- 518
                               
                               
                               zj_wfl_core_pkg  5142 3;   rent_collection_date 
                               select * from CON_CONTRACT_OVERRENT_APPRO t where t.approve_id = 366;
                               select * from con_contract_overrent_appro t where t.contract_id = 695;
                               select * from con_contract c where c.contract_id = 317
                               select  from con_contract c;
                               select * from con_contract_cashflow ccc;
                               
                               CON_OVERDUE_PENALTY_PKG.PENALTY_REPORT   --逾期利息计算
                               
                               ZGC_INDIVIDUAL_PKG
                               
                               
                               
                               --2016/02/23
                               zgc_individual_pkg.overdue_collection_submit;
                               
                               select * from zj_wfl_workflow t where t.workflow_id = 786;
                               
                               
                                   select 1
      --into v_exists
      from dual
     where exists (select 1
                     from zj_wfl_workflow_assigns
                    where company_id = 241
                      and workflow_id = 786
                      and enabled_flag = 'Y');
                      
                      select * from zj_wfl_workflow_assigns;
                               select sysdate from dual
                               
                               
                               
                               select cco.contract_id,cco.* from CON_CONTRACT_OVERRENT_APPRO cco where cco.rent_collection_status in ('APPROVED','APPROVING')
                               
                               
                               zgc_individual_pkg.overdue_collection_submit;
                               
                               select *
      
      from CON_CONTRACT_OVERRENT_APPRO t
     where t.approve_id = p_approve_id;
     
     tre_funds_reservation_return_v
     tre_funds_reservation_return
     
     
                                --2016-02-24   贷后管理报告
                    select * from CON_VISIT_REPORT_HDS;
                    --租后负责人
                     select a.user_id       value_code,
        v.employee_code,
        v.employee_name value_name,
        v.unit_name     responsibility_depa
   from exp_employee_assigns_v v, sys_user_v a
  where v.unit_code in (23, 21, 22)
    and a.employee_id = v.employee_id
    and v.enabled_flag = 'Y'
select * from exp_employee_assigns_v;

select * from CON_VISIT_REPORT_HDS_LV;

  select * from CON_CONTRACT_INSURANCE;

select * from con_contract 
                    
select c.unit_id from con_contract_lv c

select * from con_contract_lv c where c.contract_id = 271;

select c.* from con_contract_lv c,exp_org_unit_v u where c.unit_id = u.unit_id;
select c.inception_of_lease from con_contract c

    			select 
    			   t1.contract_id,
			       t1.contract_number,
			       t1.contract_name,
			       t1.contract_status,
			       t1.contract_status_n,
			       t1.bp_id,
			       t1.bp_name,
			       t1.lease_end_date,
			       t1.lease_item_insurance_way,
			       t1.lease_item_insurance_way_n,
			       t1.lease_item_insurance_party,
			       t1.lease_item_insurance_party_n,
			       t1.lease_item_insurance_term,
			       t1.lease_item_insurance_note,
			       t1.max_insurance_date_to,
			       t1.unit_id,
			       t1.unit_name,
			       t1.insurance_beneficiary_status,
			       t1.insurance_beneficiary_status_n,
			       t1.pre_insurance_beneficiary,
			       t1.pre_insurance_beneficiary_n,
			       t1.insurance_beneficiary,
			       t1.insurance_beneficiary_n,
			       to_char(t1.inception_of_lease,'yyyy-mm-dd')inception_of_lease
  				from BGFL_CON_CONTRACT_INSURANCE_V t1
  				 WHERE exists (select 1 from con_contract_cashflow tt where tt.cf_item = 0 and tt.contract_id = t1.contract_id and times = 0 and cf_direction = 'OUTFLOW' and cf_status = 'RELEASE')

   
select * from BGFL_CON_CONTRACT_INSURANCE_V;


select * from CON_CONTRACT_INSURANCE;

zj_wfl_workflow_pkg.create_sys_notice

sys_notice_msg_pkg.create_notice_msg;

 select a.code_value_name
              --into v_insurance_type
              from sys_code_values_v a
             where code = 'CON511_INSURANCE_TYPE'

select count(1) as list_count
				  from sys_notice_msg_v t1
				 where t1.enabled_flag='Y'
				   and (t1.notice_user_id = 1487
				   	   or
				   	   t1.notice_user_id is null)
				   and t1.status='OPEN';
           
           select * from sys_notice_msg_v;
           
           
--2016-02-25
hls_dayend_pkg.dayend
lsh_ins_policy_notice_pkg.send_mail_to_emp   -- 保险到期提醒-保险专员
lsh_ins_policy_notice_pkg.send_sms_to_tenant  -- 保险到期提醒-承租人

select * from psr_report_headers;   hls_con_insurance_pkg 
--合同保险job con_insurance   send_msn_to_asset  给资产管理部门所有员工发送message
select * from exp_org_unit_vl u where u.UNIT_ID = 398;
select * from exp_org_position t where t.unit_id = 398;   --1052 1053 1054
select * from EXP_EMPLOYEE_ASSIGNS t where t.position_id in (1052,1053,1054);  -- 18
select * from sys_user_v

select * from exp_org_unit_vl;
--资产管理部员工
select t4.*
  from exp_org_unit_vl      t1,
       exp_org_position     t2,
       EXP_EMPLOYEE_ASSIGNS t3,
       sys_user             t4
 where t1.UNIT_ID = 466
   and t1.UNIT_ID = t2.unit_id
   and t2.position_id = t3.position_id
   and t3.employee_id = t4.employee_id;
   
   select * from sys_role_vl ;   --574,575,597
   
   select * from sys_notice_msg t where t.msg_title = '合同保险到期'
   delete from sys_notice_msg t where t.notice_user_id is null;
   
   update sys_notice_msg t set t.status = 'CLOSE' where t.msg_body like '%CON201602004%';
   select * from CON_CONTRACT_INSURANCE t where (t.insurance_date_to-trunc(sysdate)<=10);
   
   hls_con_insurance_pkg
   
   
   --租后管理报告维护 (操作对象：起租和暂挂的合同)
   select * from CON_VISIT_REPORT_HDS;
  
   select c.contract_status,c.contract_status_n,c.* from con_contract_lv c where c.contract_status;
   select  from con_contract c where c.contract_status in ('INCEPT','PENDING');
   select * from prj_project;
   select * from con_contract_cashflow;
   select c.contract_id,
          c.contract_number,
          c.contract_name,
          c.bp_id_tenant,
          c.bp_id_tenant_n,
          c.bp_id_tenant_name,
          c.pay_type,
          c.pay_type_n,
          c.annual_pay_times,
          c.annual_pay_times_n,
          c.unit_id,
          c.unit_id_n,
          c.employee_id,
          c.employee_id_n,
          c.document_type,
          c.document_type_n,
          c.contract_status,
          c.contract_status_n
     from con_contract_lv c,sys_user u
     where c.employee_id = u.employee_id
       and u.user_id = ;
     
     select * from sys_user;
     
     
     select c.contract_id,
          c.contract_number,
          c.contract_name,
          c.bp_id_tenant,
          c.bp_id_tenant_n,
          c.bp_id_tenant_name,
          c.pay_type,
          c.pay_type_n,
          c.annual_pay_times,
          c.annual_pay_times_n,
          c.unit_id,
          c.unit_id_n,
          c.employee_id,
          c.employee_id_n,
          c.document_type,
          c.document_type_n,
          c.contract_status,
          c.contract_status_n
     from con_contract_lv c,sys_user u
     where c.employee_id = u.employee_id
       and u.user_id = ?;
     
     	  

     select r.visit_report_id,
            r.company_id,
            r.visit_report_desc,
            r.visit_date,
            r.visit_method,
            r.visit_result,
            r.tenant_id,
            r.document_category,
            r.owner_user_id,
            (select m.bp_name from hls_bp_master m where m.bp_id=r.tenant_id)bp_name,
            r.status,
            (select scv.code_value_name  from sys_code_values_v scv where scv.code = 'CON_CHANGE_REQ_STATUS' and scv.code_value = r.status)status_n,
            c.contract_id,
            c.contract_number,
            c.contract_name,
            c.bp_id_tenant,
            c.bp_id_tenant_n,
            c.pay_type,
            c.pay_type_n,
            c.annual_pay_times,
            c.annual_pay_times_n,
            c.unit_id,
            c.unit_id_n,
            c.employee_id,
            c.employee_id_n,
            c.document_type,
            c.document_type_n,
            c.contract_status,
            c.contract_status_n
       from CON_VISIT_REPORT_HDS r, con_contract_lv c
      where c.contract_id = r.contract_id;
      
      
      
      
      
      select r.visit_report_id,
            r.company_id,
            r.visit_report_desc,
            r.visit_date,
            r.visit_method,
            r.visit_result,
            r.tenant_id,
            r.document_category,
            r.owner_user_id,
            (select m.bp_name from hls_bp_master m where m.bp_id=r.tenant_id)bp_name,
            r.status,
            (select scv.code_value_name  from sys_code_values_v scv where scv.code = 'CON_CHANGE_REQ_STATUS' and scv.code_value = r.status)status_n,
            c.contract_id,
            c.contract_number,
            c.contract_name,
            c.bp_id_tenant,
            c.bp_id_tenant_n,
            c.pay_type,
            c.pay_type_n,
            c.annual_pay_times,
            c.annual_pay_times_n,
            c.unit_id,
            c.unit_id_n,
            c.employee_id,
            c.employee_id_n,
            c.document_type,
            c.document_type_n,
            c.contract_status,
            c.contract_status_n
       from CON_VISIT_REPORT_HDS r, con_contract_lv c
      where c.contract_id = r.contract_id;
      con_contract
    			
      
      select v.code_value id,v.code_value code,code_value_name description from sys_code_values_v v where v.code='LOAN_BUSINESS_TYPE';
      
      select v.code_value id,v.code_value code,code_value_name description from sys_code_values_v v where v.code_value_name like '%租赁%';
      select t.code_value_name from sys_code_values_v t where t.code_value_name = '%租赁%';
      
      select * from HLS_DOCUMENT_TYPE_V t where t.document_type_desc like '%租赁%';
      select t.document_type id,t.document_type code,t.document_type_desc description  from hls_document_type_v t where t.document_category = 'CONTRACT' and enabled_flag = 'Y';
      select * from hls_document_type_v t where t.document_category = 'CHANCE';
select v.code_value id,v.code_value code,code_value_name description from sys_code_values_v v where v.code='LOAN_BUSINESS_TYPE';

select * from sys_role_vl;

select role_id id,role_code code,description from sys_role_vl where trunc(sysdate) between start_date and nvl(end_date,trunc(sysdate)) and role_code in ('1037','1038','1042') order by role_code;

select role_id id,role_code code,description from sys_role_vl where trunc(sysdate) between start_date and nvl(end_date,trunc(sysdate)) and role_id = ${/session/@role_id} order by role_code


      select *  from hls_document_type_v t where t.document_category = 'CONTRACT' and enabled_flag = 'Y';
      
      select * from CON_VISIT_REPORT_HDS_LV;
      
      select * from con_contract c where c.g;
      select P.GRADE_AFTER from prj_project p;
      
      
       select c.contract_id,
          c.contract_number,
          c.contract_name,
          (select bp.bp_code from hls_bp_master bp where bp.bp_id = c.bp_id_tenant)bp_id_tenant,
          c.bp_id_tenant_n,
          c.bp_id_tenant_name,
          c.pay_type,
          c.pay_type_n,
          c.annual_pay_times,
          c.annual_pay_times_n,
          c.unit_id,
          c.unit_id_n,
          c.employee_id,
          c.employee_id_n,
          c.document_type,
          c.document_type_n,
          c.contract_status,
          c.contract_status_n,
          (select p.grade_after from prj_project p where p.project_id = c.project_id)grade_after,
          c.lease_term,
          c.lease_item_amount,
          to_char(c.penalty_rate,'fm999999999990.9999')
     from con_contract_lv c,sys_user u
     where c.employee_id = u.employee_id;
     
     
     con_visit_report_hds


--  day 2016-02-29
select * from con_visit_report_lns;
CON_VISIT_REPORT_HDS_LEASE_LV
select t.cdd_list_id from prj_chance_lv t;
select * from con_visit_report_hds;

CON_VISIT_REPORT_HDS_LEASE_LV

select * from prj_cdd_item_doc_ref t order by t.creation_date;

select * from prj_cdd_item_check t where t.check_id =189;   -- 184 178
select * from prj_cdd_item_check t where t.check_id =178;

select * from prj_cdd_item t where t.cdd_item_id = 415;   --316  328
select * from prj_cdd_item t where t.cdd_item_id = 412;


prj_cdd_item_s.nextval;


prj_chance_pkg;
con_visit_report_pkg

select * from HLS_DOC_CATEGORY_DB_OBJECT;

select c.pay_type from con_contract_lv c;


select (select bp.bp_id from hls_bp_master bp where bp.bp_id = c.bp_id_tenant)bp_id_tenant,
          	       (select bp.bp_code from hls_bp_master bp where bp.bp_id = c.bp_id_tenant)bp_code,
            	   c.bp_id_tenant_n
       		  from con_contract_lv c,sys_user u
      		 where c.employee_id = u.employee_id
             and c.data_class = 'NORMAL'
           
           select * from con_contract_lv;
           
           
           
           
           
           (select c.contract_id,
          c.contract_number,
          c.contract_name,
          c.bp_id_tenant,
          (select bp.bp_code from hls_bp_master bp where bp.bp_id = c.bp_id_tenant)bp_code,
          c.bp_id_tenant_n,
          c.bp_id_tenant_name,
          c.pay_type,
          c.pay_type_n,
          c.annual_pay_times,
          c.annual_pay_times_n,
          c.unit_id,
          c.unit_id_n,
          c.employee_id,
          c.employee_id_n,
          c.document_type,
          c.document_type_n,
          c.contract_status,
          c.contract_status_n,
          (select p.grade_after from prj_project p where p.project_id = c.project_id)grade_after,
	  (select v.code_value_name from sys_code_values_v v where v.code='GRADE_AFTER' and v.code_value = (select p.grade_after from prj_project p where p.project_id = c.project_id))grade_after_n,
          to_char(c.lease_term,'fm9999990.09')lease_term,
          c.lease_item_amount,
          to_char(c.penalty_rate,'fm9999990.9999')penalty_rate,
          u.user_id,
          u.description user_name
     from con_contract_lv c,sys_user u
     where c.employee_id = u.employee_id
       and c.data_class = 'NORMAL')
       
       
       select * from HLS_DOCUMENT_TYPE_V t where t.document_category = 'CONTRACT' AND T.code_auto_flag ='Y' and t.enabled_flag='Y';
       
       
       
       select * from
     (select r.visit_report_id,
            r.company_id,
            r.visit_report_desc,
            r.visit_date,
            r.visit_method,
            r.visit_result,
            r.tenant_id,
            r.document_category,
            r.owner_user_id,
            (select m.bp_name from hls_bp_master m where m.bp_id=r.tenant_id)bp_name,
            r.status,
            (select scv.code_value_name  from sys_code_values_v scv where scv.code = 'VISIT_REPORT_STATUS' and scv.code_value = r.status)status_name,
            c.contract_id,
            c.contract_number,
            c.contract_number contract_number_n,
            c.contract_name,
            c.bp_id_tenant,
            c.bp_id_tenant_n,
            c.pay_type,
            c.pay_type_n,
            c.annual_pay_times,
            c.annual_pay_times_n,
            c.unit_id,
            c.unit_id_n,
            c.employee_id,
            c.employee_id_n,
            c.document_type,
            c.document_type_n,
            c.contract_status,
            c.contract_status_n
       from CON_VISIT_REPORT_HDS r, con_contract_lv c
      where c.contract_id = r.contract_id
      	and c.contract_id = 124
      	)t1
      	 WHERE company_id=241 AND CONTRACT_ID = 124 AND t1.visit_date <= to_date('2016-02-28','yyyy-mm-dd') AND t1.visit_date >= to_date(?,'yyyy-mm-dd')
    		select * from con_visit_report_lns
    		select * from CON_VISIT_REPORT_HDS_LV;
        select * from con_visit_io_plan_lns;
        create table con_visit_io_plan_lns(
               con_visit_io_plan_lns_id number,
               con_visit_report_id      number,
               contract_id              number,
               direction_fund           varchar2(50),
               amount_fund              number,
               source_fund              varchar2(200),
               remark                   varchar2(2000)
               
        )
        select * from con_visit_io_plan_lns;
        select * from con_visit_io_plan_lns;
        visit_report_code
       select * from  HLS_DOC_CATEGORY_DB_OBJECT;
       prj_chance_pkg
       
       
         v_no := fnd_code_rule_pkg.get_rule_next_auto_num(p_document_category => g_document_category,
                                                     p_document_type     => p_document_type,
                                                     p_business_type     => p_business_type,
                                                     p_company_id        => p_company_id,
                                                     p_operation_unit_id => NULL,
                                                     p_operation_date    => p_transaction_date,
                                                     p_created_by        => p_user_id);
    IF v_no = fnd_code_rule_pkg.c_error THEN
      RAISE e_get_project_number_err;
    END IF;

  
  hcl_journal_sap_pkg
  
  CREATE TABLE "HLS_JOURNAL_SAP_INTF_LOG" 
   (	"LOG_ID" NUMBER NOT NULL ENABLE, 
	"JOURNAL_HEADER_ID" NUMBER, 
	"JOURNAL_LINE_ID" NUMBER, 
	"ERROR_LOG" VARCHAR2(2000), 
	"CREATION_DATE" DATE NOT NULL ENABLE, 
	"LOG_CLOB" CLOB
   )
  
  CREATE TABLE "HLS_JOURNAL_SAP_INTF_LOG" 
   (	"LOG_ID" NUMBER NOT NULL ENABLE, 
	"JOURNAL_HEADER_ID" NUMBER, 
	"JOURNAL_LINE_ID" NUMBER, 
	"ERROR_LOG" VARCHAR2(2000), 
	"CREATION_DATE" DATE NOT NULL ENABLE, 
	"LOG_CLOB" CLOB
   )
   CREATE TABLE "HLS_JOURNAL_SAP_LOG" 
   (	"LOG_ID" NUMBER NOT NULL ENABLE, 
	"LOG_DATE" DATE, 
	"BATCH_NUMBER" VARCHAR2(30), 
	"MESSAGE" VARCHAR2(2000), 
	"CREATION_DATE" DATE NOT NULL ENABLE, 
	"CREATED_BY" NUMBER NOT NULL ENABLE
   )
   
   
   
   CREATE TABLE "HLS_JOURNAL_INTERFACE" 
   (	"RECORD_ID" NUMBER NOT NULL ENABLE, 
	"JOURNAL_ID" NUMBER, 
	"PERIOD_YEAR" NUMBER, 
	"PERIOD_MONTH" NUMBER, 
	"CREATE_JOURNAL_DATE" DATE, 
	"JOURNAL_TYPE" VARCHAR2(30), 
	"JOURNAL_NUM" VARCHAR2(30), 
	"CREATE_JOURNAL_PERSON" VARCHAR2(30), 
	"ORIGINAL_JOURNAL_NUM" NUMBER, 
	"ACCOUNTING_SUBJECTS_NUM" VARCHAR2(30), 
	"NOTE1" VARCHAR2(2000), 
	"NOTE2" VARCHAR2(2000), 
	"REMARKS" VARCHAR2(2000), 
	"BALANCE_TYPE_NUM" VARCHAR2(100), 
	"DOC_CATEGORY_NUM" VARCHAR2(30), 
	"DOC_CATEGORY_DATE" DATE, 
	"CURRENCY" VARCHAR2(30), 
	"EXCHANGE_RATE" NUMBER, 
	"PRICE" NUMBER, 
	"NUM_DR" NUMBER, 
	"NUM_CR" NUMBER, 
	"AMOUNT_DR" NUMBER, 
	"AMOUNT_CR" NUMBER, 
	"AMOUNT_FUC_DR" NUMBER, 
	"AMOUNT_FUC_CR" NUMBER, 
	"UNIT_CODE" VARCHAR2(30), 
	"EMPLOYEE_CODE" VARCHAR2(30), 
	"CUSTOMER_CODE" VARCHAR2(30), 
	"BP_CODE" VARCHAR2(30), 
	"PROJECT_TYPE_CODE" VARCHAR2(30), 
	"PROJECT_CODE" VARCHAR2(30), 
	"SALESMAN" VARCHAR2(30), 
	"REF_01" VARCHAR2(2000), 
	"REF_02" VARCHAR2(2000), 
	"REF_03" VARCHAR2(2000), 
	"REF_04" VARCHAR2(2000), 
	"REF_05" VARCHAR2(2000), 
	"REF_06" VARCHAR2(2000), 
	"REF_07" VARCHAR2(2000), 
	"REF_08" VARCHAR2(2000), 
	"REF_09" VARCHAR2(2000), 
	"REF_10" VARCHAR2(2000), 
	"REF_11" VARCHAR2(2000), 
	"REF_12" VARCHAR2(2000), 
	"REF_13" VARCHAR2(2000), 
	"REF_14" VARCHAR2(2000), 
	"REF_15" VARCHAR2(2000), 
	"REF_16" VARCHAR2(2000), 
	"CF_ITEM" NUMBER, 
	"CF_ITEM_DR" NUMBER, 
	"CF_ITEM_CR" NUMBER, 
	"SENDFILENAME" VARCHAR2(100), 
	"SAPSENDFLAG" VARCHAR2(30), 
	"SENDTIME" DATE, 
	"SENDTIMES" NUMBER, 
	"CREATED_BY" NUMBER, 
	"CREATION_DATE" DATE, 
	"LAST_UPDATED_BY" NUMBER, 
	"LAST_UPDATE_DATE" DATE, 
	"BATCH_NUMBER" VARCHAR2(30), 
	"JQ_SEQ" NUMBER, 
	"ZUONR" VARCHAR2(30), 
	 CONSTRAINT "HCL_JOURNAL_INTERFACE_PK" PRIMARY KEY ("RECORD_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "FH_TEST"  ENABLE
   )
   
   
   
   
   CREATE TABLE "HLS_JOURNAL_INTERFACE_HISTORY" 
   (	"RECORD_ID" NUMBER NOT NULL ENABLE, 
	"JOURNAL_ID" NUMBER, 
	"PERIOD_YEAR" NUMBER, 
	"PERIOD_MONTH" NUMBER, 
	"CREATE_JOURNAL_DATE" DATE, 
	"JOURNAL_TYPE" VARCHAR2(30), 
	"JOURNAL_NUM" VARCHAR2(30), 
	"CREATE_JOURNAL_PERSON" VARCHAR2(30), 
	"ORIGINAL_JOURNAL_NUM" NUMBER, 
	"ACCOUNTING_SUBJECTS_NUM" VARCHAR2(30), 
	"NOTE1" VARCHAR2(2000), 
	"NOTE2" VARCHAR2(2000), 
	"REMARKS" VARCHAR2(2000), 
	"BALANCE_TYPE_NUM" VARCHAR2(100), 
	"DOC_CATEGORY_NUM" VARCHAR2(30), 
	"DOC_CATEGORY_DATE" DATE, 
	"CURRENCY" VARCHAR2(30), 
	"EXCHANGE_RATE" NUMBER, 
	"PRICE" NUMBER, 
	"NUM_DR" NUMBER, 
	"NUM_CR" NUMBER, 
	"AMOUNT_DR" NUMBER, 
	"AMOUNT_CR" NUMBER, 
	"AMOUNT_FUC_DR" NUMBER, 
	"AMOUNT_FUC_CR" NUMBER, 
	"UNIT_CODE" VARCHAR2(30), 
	"EMPLOYEE_CODE" VARCHAR2(30), 
	"CUSTOMER_CODE" VARCHAR2(30), 
	"BP_CODE" VARCHAR2(30), 
	"PROJECT_TYPE_CODE" VARCHAR2(30), 
	"PROJECT_CODE" VARCHAR2(30), 
	"SALESMAN" VARCHAR2(30), 
	"REF_01" VARCHAR2(2000), 
	"REF_02" VARCHAR2(2000), 
	"REF_03" VARCHAR2(2000), 
	"REF_04" VARCHAR2(2000), 
	"REF_05" VARCHAR2(2000), 
	"REF_06" VARCHAR2(2000), 
	"REF_07" VARCHAR2(2000), 
	"REF_08" VARCHAR2(2000), 
	"REF_09" VARCHAR2(2000), 
	"REF_10" VARCHAR2(2000), 
	"REF_11" VARCHAR2(2000), 
	"REF_12" VARCHAR2(2000), 
	"REF_13" VARCHAR2(2000), 
	"REF_14" VARCHAR2(2000), 
	"REF_15" VARCHAR2(2000), 
	"REF_16" VARCHAR2(2000), 
	"CF_ITEM" NUMBER, 
	"CF_ITEM_DR" NUMBER, 
	"CF_ITEM_CR" NUMBER, 
	"SENDFILENAME" VARCHAR2(100), 
	"SAPSENDFLAG" VARCHAR2(30), 
	"SENDTIME" DATE, 
	"SENDTIMES" NUMBER, 
	"CREATED_BY" NUMBER, 
	"CREATION_DATE" DATE, 
	"LAST_UPDATED_BY" NUMBER, 
	"LAST_UPDATE_DATE" DATE, 
	"BATCH_NUMBER" VARCHAR2(30), 
	"JQ_SEQ" NUMBER, 
	"ZUONR" VARCHAR2(30)
   )
   
   
     select * from hls_document_category t where t.document_category = 'VISIT_REPORT';
  select * from hls_document_type t where t.description like '租后%';  -- 'VISIT_REPORT_REQ'
  con_visit_report_pkg;
  
  select * from con_visit_io_plan_lns_lv;
  delete from con_visit_io_plan_lns;
  con_visit_report_id  
  select * from con_visit_io_plan_lns
 select * from CON_VISIT_REPORT_HDS;
 
 
 SELECT v.code_value      AS value_code,
       v.code_value_name AS value_name
  FROM sys_code_values_v v
 WHERE v.code = 'DIRECTION_OF_MONEY'
       AND v.code_enabled_flag = 'Y'
       AND v.code_value_enabled_flag = 'Y'
       
               select * from con_visit_io_plan_lns;
        visit_report_code
       select * from  HLS_DOC_CATEGORY_DB_OBJECT;
       prj_chance_pkg;
       
       select * from con_visit_io_plan_lns;
       create SEQUENCE con_visit_io_plan_lns_s INCREMENT   BY   1;
       
       select * from con_visit_report_lns;
       
       select * from prj_cdd_item_doc_ref t where t.document_table = 'CON_VISIT_REPORT_HDS'   -- 256   275
       
       SELECT * FROM PRJ_CDD_ITEM_CHECK T WHERE T.CHECK_ID = 275;
        
       SELECT * FROM PRJ_CDD_ITEM T WHERE T.CDD_ITEM_ID = 650; 
       
       csh_payment_req_pkg.payment_submit
       
       con_visit_report_pkg;
       
       
            SELECT approval_method
      --INTO v_approval_method
      FROM hls_document_type
     WHERE document_category = v_con_visit_report_hds.document_category;
     
     select * from hls_document_category;
     
     select * from hls_document_category;
     select * from hls_document_type;
     select * from hls_document
     --工作流实例     
     
     select * from zj_wfl_workflow_instance t where t.workflow_id = 866
     select * from zj_wfl_workflow t where t.workflow_code= 'AFTER_INCEPTION_REPORT';  --workflow_id  866
     
     select * from sys_user;
     select * from exp_employees;   -- employee_id
     select * from EXP_EMPLOYEE_ASSIGNS    --position_id
     select * from exp_org_unit;     --unit_id
     select * from Exp_Org_Position;   
     
     
     select * from sys_user u,exp_employees e,EXP_EMPLOYEE_ASSIGNS a;
     
     select * from prj_project_pkg
     
     select p.wfl_instance_id from prj_project p;
     
     select * from con_contract;   --wfl_instance_id 
     con_contract_pkg;
     
     select * from con_visit_report_hds
     -- document_type = VISIT_REPORT_REQ    document_category = VISIT_REPORT
     select * from hls_document_type_v t where t.document_type = 'VISIT_REPORT_REQ';
     
     select * from sys_role_vl t where t.description like '业务%';   -- 574,575,597
     select * from sys_role;
     
     select * from con_visit_report_hds t where t.created_by = 1469
     select * from con_contract;
     
     select c.document_type from CON_VISIT_REPORT_HDS t,con_contract c where t.contract_id = c.contract_id
     
     select * from CON_VISIT_REPORT_HDS_LEASE_LV;
     
     PRJ_CHANCE_PKG
     
     select * from con_visit_problem_measure;
     create table con_visit_problem_measure(
            problem_measure_id number,
            visit_report_id    number,
            contract_id        number,
            PROBLEM_DESCRIPTION  varchar2(2000),
            SUGGEST_MEASURE      varchar2(2000),
            created_by           number,
            creation_date        date,
            last_updated_by      number,
            last_update_date     date 
     )
     create SEQUENCE con_visit_problem_measure_s INCREMENT   BY   1;
     
     
     con_visit_problem_measure_lv
     
     select * from con_visit_problem_measure
     
    select * from HLS_DOC_CATEGORY_DB_OBJECT;
    
    
    SELECT
                    d.column_name,
                    d.grid_order_seq,
                    NVL(d.grid_order_type, 'ASCENDING') grid_order_type,
                    d.data_type
                FROM
                    hls_doc_layout_config d
                WHERE
                    d.layout_code     = 'FH_INVESTMENT_REPORT_MODIFY' AND
                    d.tab_code        = 'BALANCE_PLAN' AND
                    d.grid_order_seq IS NOT NULL AND
                    d.enabled_flag    = 'Y'
                ORDER BY
                    d.grid_order_seq;
                    
                    con_visit_problem_measure_lv;
                    
                    
                    PRJ_CHANCE_PKG
                    
                    csh_payment_workflow_pkg.workflow_finish;
                    
                    
select t1.instance_id,
    				   t1.approve_count,
    				   t1.submitted_by,
    				   t1.submitted_by_name,
				       t1.node_id,
				       t1.node_desc,
				       t1.hierarchy_record_id,
				       t1.seq_number,
				       t1.user_id,
				       t1.date_limit,
				       t1.record_id,
				       
				       t1.commision_desc,
				       t1.last_notify_date,
				       t1.workflow_id,
				       t1.workflow_code,
				       t1.workflow_desc,
				       t1.workflow_desc || '-' || t1.node_desc as workflow_info,
				       t1.document_info,
				       to_char(t1.creation_date, 'yyyy-mm-dd hh24:mi:ss') as creation_date_format,
				       t1.urgent_type,
				       nvl(t1.commision_by,1528) commision_by,
				       (select e.position_code from exp_emp_assign_e_v e where e.user_id=t1.user_id and e.primary_position_flag='Y' and e.company_id=241 and rownum=1)position_code,
				       (select sequence_num
          from zj_wfl_workflow_node n
         where n.node_id = t1.node_id) node_sequence_num,
                       t1.record_type
				  from zj_wfl_instance_node_rcpt_v t1
				     WHERE t1.user_id = 1528
				 order by t1.urgent_type, t1.creation_date desc;
         
         
         select con_visit_report_pkg.get_asset_judge(p_user=>1469)as role_judge from dual
         
         select con_visit_report_pkg.get_asset_judge(p_user=>${/session/@user_id}) role_judge from dual;
         
         select * from con_contract_lv;
    		
    		

select zj_wfl_core_pkg.get_node_service_url(994, 
            												'DISPLAY', 
            												1528) as service_url
				  from zj_wfl_instance_node_recipient t1
           where t1.record_id = 994
          
          select * from zj_wfl_instance_node_recipient t where t.record_id = 994;
          
          
          winid=zj_wfl_approve_win&amp;instance_id=${/parameter/@instance_id}&amp;commision_by=1528
            
          
          
          
          select t1.instance_id,
    				   t1.approve_count,
    				   t1.submitted_by,
    				   t1.submitted_by_name,
				       t1.node_id,
				       t1.node_desc,
				       t1.hierarchy_record_id,
				       t1.seq_number,
				       t1.user_id,
				       t1.date_limit,
				       t1.record_id,
				       
				       t1.commision_desc,
				       t1.last_notify_date,
				       t1.workflow_id,
				       t1.workflow_code,
				       t1.workflow_desc,
				       t1.workflow_desc || '-' || t1.node_desc as workflow_info,
				       t1.document_info,
				       to_char(t1.creation_date, 'yyyy-mm-dd hh24:mi:ss') as creation_date_format,
				       t1.urgent_type,
				       nvl(t1.commision_by,1528) commision_by,
				       (select e.position_code from exp_emp_assign_e_v e where e.user_id=t1.user_id and e.primary_position_flag='Y' and e.company_id=241 and rownum=1)position_code,
				       (select sequence_num
          from zj_wfl_workflow_node n
         where n.node_id = t1.node_id) node_sequence_num,
                       t1.record_type
				  from zj_wfl_instance_node_rcpt_v t1
				     WHERE t1.user_id = 1528
				 order by t1.urgent_type, t1.creation_date desc
         
         
         
         
         SELECT t1.NODE_ID,t1.WORKFLOW_CODE,t1.WORKFLOW_DESC,t1.NODE_SEQUENCE_NUM,t1.NODE_DESC,t1.INSTANCE_ID,t1.ACTION_TAKEN,t1.ACTION_TYPE,t1.ACTION_TYPE_DESC,t1.RECORD_TYPE,t1.COMMENT_TEXT,t1.RECORD_ID,t1.SEQ_NUMBER,t1.RCPT_RECORD_ID,t1.DISABLED_FLAG,t1.NOTE,t1.CREATE_DATE_FMT,t1.APPROVER,t1.RECORD_APPROVE_COUNT,t1.INSTANCE_APPROVE_COUNT,t1.NODE_HIDE_APPROVE_RECORD,t1.NODE_SHOW_APPROVE_HT,t1.NODE_SHOW_ALL_APPROVE_HT,t1.WFL_SHOW_APPROVE_HT,t1.WFL_SHOW_ALL_APPROVE_HT
FROM ZJ_WFL_APPROVE_HISTORY_V t1
WHERE t1.instance_id = 204 and t1.node_hide_approve_record = 'N' and 'Y' = 'Y' and ('Y' = 'Y' or t1.record_approve_count = t1.instance_approve_count)
ORDER BY t1.record_id desc
    		


select * from ZJ_WFL_APPROVE_HISTORY_V v where v.instance_id = 204;

select * from ZJ_WFL_APPROVE_HISTORY_V v where v.workflow_code = 	'RENT_MANAGEMENT_REPORT_WORK_FLOW'

select * from zj_wfl_instance_log;
select * from zj_wfl_instance_log w where w.instance_id = 204;

select * from zj_wfl_workflow w where w.workflow_code = 'RENT_MANAGEMENT_REPORT_WORK_FLOW';


       select * from AST_COLLECTION_RECORD_LV;
       
       
       
       
       
       
       SELECT t1.collection_id,
       t1.company_id,
       t1.bp_id_tenant,
       (SELECT h.bp_name
          FROM hls_bp_master h
         WHERE h.bp_id = t1.bp_id_tenant) bp_id_tenant_n,
       t1.contract_id,
       (SELECT cc.contract_number
          FROM con_contract cc
         WHERE cc.contract_id = t1.contract_id) contract_number,
       --(SELECT cc.search_term_1
          --FROM con_contract cc
        -- WHERE cc.contract_id = t1.contract_id) contract_id_n,
        (SELECT cc.contract_number
          FROM con_contract cc
         WHERE cc.contract_id = t1.contract_id) contract_id_n,
       t1.collector_user_id,
       (SELECT s.description
          FROM sys_user s
         WHERE s.user_id = t1.collector_user_id) collector_user_id_n,
       t1.collection_date,
       t1.collection_method,
       (SELECT l.code_value_name AS value_name
          FROM sys_code_values_v l
         WHERE l.code = 'LEG_COLLECTION_METHOD'
           AND l.code_value = t1.collection_method
           AND l.code_enabled_flag = 'Y'
           AND l.code_value_enabled_flag = 'Y') collection_method_n,
       t1.promised_repay_date,
       t1.promised_repay_amount,
       t1.result,
       t1.result_memo,
       t1.follow_up,
       t1.description,
       (SELECT ci.fax
          FROM hls_bp_master_contact_info ci
         WHERE ci.bp_id = t1.bp_id_tenant) fax,
       /*(SELECT ci.phone
          FROM hls_bp_master_contact_info ci
         WHERE ci.bp_id = t1.bp_id_tenant) phone,*/
       (SELECT ci.cell_phone
          FROM hls_bp_master_contact_info ci
         WHERE ci.bp_id = t1.bp_id_tenant) cell_phone,
      /* (SELECT ci.contact_person
          FROM hls_bp_master_contact_info ci
         WHERE ci.bp_id = t1.bp_id_tenant) contact_person,*/
       (SELECT u.description AS unit_name
          FROM exp_org_unit_vl      u,
               exp_org_position     p,
               exp_employee_assigns a,
               sys_user             s

         WHERE 1 = 1
         and rownum =1
           AND s.employee_id = a.employee_id
           AND a.position_id = p.position_id
           AND p.unit_id = u.unit_id
           AND s.user_id = t1.collector_user_id
           AND u.ENABLED_FLAG = 'Y'
           AND p.enabled_flag = 'Y'
           AND a.enabled_flag = 'Y'
           ) UNIT_ID_N,
           t1.serial_number,
           t1.creation_date,
           t1.register_date,
           t1.contact_person,
           t1.phone
  FROM ast_collection_record t1;
  
  
  AST_COLLECTION_RECORD_LV;
  
  hls_dayend_pkg.dayend;
  
        SELECT *
        --INTO v_penalty_cashflow_rec
        FROM con_contract_cashflow
       WHERE contract_id = 18
             AND cf_item = 9
             AND times = 0;
             
             
             select max(t.insurance_number)insurance_number from con_contract_insurance t
 			where t.contract_id = 104;
      
      
      con_visit_report_pkg;
      select * from con_visit_report_hds;
      CON_VISIT_REPORT_PKG
      CON_VISIT_REPORT_HDS_LEASE_LV


select h.document_category,h.document_type from con_visit_report_hds H;
select v.document_type from con_contract_lv v;
delete from con_visit_report_hds t;

sys_condition_layout_pkg.matching_condition;



select r.visit_report_id,
	    r.visit_report_code,
            r.company_id,
            r.visit_report_desc,
            r.visit_date,
            r.visit_method,
            r.visit_result,
            r.tenant_id,
            r.document_category,
            r.owner_user_id,
            (select m.bp_name from hls_bp_master m where m.bp_id=r.tenant_id)bp_name,
            r.status,
            (select scv.code_value_name  from sys_code_values_v scv where scv.code = 'VISIT_REPORT_STATUS' and scv.code_value = r.status)status_name,
            c.contract_id,
            c.contract_number,
            c.contract_number contract_number_n,
            c.contract_name,
            c.bp_id_tenant,
            c.bp_id_tenant_n,
            c.pay_type,
            c.pay_type_n,
            c.annual_pay_times,
            c.annual_pay_times_n,
            c.unit_id,
            c.unit_id_n,
            c.employee_id,
            c.employee_id_n,
            c.document_type contract_type,
            c.document_type_n contract_type_n,
            c.contract_status,
            c.contract_status_n,
            r.role_id,
            r.document_type
       from CON_VISIT_REPORT_HDS r, con_contract_lv c
      where c.contract_id = r.contract_id;
      
      zgc_individual_pkg.overdue_collection_submit;
      
      select * from con_visit_report_hds;
      
      select * from con_contract;
      
      ZGC_INDIVIDUAL_PKG.OVERDUE_COLLECTION_APPROVED
      
      select c.overdue_cus_transfer_status from con_contract c where c.contract_id = 18;
      
      hcl_journal_sap_pkg;
      
      
      SELECT journal_header_id, journal_num, rownum rw
                        FROM (SELECT t.journal_header_id, t.journal_num
                                FROM hls_journal_header t
                               WHERE nvl(t.export_flag, 'N') <> 'Y'
                                 AND t.company_id = 241
                                 AND trunc(t.creation_date) >=
                                     trunc(SYSDATE - 10) --取最近N天的凭证
                              --and t.journal_num in ('S2015091400448','S2015091400449') --add by 5390
                               ORDER BY t.journal_num)
                               
                               
                               
                               sch_system_job_pkg;
                               
                               
                               
                               SELECT journal_header_id, journal_num,creation_date,creation_date,rownum rw
                        FROM (SELECT t.journal_header_id, t.journal_num,t.creation_date,t.creation_date
                                FROM hls_journal_header t
                               WHERE nvl(t.export_flag, 'N') <> 'Y'
                                 AND t.company_id = 241
                                 AND trunc(t.creation_date) >=
                                     trunc(SYSDATE - 0) --取最近N天的凭证
                              --and t.journal_num in ('S2015091400448','S2015091400449') --add by 5390
                               ORDER BY t.journal_num)
                               
                               
                               
                               -- 凭证头
                               select * from hls_journal_header;
                               
                               update hls_journal_header h set h.export_flag = 'N';
                               
                               
                               
                               
                               SELECT journal_header_id, journal_num, rownum rw
                        FROM (SELECT t.journal_header_id, t.journal_num
                                FROM hls_journal_header t
                               WHERE nvl(t.export_flag, 'N') <> 'Y'
                                 AND t.company_id = 241
                                 AND trunc(t.creation_date) >=
                                     trunc(SYSDATE - 10) --取最近N天的凭证
                              --and t.journal_num in ('S2015091400448','S2015091400449') --add by 5390
                               ORDER BY t.journal_num)
                               
                               
                               SELECT *
      -- INTO v_1
        FROM hls_journal_interface_v
       WHERE journal_id = 41
       
       delete from hls_journal_interface_history;
       delete from hls_journal_interface;
       
       select * from hls_journal_header;
       
             SELECT *
        --INTO v_1
        FROM hls_journal_interface_v
       WHERE journal_id = 41;
       
       select * from hls_journal_interface;
       select * from hls_journal_interface_history;
       
       
       -- 凭证区分
       
       SELECT journal_header_id, journal_num, rownum rw
                        FROM (SELECT t.journal_header_id, t.journal_num
                                FROM hls_journal_header t
                               WHERE nvl(t.export_flag, 'N') <> 'Y'
                                 AND t.company_id = 241
                                 AND trunc(t.creation_date) >=
                                     trunc(SYSDATE - 300) --取最近N天的凭证
                              --and t.journal_num in ('S2015091400448','S2015091400449') --add by 5390
                               ORDER BY t.journal_num)
                               
                               
                               --凭证
                               SELECT t.*
                                FROM hls_journal_header t
                               WHERE nvl(t.export_flag, 'N') <> 'Y'
                                 AND t.company_id = 241
                                 AND trunc(t.creation_date) >=
                                     trunc(SYSDATE - 30) --取最近N天的凭证
                              --and t.journal_num in ('S2015091400448','S2015091400449') --add by 5390
                               ORDER BY t.journal_num;
                               
                               
                               select * from hls_journal_sap_log;
                               
                               select u.unit_code, d.description_text unit_desc,rownum rw
                                 from EXP_ORG_UNIT u, fnd_descriptions d
                                where u.description_id = d.description_id
                                order by rw;
                                
                                
                                
                                SELECT unit_code, unit_desc,rownum rw
                        FROM (select u.unit_code, d.description_text unit_desc
                                 from EXP_ORG_UNIT u, fnd_descriptions d
                                where u.description_id = d.description_id
                                order by u.unit_code);
                                
                                
                               select * from hls_journal_interface;
                               
                               --部门档案接口
                               select * from hls_org_unit_interface;
                               create SEQUENCE hls_org_unit_interface_s INCREMENT   BY   1;
                               CREATE TABLE "FH_TEST"."HLS_ORG_UNIT_INTERFACE" 
                                       (	"RECORD_ID" NUMBER NOT NULL ENABLE, 
                                      "UNIT_ID" NUMBER, 
                                      "UNIT_CODE" VARCHAR2(12), 
                                      "UNIT_NAME" VARCHAR2(255), 
                                      "SET_UP_DATE" DATE, 
                                      "ENGLISH_NAME" VARCHAR2(255), 
                                      "UNIT_TYPE" VARCHAR2(20), 
                                      "BRANCH_LEADER" VARCHAR2(20), 
                                      "UNIT_PROPERTY" VARCHAR2(10), 
                                      "RESPONSIBILITY_CODE" VARCHAR2(20), 
                                      "APPROVE_CODE" VARCHAR2(50), 
                                      "APPROVE_UNIT" VARCHAR2(60), 
                                      "PHONE" VARCHAR2(100), 
                                      "ADDRESS" VARCHAR2(255), 
                                      "FAX" VARCHAR2(20), 
                                      "ZIP_CODE" VARCHAR2(6), 
                                      "EMAIL" VARCHAR2(100), 
                                      "LINE_OF_CREDIT" NUMBER, 
                                      "LEVEL_OF_CREDIT" VARCHAR2(20), 
                                      "DAY_OF_CREDIT" NUMBER, 
                                      "REMARK" VARCHAR2(20), 
                                      "START_UP_UTU" NUMBER, 
                                      "FOR_RETAIL" NUMBER, 
                                      "INPUT_DATE" DATE, 
                                      "INPUT_NAME" VARCHAR2(100), 
                                      "BATCH_NUMBER" VARCHAR2(30), 
                                      "EXPORT_FLAG" VARCHAR2(1), 
                                      "SENDFILENAME" VARCHAR2(200), 
                                      "SAPSENDFLAG" VARCHAR2(1), 
                                      "CREATED_BY" NUMBER, 
                                      "CREATION_DATE" DATE, 
                                      "LAST_UPDATED_BY" NUMBER, 
                                      "LAST_UPDATE_DATE" DATE, 
                                       CONSTRAINT "HLS_ORG_UNIT_INTERFACE_PK" PRIMARY KEY ("RECORD_ID")
                                      USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
                                      STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
                                      PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
                                      TABLESPACE "FH_TEST"  ENABLE
                                       ) SEGMENT CREATION IMMEDIATE 
                                      PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
                                      STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
                                      PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
                                      TABLESPACE "FH_TEST" ;
                                     
                                      CREATE UNIQUE INDEX "FH_TEST"."HLS_ORG_UNIT_INTERFACE_PK" ON "FH_TEST"."HLS_ORG_UNIT_INTERFACE" ("RECORD_ID") 
                                      PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
                                      STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
                                      PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
                                      TABLESPACE "FH_TEST" ;
                                     
                                      ALTER TABLE "FH_TEST"."HLS_ORG_UNIT_INTERFACE" ADD CONSTRAINT "HLS_ORG_UNIT_INTERFACE_PK" PRIMARY KEY ("RECORD_ID")
                                      USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
                                      STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
                                      PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
                                      TABLESPACE "FH_TEST"  ENABLE;
                                     
                                      ALTER TABLE "FH_TEST"."HLS_ORG_UNIT_INTERFACE" MODIFY ("RECORD_ID" NOT NULL ENABLE);
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."UNIT_ID" IS '部门id';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."UNIT_CODE" IS '部门编码';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."UNIT_NAME" IS '部门名称';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."SET_UP_DATE" IS '成立日期';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."ENGLISH_NAME" IS '英文名称';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."UNIT_TYPE" IS '部门类型';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."BRANCH_LEADER" IS '分管领导';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."UNIT_PROPERTY" IS '部门属性';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."RESPONSIBILITY_CODE" IS '责任人编码';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."APPROVE_CODE" IS '批准文号';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."APPROVE_UNIT" IS '批准单位';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."PHONE" IS '电话';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."ADDRESS" IS '地址';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."FAX" IS '传真';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."ZIP_CODE" IS '邮编';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."EMAIL" IS '电子邮件';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."LINE_OF_CREDIT" IS '信用额度';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."LEVEL_OF_CREDIT" IS '信用等级';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."DAY_OF_CREDIT" IS '信用天数';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."REMARK" IS '备注';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."START_UP_UTU" IS '是否启用UTU(0->否,1->是)';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."FOR_RETAIL" IS '适用零售';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."INPUT_DATE" IS '录入日期';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."INPUT_NAME" IS '录入员';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."EXPORT_FLAG" IS '发送标志';
                                     
                                       COMMENT ON COLUMN "FH_TEST"."HLS_ORG_UNIT_INTERFACE"."SENDFILENAME" IS '生成文件名';
                               select * from hls_org_unit_interface_v
                               --部门档案接口历史表
                               create table hls_org_unit_interface_history as select * from hls_org_unit_interface where 1=0;
                               select * from hls_org_unit_interface_history;
                               
                               select * from hls_org_unit_interface;
                               select * from hls_journal_sap_log;
                               
                               tre_funds_reservation_pkg;
                               
                               select c.project_id from con_contract c where c.contract_number = 'CON201603001'; -- project_id = 284
                               select p.chance_id from prj_project p where p.project_id = 284  --257
                               select * from prj_chance_service_managers c where c.chance_id = 257;  
                               
                               select * from sys_user u where u.employee_id = 309;
                               
                               select c.contract_id, c.contract_number, c.contract_name
             		from con_contract c,prj_project p,prj_chance_service_managers_lv pc
            	 where data_class = 'NORMAL'
                 and c.project_id = p.project_id
                 and p.chance_id = pc.chance_id;
                 
                 
                 
                 select c.contract_id, c.contract_number, c.contract_name
             		from con_contract c,prj_project p,prj_chance_service_managers_lv pc
            	 where data_class = 'NORMAL'
                 and c.project_id = p.project_id
                 and p.chance_id = pc.chance_id
		 and pc.user_id = 1632;
     
     
     select * from tre_loan_con_other_funds;
     select * from TRE_LOAN_CON_OTHER_716_LV;
     
     
     SELECT l.*,
           ga.account_code,
           hh.journal_num || '-' || l.line_num journal_dtl,
           hh.je_transaction_code,
           hh.journal_num,
           trunc(hh.journal_date) journal_date
      FROM hls_journal_detail l, gld_accounts ga, hls_journal_header hh
     WHERE /*l.journal_header_id = p_hd_id
       AND*/ l.account_id = ga.account_id
       AND hh.journal_header_id = l.journal_header_id;
       select * from gld_accounts;
       
       select v.UNIT_ID,v.UNIT_CODE,v.DESCRIPTION,v.CREATION_DATE from exp_org_unit_vl v;
       select * from exp_org_unit_vl;
       
       select u.description from sys_user u where u.user_id = 
       
       
       SELECT 'CB00' comp
                        FROM dual
                      UNION
                      SELECT 'CB01'
                        FROM dual
                      UNION
                      SELECT 'CB02' FROM dual
                      
                      
                      select * from exp_org_unit;
     
     
           SELECT 1
        --INTO v_1
        FROM hls_org_unit_interface_v
       WHERE unit_id = 431;
       
       
       
       SELECT unit_id, unit_code, unit_desc, rownum rw
                        FROM (select u.unit_id,
                                     u.unit_code,
                                     d.description_text unit_desc
                                from EXP_ORG_UNIT u, fnd_descriptions d
                               where u.description_id = d.description_id
                               order by u.unit_code)
                               
                               delete from hls_org_unit_interface;
                               select * from hls_org_unit_interface;
                               delete from hls_org_unit_interface_history;
                               select * from hls_org_unit_interface_history;
                               
                               select * from exp_org_unit;
                               
                               select * from hls_org_unit_interface_v;
                               
                               
                               SELECT COUNT(1)
      --INTO v_n
      FROM user_tab_columns t
     WHERE t.table_name = 'HLS_ORG_UNIT_INTERFACE'
       AND t.column_name NOT IN ('RECORD_ID',
                                 'UNIT_ID',
                                 'SENDFILENAME',
                                 'SAPSENDFLAG',
                                 'CREATED_BY',
                                 'CREATION_DATE',
                                 'LAST_UPDATED_BY',
                                 'LAST_UPDATE_DATE',
                                 'BATCH_NUMBER');
                                 
                                 
                                 SELECT t.column_name, t.data_type
                    FROM user_tab_columns t
                   WHERE t.table_name = 'HLS_ORG_UNIT_INTERFACE'
                     AND t.column_name NOT IN
                         ('RECORD_ID',
                                 'UNIT_ID',
                                 'SENDFILENAME',
                                 'SAPSENDFLAG',
                                 'CREATED_BY',
                                 'CREATION_DATE',
                                 'LAST_UPDATED_BY',
                                 'LAST_UPDATE_DATE',
                                 'BATCH_NUMBER')
                   ORDER BY t.column_id
                               
                               
                               SELECT DISTINCT (t.unit_id) AS journal_id,
                                        t.unit_code
                          FROM hls_org_unit_interface t
                         WHERE /*t.sendfilename = p_filename
                           AND*/ nvl(t.sapsendflag,'N') = 'N'
                         ORDER BY t.unit_code;
                         
                         select * from hls_org_unit_interface;
                         
                         select * from hls_org_unit_interface;
                         
                         
                         ---- day 2016-03-07
                         ---- 供应商档案   mnemonics 
                         CREATE TABLE "FH_TEST"."HLS_VENDER_INTERFACE" 
                             (	"RECORD_ID" NUMBER NOT NULL ENABLE, 
                            "BP_ID" NUMBER, 
                            "BP_VENDER_CODE" VARCHAR2(20), 
                            "BP_SHORT_NAME" VARCHAR2(60), 
                            "MNEMONICS" VARCHAR2(98), 
                            "BP_TYPE_CODE" VARCHAR2(12), 
                            "CURRENCY" VARCHAR2(100), 
                            "BP_FULL_NAME" VARCHAR2(98), 
                            "HEAD_OFFICE_CODE" VARCHAR2(12), 
                            "ADDRESS_CODE" VARCHAR2(12), 
                            "INDUSTRY_CODE" VARCHAR2(50), 
                            "CUS_CODE" VARCHAR2(20), 
                            "EMPLOYEE_NUM" NUMBER, 
                            "PURCHASE_FLAG" NUMBER, 
                            "OUTSOURCING_FLAG" NUMBER, 
                            "SERVER_FLAG" NUMBER, 
                            "ABROAD_FLAG" NUMBER, 
                            "TAXPAYER_CODE" VARCHAR2(50), 
                            "REGISTERED_CAPITAL" NUMBER, 
                            "CORPORATION" VARCHAR2(10), 
                            "BANK_OF_DEPOSIT" VARCHAR2(30), 
                            "BANK_NUM" VARCHAR2(30), 
                            "TAX_RATES" NUMBER, 
                            "GMP_FLAG" NUMBER, 
                            "ENTERPRISES_TYPE" VARCHAR2(50), 
                            "GMP_GSP_FLAG" NUMBER, 
                            "GMP_GSP_NUM" VARCHAR2(40), 
                            "TERM_BUSINESS" NUMBER, 
                            "BUSINESS_LICENSE_NUM" VARCHAR2(20), 
                            "BUSINESS_LICENSE_DATE_FROM" DATE, 
                            "BUSINESS_LICENSE_DATE_TO" DATE, 
                            "EARLY_WARNING_DAY" NUMBER, 
                            "CERTIFICATE" NUMBER, 
                            "CERTIFICATE_CODE" VARCHAR2(20), 
                            "CERTIFICATE_DATE_FROM" DATE, 
                            "CERTIFICATE_DATE_TO" DATE, 
                            "CERTIFICATE_WARNING_DAY" NUMBER, 
                            "ATTORNEY" NUMBER, 
                            "ATTORNEY_DATE_FROM" DATE, 
                            "ATTORNEY_DATE_TO" DATE, 
                            "ATTORNEY_WARNING_DAY" NUMBER, 
                            "REF_01" VARCHAR2(20), 
                            "REF_02" VARCHAR2(20), 
                            "REF_03" VARCHAR2(20), 
                            "REF_04" VARCHAR2(20), 
                            "REF_05" VARCHAR2(20), 
                            "REF_06" VARCHAR2(20), 
                            "REF_07" VARCHAR2(20), 
                            "REF_08" VARCHAR2(20), 
                            "REF_09" VARCHAR2(20), 
                            "REF_10" VARCHAR2(20), 
                            "REF_11" VARCHAR2(20), 
                            "REF_12" VARCHAR2(20), 
                            "REF_13" VARCHAR2(20), 
                            "REF_14" VARCHAR2(20), 
                            "REF_15" VARCHAR2(20), 
                            "REF_16" VARCHAR2(20), 
                            "BRANCH_UNIT_CODE" VARCHAR2(12), 
                            "EMPLOYEE_CODE" VARCHAR2(10), 
                            "PHONE" VARCHAR2(20), 
                            "FAX" VARCHAR2(20), 
                            "QQ_NUM" VARCHAR2(20), 
                            "MOBILE_PHONE" VARCHAR2(20), 
                            "ZIP_CODE" VARCHAR2(20), 
                            "CONTACT_PERSON" VARCHAR2(10), 
                            "ADDRESS" VARCHAR2(40), 
                            "EMAIL" VARCHAR2(30), 
                            "BALANCE_TYPE" VARCHAR2(20), 
                            "ARRIVED_ADDRESS" VARCHAR2(40), 
                            "FORWARDING_TYPE_CODE" VARCHAR2(10), 
                            "WAREHOUSE_CODE" VARCHAR2(10), 
                            "PAY_BALANCE" NUMBER, 
                            "FEE" NUMBER, 
                            "CREDIT_LEVEL" VARCHAR2(6), 
                            "CREDIT_LIMIT" NUMBER, 
                            "CREDIT_TERM" NUMBER, 
                            "TERM_PAY_CODE" VARCHAR2(20), 
                            "ABC_LEVEL" VARCHAR2(1), 
                            "TAX_INCLUSIVE_PRICE" NUMBER, 
                            "LAST_TRANSACTION_DATE" DATE, 
                            "LAST_TRANSACTION_AMOUNT" NUMBER, 
                            "LAST_PAYMENT_DATE" DATE, 
                            "LAST_PAYMENT_AMOUNT" NUMBER, 
                            "ACCOUNT_PERIOD" NUMBER, 
                            "PROCUREMENT_OUTSOURCING" VARCHAR2(40), 
                            "CONTRACT_DEFAULT" VARCHAR2(40), 
                            "OTHER_PAY" VARCHAR2(40), 
                            "IMPORT" VARCHAR2(40), 
                            "DEVELOP_DATE_FROM" DATE, 
                            "TIME_OUT_DATE" DATE, 
                            "USE_FREQUENTNES" NUMBER, 
                            "BAR_CODE" VARCHAR2(30), 
                            "BELONG_BANK" VARCHAR2(30), 
                            "DEFAULT_OUTSOURCE_WAREHOUSE" VARCHAR2(30), 
                            "NOTE" VARCHAR2(240), 
                            "CREATED_ARCHIVE_PERSON" VARCHAR2(20), 
                            "CREATED_ARCHIVE_DATE" DATE, 
                            "CHANGE_DATE" DATE, 
                            "COUNTRY_CODE" VARCHAR2(40), 
                            "ENGLISH_NAME" VARCHAR2(100), 
                            "ENGLISH_ADD1" VARCHAR2(60), 
                            "ENGLISH_ADD2" VARCHAR2(60), 
                            "ENGLISH_ADD3" VARCHAR2(60), 
                            "ENGLISH_ADD4" VARCHAR2(60), 
                            "FOB" VARCHAR2(60), 
                            "MAIN_CARRIER" VARCHAR2(50), 
                            "COMMISSION_RATE" NUMBER, 
                            "PREMIUM_RATE" NUMBER, 
                            "DOMESTIC_BRANCH_OFFICES" NUMBER, 
                            "BRANCH_OFFICE_ADDR" VARCHAR2(200), 
                            "BRANCH_OFFICE_PHONE" VARCHAR2(100), 
                            "BRANCH_OFFICE_CONTACT" VARCHAR2(50), 
                            "INPUT_DATE" DATE, 
                            "INPUT_NAME" VARCHAR2(100), 
                            "BATCH_NUMBER" VARCHAR2(30), 
                            "EXPORT_FLAG" VARCHAR2(1), 
                            "SENDFILENAME" VARCHAR2(200), 
                            "SAPSENDFLAG" VARCHAR2(1), 
                            "CREATED_BY" NUMBER, 
                            "CREATION_DATE" DATE, 
                            "LAST_UPDATED_BY" NUMBER, 
                            "LAST_UPDATE_DATE" DATE, 
                             CONSTRAINT "VENDER_PK" PRIMARY KEY ("RECORD_ID")
                            USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
                            STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
                            PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
                            TABLESPACE "FH_TEST"  ENABLE
                             ) SEGMENT CREATION IMMEDIATE 
                            PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
                            STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
                            PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
                            TABLESPACE "FH_TEST" ;
                           
                            CREATE UNIQUE INDEX "FH_TEST"."VENDER_PK" ON "FH_TEST"."HLS_VENDER_INTERFACE" ("RECORD_ID") 
                            PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
                            STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
                            PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
                            TABLESPACE "FH_TEST" ;
                           
                            ALTER TABLE "FH_TEST"."HLS_VENDER_INTERFACE" MODIFY ("RECORD_ID" NOT NULL ENABLE);
                           
                            ALTER TABLE "FH_TEST"."HLS_VENDER_INTERFACE" ADD CONSTRAINT "VENDER_PK" PRIMARY KEY ("RECORD_ID")
                            USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
                            STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
                            PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
                            TABLESPACE "FH_TEST"  ENABLE;
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BP_ID" IS '供应商id';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BP_VENDER_CODE" IS '供应商代码';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BP_SHORT_NAME" IS '供应商简称';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."MNEMONICS" IS '助记码';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BP_TYPE_CODE" IS '供应商分类编码';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."CURRENCY" IS '币种';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BP_FULL_NAME" IS '供应商名称';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."HEAD_OFFICE_CODE" IS '供应商总公司编码';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ADDRESS_CODE" IS '地区编码';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."INDUSTRY_CODE" IS '行业编码';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."CUS_CODE" IS '对应客户编码';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."EMPLOYEE_NUM" IS '员工人数';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."PURCHASE_FLAG" IS '是否采购';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."OUTSOURCING_FLAG" IS '是否委外';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."SERVER_FLAG" IS '是否服务';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ABROAD_FLAG" IS '是否国外';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."TAXPAYER_CODE" IS '纳税人登记号';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REGISTERED_CAPITAL" IS '注册资金';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."CORPORATION" IS '法人';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BANK_OF_DEPOSIT" IS '开户银行';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BANK_NUM" IS '银行账号';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."TAX_RATES" IS '税率';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."GMP_FLAG" IS '是否通过GMP认证';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ENTERPRISES_TYPE" IS '企业类型';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."GMP_GSP_FLAG" IS 'GMP-GSP认证';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."GMP_GSP_NUM" IS 'GMP-GSP证书号';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."TERM_BUSINESS" IS '营业执照是否期限管理';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BUSINESS_LICENSE_NUM" IS '营业执照注册号';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BUSINESS_LICENSE_DATE_FROM" IS '营业执照生效日期';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BUSINESS_LICENSE_DATE_TO" IS '营业执照到期日期';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."EARLY_WARNING_DAY" IS '营业执照预警天数';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."CERTIFICATE" IS '经营许可证是否期限管理';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."CERTIFICATE_CODE" IS '生产-经营许可证号';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."CERTIFICATE_DATE_FROM" IS '经营许可证生效日期';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."CERTIFICATE_DATE_TO" IS '经营许可证到期日期';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."CERTIFICATE_WARNING_DAY" IS '经营许可证预警天数';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ATTORNEY" IS '法人委托书是否期限管理';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ATTORNEY_DATE_FROM" IS '法人委托书生效日期';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ATTORNEY_DATE_TO" IS '法人委托书到期日期';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ATTORNEY_WARNING_DAY" IS '法人委托书预警天数';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REF_01" IS '供应商自定义项1';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REF_02" IS '供应商自定义项2';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REF_03" IS '供应商自定义项3';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REF_04" IS '供应商自定义项4';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REF_05" IS '供应商自定义项5';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REF_06" IS '供应商自定义项6';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REF_07" IS '供应商自定义项7';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REF_08" IS '供应商自定义项8';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REF_09" IS '供应商自定义项9';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REF_10" IS '供应商自定义项10';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REF_11" IS '供应商自定义11';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REF_12" IS '供应商自定义项12';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REF_13" IS '供应商自定义项13';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REF_14" IS '供应商自定义项14';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REF_15" IS '供应商自定义项15';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."REF_16" IS '供应商自定义项16';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BRANCH_UNIT_CODE" IS '分管部门编码';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."EMPLOYEE_CODE" IS '专管业务员编码';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."PHONE" IS '电话';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."FAX" IS '传真';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."QQ_NUM" IS 'qq';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."MOBILE_PHONE" IS '手机号';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ZIP_CODE" IS '邮编';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."CONTACT_PERSON" IS '联系人';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ADDRESS" IS '地址';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."EMAIL" IS '邮箱';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BALANCE_TYPE" IS '结算方式';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ARRIVED_ADDRESS" IS '到货地址';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."FORWARDING_TYPE_CODE" IS '发运方式编码';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."WAREHOUSE_CODE" IS '到货仓库编码';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."PAY_BALANCE" IS '应付余额';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."FEE" IS '扣率';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."CREDIT_LEVEL" IS '信用等级';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."CREDIT_LIMIT" IS '信用额度';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."CREDIT_TERM" IS '信用期限';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."TERM_PAY_CODE" IS '付款条件编码';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ABC_LEVEL" IS 'ABC等级';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."TAX_INCLUSIVE_PRICE" IS '单价是否含税';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."LAST_TRANSACTION_DATE" IS '最后交易日期';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."LAST_TRANSACTION_AMOUNT" IS '最后交易金额';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."LAST_PAYMENT_DATE" IS '最后付款日期';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."LAST_PAYMENT_AMOUNT" IS '最后付款金额';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ACCOUNT_PERIOD" IS '账期管理';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."PROCUREMENT_OUTSOURCING" IS '采购委外收付款协议';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."CONTRACT_DEFAULT" IS '合同默认收付款协议';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."OTHER_PAY" IS '其他应付单收付款协议';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."IMPORT" IS '进口收付款协议';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."DEVELOP_DATE_FROM" IS '发展日期';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."TIME_OUT_DATE" IS '停用日期';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."USE_FREQUENTNES" IS '使用频度';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BAR_CODE" IS '对应条形码编码';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BELONG_BANK" IS '所属银行';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."DEFAULT_OUTSOURCE_WAREHOUSE" IS '默认委外仓';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."NOTE" IS '备注';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."CREATED_ARCHIVE_PERSON" IS '建档人';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."CREATED_ARCHIVE_DATE" IS '建档日期';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."CHANGE_DATE" IS '变更日期';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."COUNTRY_CODE" IS '国家';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ENGLISH_NAME" IS '英文名称';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ENGLISH_ADD1" IS '英文地址1';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ENGLISH_ADD2" IS '英文地址2';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ENGLISH_ADD3" IS '英文地址3';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."ENGLISH_ADD4" IS '英文地址4';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."FOB" IS '起运港';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."MAIN_CARRIER" IS '主要承运商';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."COMMISSION_RATE" IS '佣金比率';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."PREMIUM_RATE" IS '保险费率';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."DOMESTIC_BRANCH_OFFICES" IS '国内分支机构';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BRANCH_OFFICE_ADDR" IS '分支机构地址';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BRANCH_OFFICE_PHONE" IS '分支机构电话';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."BRANCH_OFFICE_CONTACT" IS '分支机构联系人';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."INPUT_DATE" IS '录入日期';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."INPUT_NAME" IS '录入员';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."EXPORT_FLAG" IS '发送标识';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."SENDFILENAME" IS '生成文件名';
                           
                             COMMENT ON COLUMN "FH_TEST"."HLS_VENDER_INTERFACE"."SAPSENDFLAG" IS 'sap发送标识';
                         create SEQUENCE hls_vender_interface_s INCREMENT   BY   1
                         --银行账号
                         CREATE TABLE "FH_TEST"."HLS_BANK_ACCOUNT_INTERFACE" 
                                 (	"RECORD_ID" NUMBER NOT NULL ENABLE, 
                                "BP_VENDER_CODE" VARCHAR2(20), 
                                "BANK_ACCOUNT" VARCHAR2(50), 
                                "DEFAULT_PARA" NUMBER, 
                                "BELONG_BANK" VARCHAR2(60), 
                                "BARANCH_BANK" VARCHAR2(50), 
                                "ACCOUNT_NAME" VARCHAR2(60), 
                                "PROVINCE" VARCHAR2(20), 
                                "MUNICIPAL" VARCHAR2(20), 
                                "OFFICE_CODE" VARCHAR2(60), 
                                "CONTACT_BANK_NUM" VARCHAR2(60), 
                                "CONTACT_BANK_NUM2" VARCHAR2(5), 
                                 CONSTRAINT "BANK_ACCOUNT_PK" PRIMARY KEY ("RECORD_ID")
                                USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOCOMPRESS LOGGING
                                TABLESPACE "FH_TEST"  ENABLE
                                 ) SEGMENT CREATION DEFERRED 
                                PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
                                TABLESPACE "FH_TEST" ;
                               
                                CREATE UNIQUE INDEX "FH_TEST"."BANK_ACCOUNT_PK" ON "FH_TEST"."HLS_BANK_ACCOUNT_INTERFACE" ("RECORD_ID") 
                                PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOCOMPRESS LOGGING
                                TABLESPACE "FH_TEST" ;
                               
                                ALTER TABLE "FH_TEST"."HLS_BANK_ACCOUNT_INTERFACE" ADD CONSTRAINT "BANK_ACCOUNT_PK" PRIMARY KEY ("RECORD_ID")
                                USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOCOMPRESS LOGGING
                                TABLESPACE "FH_TEST"  ENABLE;
                               
                                ALTER TABLE "FH_TEST"."HLS_BANK_ACCOUNT_INTERFACE" MODIFY ("RECORD_ID" NOT NULL ENABLE);
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_BANK_ACCOUNT_INTERFACE"."BP_VENDER_CODE" IS '供应商编码';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_BANK_ACCOUNT_INTERFACE"."BANK_ACCOUNT" IS '银行账号';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_BANK_ACCOUNT_INTERFACE"."DEFAULT_PARA" IS '默认值';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_BANK_ACCOUNT_INTERFACE"."BELONG_BANK" IS '所属银行';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_BANK_ACCOUNT_INTERFACE"."BARANCH_BANK" IS '开户银行';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_BANK_ACCOUNT_INTERFACE"."ACCOUNT_NAME" IS '账户名称';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_BANK_ACCOUNT_INTERFACE"."PROVINCE" IS '省份';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_BANK_ACCOUNT_INTERFACE"."MUNICIPAL" IS '市';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_BANK_ACCOUNT_INTERFACE"."OFFICE_CODE" IS '机构号';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_BANK_ACCOUNT_INTERFACE"."CONTACT_BANK_NUM" IS '联行号';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_BANK_ACCOUNT_INTERFACE"."CONTACT_BANK_NUM2" IS '联行号II';
                         create SEQUENCE tre_funds_reservation_return_s INCREMENT   BY   1
                         
                         --供应商档案历史记录
                         create table hls_vender_interface_history as select * from hls_vender_interface where 1=0;
                         
                         create table hls_vender_bank_ac_interface_h as select * from hls_vender_bank_acc_interface where 1=0; 
                         
                         hls_vender_interface_v;
                         
                         SELECT unit_id, unit_code, unit_desc, rownum rw
                        FROM (select u.unit_id,
                                     u.unit_code,
                                     d.description_text unit_desc
                                from EXP_ORG_UNIT u, fnd_descriptions d
                               where u.description_id = d.description_id
                               order by u.unit_code);
                        select * from hls_bp_master;
                        select bp_id, bp_code, bp_name, rownum rw
                          from (select b.bp_id, b.bp_code, b.bp_name
                                  from hls_bp_master b
                                 where b.bp_category = 'VENDER'
                                 order by b.bp_code);
                        select * from hls_bp_master_all_v;
                        
                         
                         
                         select record_id,bp_id,bp_vender_code,bp_short_name,mnemonics,bp_type_code,currency,bp_full_name,head_office_code,address_code,industry_code,cus_code,employee_num,purchase_flag,outsourcing_flag,server_flag,abroad_flag,taxpayer_code,registered_capital,corporation,bank_of_deposit,bank_num,tax_rates,gmp_flag,enterprises_type,gmp_gsp_flag,gmp_gsp_num,term_business,business_license_num,business_license_date_from,business_license_date_to,early_warning_day,certificate,certificate_code,certificate_date_from,certificate_date_to,certificate_warning_day,attorney,attorney_date_from,attorney_date_to,attorney_warning_day,ref_01,ref_02,ref_03,ref_04,ref_05,ref_06,ref_07,ref_08,ref_09,ref_10,ref_11,ref_12,ref_13,ref_14,ref_15,ref_16,branch_unit_code,employee_code,phone,fax,qq_num,mobile_phone,zip_code,contact_person,address,email,balance_type,arrived_address,forwarding_type_code,warehouse_code,pay_balance,fee,credit_level,credit_limit,credit_term,term_pay_code,abc_level,tax_inclusive_price,last_transaction_date,last_transaction_amount,last_payment_date,last_payment_amount,account_period,procurement_outsourcing,contract_default,other_pay,import,develop_date_from,time_out_date,use_frequentnes,bar_code,belong_bank,default_outsource_warehouse,note,created_archive_person,created_archive_date,change_date,country_code,english_name,english_add1,english_add2,english_add3,english_add4,fob,main_carrier,commission_rate,premium_rate,domestic_branch_offices,branch_office_addr,branch_office_phone,branch_office_contact,input_date,input_name,batch_number,export_flag,sendfilename,sapsendflag  from hls_vender_interface
                         
                         
                         --供应商银行账号
                         create table hls_vender_bank_acc_interface as select * from hls_bank_account_interface where 1=0;
                         
                         
                         
                         
                         
                         
                         
                         
                         
                         --客户档案
                         CREATE TABLE "FH_TEST"."HLS_CUSTOMER_INTERFACE" 
                                   (	"RECORD_ID" NUMBER NOT NULL ENABLE, 
                                  "BP_ID" NUMBER, 
                                  "CUSTOMER_CODE" VARCHAR2(20), 
                                  "CUS_SHORT_NAME" VARCHAR2(60), 
                                  "CUS_CLASS_CODE" VARCHAR2(12), 
                                  "CURRENCY" VARCHAR2(10), 
                                  "CUS_NAME" VARCHAR2(98), 
                                  "MNEMONICS" VARCHAR2(98), 
                                  "CUS_HEAD_CODE" VARCHAR2(20), 
                                  "ADDRESS_CODE" VARCHAR2(12), 
                                  "INDUSTRY_CODE" VARCHAR2(10), 
                                  "CUS_LEVEL_CODE" VARCHAR2(20), 
                                  "VENDER_CODE" VARCHAR2(20), 
                                  "TAXPAYER_CODE" VARCHAR2(50), 
                                  "CORPORATION" VARCHAR2(10), 
                                  "ISSUING_OFFICE" VARCHAR2(60), 
                                  "DOMESTIC_FLAG" NUMBER, 
                                  "ABROAD_FLAG" NUMBER, 
                                  "SERVER_FLAG" NUMBER, 
                                  "TERM_BUSINESS" NUMBER, 
                                  "BUSINESS_LICENSE_NUM" VARCHAR2(20), 
                                  "BUSINESS_LICENSE_DATE_FROM" DATE, 
                                  "BUSINESS_LICENSE_DATE_TO" DATE, 
                                  "BUSINESS_LICENSE_WARNING_DAY" NUMBER, 
                                  "BUSINESS_LICENSE_SCOPE" VARCHAR2(100), 
                                  "CERTIFICATE" NUMBER, 
                                  "CERTIFICATE_DATE_FROM" DATE, 
                                  "CERTIFICATE_DATE_TO" DATE, 
                                  "CERTIFICATE_CODE" VARCHAR2(20), 
                                  "CERTIFICATE_WARNING_DAY" NUMBER, 
                                  "CERTIFICATE_SCOPE" VARCHAR2(100), 
                                  "GSP_CODE" VARCHAR2(30), 
                                  "GSP_DATE_FROM" DATE, 
                                  "GSP_DATE_TO" DATE, 
                                  "GSP_WARNING_DAY" NUMBER, 
                                  "GSP_SCOPE" VARCHAR2(100), 
                                  "ATTORNEY" NUMBER, 
                                  "ATTORNEY_DATE_FROM" DATE, 
                                  "ATTORNEY_DATE_TO" DATE, 
                                  "ATTORNEY_WARNING_DAY" NUMBER, 
                                  "REF_01" VARCHAR2(20), 
                                  "REF_02" VARCHAR2(20), 
                                  "REF_03" VARCHAR2(20), 
                                  "REF_04" VARCHAR2(20), 
                                  "REF_05" VARCHAR2(20), 
                                  "REF_06" VARCHAR2(20), 
                                  "REF_07" VARCHAR2(20), 
                                  "REF_08" VARCHAR2(20), 
                                  "REF_09" VARCHAR2(20), 
                                  "REF_10" VARCHAR2(20), 
                                  "REF_11" VARCHAR2(20), 
                                  "REF_12" VARCHAR2(20), 
                                  "REF_13" VARCHAR2(20), 
                                  "REF_14" VARCHAR2(20), 
                                  "REF_15" VARCHAR2(20), 
                                  "REF_16" VARCHAR2(20), 
                                  "CUS_MANAGER_TYPE_CODE" VARCHAR2(32), 
                                  "CUS_TYPE_FLAG" NUMBER, 
                                  "POTENTIAL_CUSTOMER_CODE" VARCHAR2(20), 
                                  "INPUT_DATE" DATE, 
                                  "INPUT_NAME" VARCHAR2(50), 
                                  "BATCH_NUMBER" VARCHAR2(100), 
                                  "EXPORT_FLAG" VARCHAR2(1), 
                                  "SENDFILENAME" VARCHAR2(200), 
                                  "SAPSENDFLAG" VARCHAR2(1), 
                                  "CREATED_BY" NUMBER, 
                                  "CREATION_DATE" DATE, 
                                  "LAST_UPDATED_BY" NUMBER, 
                                  "LAST_UPDATE_DATE" DATE, 
                                   CONSTRAINT "CUSMETOR_INTERFACE_PK" PRIMARY KEY ("RECORD_ID")
                                  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
                                  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
                                  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
                                  TABLESPACE "FH_TEST"  ENABLE
                                   ) SEGMENT CREATION IMMEDIATE 
                                  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
                                  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
                                  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
                                  TABLESPACE "FH_TEST" ;
                                 
                                  CREATE UNIQUE INDEX "FH_TEST"."CUSMETOR_INTERFACE_PK" ON "FH_TEST"."HLS_CUSTOMER_INTERFACE" ("RECORD_ID") 
                                  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
                                  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
                                  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
                                  TABLESPACE "FH_TEST" ;
                                 
                                  ALTER TABLE "FH_TEST"."HLS_CUSTOMER_INTERFACE" ADD CONSTRAINT "CUSMETOR_INTERFACE_PK" PRIMARY KEY ("RECORD_ID")
                                  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
                                  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
                                  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
                                  TABLESPACE "FH_TEST"  ENABLE;
                                 
                                  ALTER TABLE "FH_TEST"."HLS_CUSTOMER_INTERFACE" MODIFY ("RECORD_ID" NOT NULL ENABLE);
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."BP_ID" IS '承租人（客户）id';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."CUSTOMER_CODE" IS '客户编码';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."CUS_SHORT_NAME" IS '客户简称';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."CUS_CLASS_CODE" IS '客户分类编码';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."CURRENCY" IS '币种';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."CUS_NAME" IS '客户名称';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."MNEMONICS" IS '助记码';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."CUS_HEAD_CODE" IS '客户总公司编码';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."ADDRESS_CODE" IS '地区编码';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."INDUSTRY_CODE" IS '行业编码';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."CUS_LEVEL_CODE" IS '客户级别编码';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."VENDER_CODE" IS '对应供应商编码';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."TAXPAYER_CODE" IS '纳税人登记号';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."CORPORATION" IS '法人';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."ISSUING_OFFICE" IS '开票单位';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."DOMESTIC_FLAG" IS '国内(1-是，0-否)';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."ABROAD_FLAG" IS '国外(1-是，0-否)';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."SERVER_FLAG" IS '服务(1-是，0-否)';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."TERM_BUSINESS" IS '营业执照是否期限管理(1-是，0-否)';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."BUSINESS_LICENSE_NUM" IS '营业执照注册号';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."BUSINESS_LICENSE_DATE_FROM" IS '营业执照生效日期';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."BUSINESS_LICENSE_DATE_TO" IS '营业执照到期日期';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."BUSINESS_LICENSE_WARNING_DAY" IS '营业执照预警天数';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."BUSINESS_LICENSE_SCOPE" IS '营业执照经营范围';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."CERTIFICATE" IS '经营许可证是否期限管理(1-是，0-否)';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."CERTIFICATE_DATE_FROM" IS '经营许可证生效日期';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."CERTIFICATE_DATE_TO" IS '经营许可证到期日期';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."CERTIFICATE_CODE" IS '经营许可证号';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."CERTIFICATE_WARNING_DAY" IS '经营许可证预警天数';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."CERTIFICATE_SCOPE" IS '经营许可证经营范围';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."GSP_CODE" IS 'GSP认证证书号';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."GSP_DATE_FROM" IS 'GSP认证生效日期';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."GSP_DATE_TO" IS 'GSP认证到期日期';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."GSP_WARNING_DAY" IS 'GSP认证预警天数';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."GSP_SCOPE" IS 'GSP认证经营范围';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."ATTORNEY" IS '法人委托书是否期限管理(1-是，0-否)';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."ATTORNEY_DATE_FROM" IS '法人委托书生效日期';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."ATTORNEY_DATE_TO" IS '法人委托书到期日期';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."ATTORNEY_WARNING_DAY" IS '法人委托书预警天数';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."REF_01" IS '客户自定义项1';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."REF_02" IS '客户自定义项2';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."REF_03" IS '客户自定义项3';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."REF_04" IS '客户自定义项4';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."REF_05" IS '客户自定义项5';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."REF_06" IS '客户自定义项6';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."REF_07" IS '客户自定义项7';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."REF_08" IS '客户自定义项8';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."REF_09" IS '客户自定义项9';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."REF_10" IS '客户自定义项10';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."REF_11" IS '客户自定义项11';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."REF_12" IS '客户自定义项12';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."REF_13" IS '客户自定义项13';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."REF_14" IS '客户自定义项14';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."REF_15" IS '客户自定义项15';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."REF_16" IS '客户自定义项16';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."CUS_MANAGER_TYPE_CODE" IS '客户管理类型编码';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."CUS_TYPE_FLAG" IS '客户标识(0：正式客户，1：潜在客户)';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."POTENTIAL_CUSTOMER_CODE" IS '潜在客户编码';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."INPUT_DATE" IS '录入日期';
                                 
                                   COMMENT ON COLUMN "FH_TEST"."HLS_CUSTOMER_INTERFACE"."INPUT_NAME" IS '录入员';
                         --客户-联系
                         CREATE TABLE "FH_TEST"."HLS_CUS_CONTACT_INTERFACE" 
                                 (	"RECORD_ID" NUMBER, 
                                "CUSTOMER_CODE" VARCHAR2(20), 
                                "BRANCH_UNIT_CODE" VARCHAR2(12), 
                                "EMPLOYEE_CODE" VARCHAR2(10), 
                                "PHONE" VARCHAR2(20), 
                                "FAX" VARCHAR2(20), 
                                "QQ" VARCHAR2(20), 
                                "MOBILE_PHONE" VARCHAR2(20), 
                                "ZIP_CODE" VARCHAR2(20), 
                                "CONTACT_PERSON" VARCHAR2(10), 
                                "ADDRESS" VARCHAR2(40), 
                                "EMAIL" VARCHAR2(30), 
                                "BALACE_TYPE" VARCHAR2(20), 
                                "FORWARDING_TYPE" VARCHAR2(10), 
                                "DELIVERY_WAREHOUSE" VARCHAR2(10), 
                                "SIGN_BACK_FLAG" NUMBER DEFAULT 0, 
                                 CONSTRAINT "CUS_CONTACT_PK" PRIMARY KEY ("RECORD_ID")
                                USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOCOMPRESS LOGGING
                                TABLESPACE "FH_TEST"  ENABLE
                                 ) SEGMENT CREATION DEFERRED 
                                PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
                                TABLESPACE "FH_TEST" ;
                               
                                CREATE UNIQUE INDEX "FH_TEST"."CUS_CONTACT_PK" ON "FH_TEST"."HLS_CUS_CONTACT_INTERFACE" ("RECORD_ID") 
                                PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOCOMPRESS LOGGING
                                TABLESPACE "FH_TEST" ;
                               
                                ALTER TABLE "FH_TEST"."HLS_CUS_CONTACT_INTERFACE" ADD CONSTRAINT "CUS_CONTACT_PK" PRIMARY KEY ("RECORD_ID")
                                USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOCOMPRESS LOGGING
                                TABLESPACE "FH_TEST"  ENABLE;
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CONTACT_INTERFACE"."CUSTOMER_CODE" IS '客户编码';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CONTACT_INTERFACE"."BRANCH_UNIT_CODE" IS '分管部门编码';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CONTACT_INTERFACE"."EMPLOYEE_CODE" IS '专管业务员编码';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CONTACT_INTERFACE"."PHONE" IS '电话';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CONTACT_INTERFACE"."FAX" IS '传真';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CONTACT_INTERFACE"."QQ" IS 'qq';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CONTACT_INTERFACE"."MOBILE_PHONE" IS '手机';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CONTACT_INTERFACE"."ZIP_CODE" IS '邮编';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CONTACT_INTERFACE"."CONTACT_PERSON" IS '联系人';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CONTACT_INTERFACE"."ADDRESS" IS '地址';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CONTACT_INTERFACE"."EMAIL" IS 'email';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CONTACT_INTERFACE"."BALACE_TYPE" IS '计算方式';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CONTACT_INTERFACE"."FORWARDING_TYPE" IS '发运方式';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CONTACT_INTERFACE"."DELIVERY_WAREHOUSE" IS '发货仓库编码';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CONTACT_INTERFACE"."SIGN_BACK_FLAG" IS '需要签回(0-不需要，1-需要，默认0)';
                         --客户-信用
                         CREATE TABLE "FH_TEST"."HLS_CUS_CREDIT_INTERFACE" 
                                 (	"RECORD_ID" NUMBER, 
                                "CUSTOMER_CODE" VARCHAR2(20), 
                                "AMOUNT_RECEIVABLE" NUMBER, 
                                "CREDIT_UNIT" VARCHAR2(20), 
                                "FEE" NUMBER, 
                                "CREDIT_LEVEL" VARCHAR2(6), 
                                "CREDIT_LIMIT" NUMBER, 
                                "CREDIT_TERM" NUMBER, 
                                "TERM_PAY_CODE" VARCHAR2(20), 
                                "PRICE_LEVEL" VARCHAR2(20), 
                                "HEAD_CONTROL_LIMIT" NUMBER, 
                                "CONTROL_LIMIT_FLAG" NUMBER, 
                                "CONTROL_TERM_FLAG" NUMBER, 
                                "LIMIT_PIN_FLAG" NUMBER, 
                                "LAST_TRANSACTION_DATE" DATE, 
                                "LAST_TRANSACTION_AMOUNT" NUMBER, 
                                "LAST_RECEIVABLE_DATE" DATE, 
                                "LAST_RECEIVABLE_AMOUNT" NUMBER, 
                                "SALES_DEFAULT" VARCHAR2(40), 
                                "EXPORT_DEFAULT" VARCHAR2(40), 
                                "CONTRACT_DEFAULT" VARCHAR2(40), 
                                "OTHER_PAY" VARCHAR2(40), 
                                "IMPORT_BROKER" VARCHAR2(40), 
                                 CONSTRAINT "CUS_CREDIT_PK" PRIMARY KEY ("RECORD_ID")
                                USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOCOMPRESS LOGGING
                                TABLESPACE "FH_TEST"  ENABLE
                                 ) SEGMENT CREATION DEFERRED 
                                PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
                                TABLESPACE "FH_TEST" ;
                               
                                CREATE UNIQUE INDEX "FH_TEST"."CUS_CREDIT_PK" ON "FH_TEST"."HLS_CUS_CREDIT_INTERFACE" ("RECORD_ID") 
                                PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOCOMPRESS LOGGING
                                TABLESPACE "FH_TEST" ;
                               
                                ALTER TABLE "FH_TEST"."HLS_CUS_CREDIT_INTERFACE" ADD CONSTRAINT "CUS_CREDIT_PK" PRIMARY KEY ("RECORD_ID")
                                USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOCOMPRESS LOGGING
                                TABLESPACE "FH_TEST"  ENABLE;
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."CUSTOMER_CODE" IS '客户编码';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."AMOUNT_RECEIVABLE" IS '应收余额';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."CREDIT_UNIT" IS '信用单位';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."FEE" IS '扣率';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."CREDIT_LEVEL" IS '信用等级';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."CREDIT_LIMIT" IS '信用额度';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."CREDIT_TERM" IS '信用期限';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."TERM_PAY_CODE" IS '付款条件编码';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."PRICE_LEVEL" IS '价格级别';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."HEAD_CONTROL_LIMIT" IS '是否按总公司控制信用额度(1-是，0-否)';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."CONTROL_LIMIT_FLAG" IS '是否控制信用额度';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."CONTROL_TERM_FLAG" IS '是否控制信用期限';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."LIMIT_PIN_FLAG" IS '是否限销';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."LAST_TRANSACTION_DATE" IS '最后交易日期';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."LAST_TRANSACTION_AMOUNT" IS '最后交易金额';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."LAST_RECEIVABLE_DATE" IS '最后收款日期';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."LAST_RECEIVABLE_AMOUNT" IS '最后收款金额';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."SALES_DEFAULT" IS '销售默认收付款协议';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."EXPORT_DEFAULT" IS '出口默认收付款协议';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."CONTRACT_DEFAULT" IS '合同默认收付款协议';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."OTHER_PAY" IS '其他应付单收付款协议';
                               
                                 COMMENT ON COLUMN "FH_TEST"."HLS_CUS_CREDIT_INTERFACE"."IMPORT_BROKER" IS '代理进口默认收付款协议';
                         --客户-出口
                         create table hls_cus_export_interface(
                                record_id                           number,
                                customer_code                       varchar2(20),
                                country_code                        varchar2(40),
                                port_to_destination                 varchar2(10),
                                main_carrier                        varchar2(20),
                                english_name                        varchar2(100),
                                english_addr1                       varchar2(60),
                                english_addr2                       varchar2(60),
                                english_addr3                       varchar2(60),
                                english_addr4                       varchar2(60),
                                commission_rate                     number,
                                premium_rate                        number,
                                branch_offices_flag                 number,
                                branch_office_addr                  varchar2(255),
                                branch_office_phone                 varchar2(100),
                                branch_office_contact               varchar2(50) 
                         )
                         --客户-收货地址
                         create table hls_cus_ship_addr_interface(
                                record_id                           number,
                                customer_code                       varchar2(20),
                                ship_addr_code                      varchar2(30),
                                default_para                        number,
                                ship_address                        varchar2(255),
                                english_address                     varchar2(255),
                                english_address2                    varchar2(255),
                                english_address3                    varchar2(255),
                                english_address4                    varchar2(255),
                                receiving_unit                      varchar2(255),
                                contact_person                      varchar2(50)
                                
                         )
                         
                         --客户-银行账号
                         create table hls_cus_bank_acc_interface as select * from hls_bank_account_interface where 1=0;
                         
                         --客户-开票单位
                         create table hls_cus_issue_interface(
                                record_id                        number,
                                bp_vender_code                   varchar2(20),
                                issue_unit_code                  varchar2(20),
                                default_para                     number
                         )
                         
                         --客户-相关员工
                         create table hls_cus_relate_staff_interface(
                                record_id                        number,
                                bp_vender_code                   varchar2(20),
                                operatorer_code                  varchar2(20),
                                main_flag                        number
                         )
                         
                         --客户-管理维度
                         create table hls_manage_dimens_interface(
                                record_id                        number,
                                bp_vender_code                   varchar2(20),
                                manage_dimens_type               number,
                                manage_dimens_code               varchar2(20)
                         )
                         
                         --客户-其他
                         create table hls_cus_else_interface(
                                record_id                        number,
                                bp_vender_code                   varchar2(20),
                                develop_date_from                date,
                                time_out_date                    date,
                                note                             varchar2(240),
                                retail_flag                      number,
                                retail_deposit_ratio             number,
                                store_collection                 number,
                                counter_settlement_fee           number,
                                created_archive_person           varchar2(20),
                                created_archive_date             date,
                                change_person                    varchar2(20),
                                change_date                      date,
                                longitude_and_latitude           varchar2(128),
                                tax_rate                         number        
                         )                    
                         
                         
                         
                         
                         --人员档案
                         create table hls_employee_interface(
                                record_id                        number,
                                employee_code                    varchar2(20),
                                employee_name                    varchar2(40),
                                executive_unit_code              varchar2(12),
                                hire_status                      number,
                                employee_type                    varchar2(30),
                                gender                           number,
                                sale_flag                        number,
                                hire_type                        varchar2(5),
                                id_type                          number,
                                class_group                      varchar2(30),
                                position                         varchar2(20),
                                position_rank                    varchar2(30),
                                position_level                   varchar2(30),
                                work_code                        varchar2(50),
                                row_num                          number,
                                born_date                        date,
                                native_place                     varchar2(30),
                                nation                           varchar2(30),
                                health_status                    varchar2(30),
                                marry_statu                      number,
                                id_num                           varchar2(18),
                                census_register                  varchar2(30),
                                before_used_name                 varchar2(20),
                                join_work_date                   date,
                                enter_industry_date              date,
                                formalization_date               date,
                                social_security_code             varchar2(25),
                                phone                            varchar2(100),
                                home_phone                       varchar2(100),
                                work_phone                       varchar2(100),
                                line_phone                       varchar2(100),
                                email                            varchar2(100),
                                postal_address                   varchar2(255),
                                zip_code                         varchar2(6),
                                home_address                     varchar2(255),
                                personal_website                 varchar2(50),
                                work_station                     varchar2(20),
                                enter_unit_date                  date,
                                bank_code                        varchar2(5),
                                bank_account                     varchar2(50),
                                probation_flag                   number,
                                unit_code                        varchar2(12),
                                staff_attribute                  varchar2(20),
                                credit_limit                     number,
                                credit_term                      number,
                                credit_level                     varchar2(6),
                                effective_date_from              date,
                                effective_date_to                date,
                                input_date                       date,
                                input_name                       varchar2(50)
                         )
                         
                         -- 项目档案
                         
                         
                         
                         
                         
                         select b.bp_code,b. from hls_bp_master b
                         select * from hls_bp_master_v;
                         select * from hls_bp_master_v b,fnd_companies_vl fc
                         
                         select fc.company_short_name  from hls_bp_master         t,
                                       hls_bp_master_company c,
                                       fnd_companies_vl      fc
                                where t.bp_id = c.bp_id
                                  and c.company_id = fc.company_id
                                
                                
                                select * from hls_bp_master_company c order by c.bp_id;
                                
                                
                                tre_funds_reservation_pkg.confirm_reservation
                                
                                con_visit_report_pkg.hds_report_approve_finish;
                                
                                hls_dayend_pkg.dayend
                                
                                select * from tre_funds_reservation;
                                
                                select * from TRE_FUNDS_RESERVATION_TEMP;
                                
                                
                                CREATE TABLE "TRE_FUNDS_RESERVATION_TEMP" 
   (	"RESERVATION_ID" NUMBER, 
	"STATUS" VARCHAR2(30), 
	"CREATED_BY" NUMBER, 
	"CREATION_DATE" DATE, 
	"LAST_UPDATED_BY" NUMBER, 
	"LAST_UPDATE_DATE" DATE, 
	"RECORD_ID" NUMBER, 
	"SESSION_ID" NUMBER
   )
   
   
   tre_funds_reservation_pkg;
   
   
   select * from tre_funds_reservation_return_v t order by t.return_date;
   
   
   select * from hls_bp_master_v;
   select b.bp_code,b.
                     from hls_bp_master b;
                     
                     select t.bp_code,
                            fc.company_short_name,
                            t.ref_v08,
                            t.currency
                       from hls_bp_master         t,
                            hls_bp_master_company c,
                            fnd_companies_vl      fc
                      where t.bp_id = c.bp_id
                        and c.company_id = fc.company_id
                     
                     
  select * from hls_bp_master;
  
  
  select bp_id, bp_code, bp_name, rownum rw
                          from (select b.bp_id, b.bp_code, b.bp_name
                                  from hls_bp_master b
                                 where b.bp_category = 'VENDER'
                                 order by b.bp_code);
                                 
                                 select * from hls_vender_interface;
                                 select * from hls_vender_interface_history;
                                 delete from hls_vender_interface;
                                 
                                 select * from hls_vender_interface_v;
                                 
                                 select t.bp_code,
                            t.bp_name,
                            t.ref_v08,
                            t.currency
                       from hls_bp_master         t,
                            hls_bp_master_company c,
                            fnd_companies_vl      fc
                      where t.bp_id = c.bp_id
                        and c.company_id = fc.company_id
                        and t.bp_category = 'VENDER';
                        
                        
                        SELECT * from hls_bp_master         t,
                            hls_bp_master_company c,
                            fnd_companies_vl      fc
                            where t.bp_id = c.bp_id
                        and c.company_id = fc.company_id
                        and t.bp_category = 'VENDER';
                        
                        
                        SELECT t.batch_number
                        FROM hls_vender_interface t
                       WHERE nvl(t.sapsendflag,'N') = 'N'
                         --AND t.batch_number = to_date(2016-03-08 08:48:46)
                      --AND t.bukrs = c_company.comp
                       GROUP BY t.batch_number;
                       
                       select * from hls_vender_interface;
                       
                       
                     -- DAY 2016-03-08
                     
                       SELECT unit_id, unit_code, unit_desc, rownum rw
                        FROM (select u.unit_id,
                                     u.unit_code,
                                     d.description_text unit_desc
                                from EXP_ORG_UNIT u, fnd_descriptions d
                               where u.description_id = d.description_id
                               order by u.unit_code);
                               
                               select * from hls_org_unit_interface;
                               
                               select v.UNIT_ID,
                          v.UNIT_CODE,
                          v.DESCRIPTION,
                          v.CREATION_DATE
                     from exp_org_unit_vl v;
                     
                     select * from hls_journal_sap_log order by batch_number;
                     select * from hls_vender_interface;
                     delete from hls_vender_interface;
                     select * from hls_vender_interface_history;
                     delete from hls_vender_interface_history;
                     select * from hls_vender_interface_v;
                     
                     select * from fnd_descriptions d where d.description_text like '%人名币%';
                     select * from sys_code_values_v v where v.code_value = 'CNY';
                     SELECT t.batch_number
                        FROM hls_vender_interface t
                       WHERE nvl(t.sapsendflag,'N') = 'N'
                         AND t.batch_number = '2016-03-08 09:49:32'
                      --AND t.bukrs = c_company.comp
                       GROUP BY t.batch_number;
                       
                       SELECT 'VENDER00' comp
                        FROM dual
                      UNION
                      SELECT 'VENDER01'
                        FROM dual
                      UNION
                      SELECT 'VENDER02' FROM dual;
                      select decode(v.code) from sys_codes v;
                      
                      
                      select * from hls_customer_interface;
                      select * from hls_customer_interface_history;
                      delete from hls_customer_interface;
                      delete from hls_customer_interface_history;
                      create table hls_customer_interface_history as select * from hls_customer_interface where 1=0;
                      create SEQUENCE hls_customer_interface_s INCREMENT   BY   1;
                      
                      select * from hls_customer_interface_v
                      
                      select record_id,bp_id,customer_code,cus_short_name,cus_class_code,currency,cus_name,mnemonics,cus_head_code,address_code,industry_code,cus_level_code,vender_code,taxpayer_code,corporation,issuing_office,domestic_flag,abroad_flag,server_flag,term_business,business_license_num,business_license_date_from,business_license_date_to,business_license_warning_day,business_license_scope,certificate,certificate_date_from,certificate_date_to,certificate_code,certificate_warning_day,certificate_scope,gsp_code,gsp_date_from,gsp_date_to,gsp_warning_day,gsp_scope,attorney,attorney_date_from,attorney_date_to,attorney_warning_day,ref_01,ref_02,ref_03,ref_04,ref_05,ref_06,ref_07,ref_08,ref_09,ref_10,ref_11,ref_12,ref_13,ref_14,ref_15,ref_16,cus_manager_type_code,cus_type_flag,potential_customer_code,input_date,input_name  from hls_customer_interface
                     
                      select * from hls_journal_sap_log order by batch_number;
                      
                      select bp_id, bp_code, bp_name, rownum rw
                          from (select b.bp_id, b.bp_code, b.bp_name
                                  from hls_bp_master b
                                 where b.bp_category = 'TENANT'
                                 order by b.bp_code)
                      
                      

                       
                      --人员接口
                      select * from hls_employee_interface;
                      select * from hls_employee_interface_history;
                      drop table hls_employee_interface_history;
                      
                      
                      create table hls_employee_interface_history as select * from hls_employee_interface where 1=0;
                      
                      create SEQUENCE hls_employee_interface_s INCREMENT   BY   1;
                      
                      select * from hls_employee_interface_v;
                      
                      delete from hls_employee_interface;
                      delete from hls_employee_interface_history;
                      
                      select record_id,employee_id,employee_code,employee_name,executive_unit_code,hire_status,employee_type,gender,sale_flag,hire_type,id_type,class_group,position,position_rank,position_level,work_code,row_num,born_date,native_place,nation,health_status,marry_status,id_code,census_register,before_used_name,join_work_date,enter_industry_date,formalization_date,social_security_code,phone,home_phone,work_phone,line_phone,email,postal_address,zip_code,home_address,personal_website,work_station,enter_unit_date,bank_code,bank_account,probation_flag,unit_code,staff_attribute,credit_limit,credit_term,credit_level,effective_date_from,effective_date_to,input_date,input_name from hls_employee_interface;
                      ---- 尹婕铭  0481  未分配岗位
                      select e.employee_id,e.employee_code,e.name,() from exp_employees e;
                      select u.unit_name from exp_employees e,Exp_Org_Position op,exp_org_unit_v u,EXP_EMPLOYEE_ASSIGNS ea where e.employee_id(+) = ea.employee_id and ea.position_id = op.position_id and op.unit_id = u.unit_id and ea.primary_position_flag = 'Y' order by e.employee_code;
                      
                      select ee.employee_id,
                             ee.employee_code,
                             ee.name,
                             (select u.unit_name
                                from exp_employees        e,
                                     Exp_Org_Position     op,
                                     exp_org_unit_v       u,
                                     EXP_EMPLOYEE_ASSIGNS ea
                               where e.employee_id(+) = ea.employee_id
                                 and ea.position_id = op.position_id
                                 and op.unit_id = u.unit_id
                                 and ea.primary_position_flag = 'Y'
                                 and e.employee_id = ee.employee_id) unit_name,
                             (select 10 from dual)hire_status,   
                                 
                             decode((select (select sr.role_id
                                              from sys_user_role_groups sr
                                             where sr.user_id = u.user_id
                                               and sr.role_id = 574)
                                      from sys_user u
                                     where u.employee_id = ee.employee_id),
                                    574,
                                    1,
                                    0) sale_flag
                        from exp_employees ee
                       order by ee.employee_code;
                       
                       
                       select (select sr.role_id from sys_user_role_groups sr where sr.user_id = u.user_id) from sys_user u where  u.employee_id = 146
                       
                       select * from exp_employees;
                       select * from sys_user_role_groups
                       select * from sys_role_vl;
                       
                       select * from sys_user_role_groups_vl sr where sr.role_code in ('1037','1038','1042');  --code 1037,1038,1042  id 574
                       
                       select * from sys_user_role_groups sr where sr.role_id = 574;
                       
                       select * from sys_role r where r.role_code in ('1037','1038','1042');   -- 574,575,597
                       
                       select 1 from dual where
                       
                       select su.description,sr.role_code,sr.role_description from sys_user su,sys_user_role_groups_vl sr where su.user_id = sr.user_id
                       
                       select * from sys_user_role_groups;
                      
                      --部门
                      select * from hls_org_unit_interface_v;
                      delete from hls_org_unit_interface;
                      delete from hls_org_unit_interface_history;
                      --供应商
                      select * from hls_vender_interface_v;
                      delete from hls_vender_interface;
                      delete from hls_vender_interface_history;
                      --客户
                      select * from hls_customer_interface_v;
                      delete from hls_customer_interface;
                      delete from hls_customer_interface_history;
                      --人员
                      select * from hls_employee_interface_v;
                      delete from hls_employee_interface;
                      delete from hls_employee_interface_history;
                      
                      --日志
                      select * from HLS_JOURNAL_SAP_INTF_LOG order by creation_date desc;
                      delete from HLS_JOURNAL_SAP_INTF_LOG;
                      select * from hls_journal_sap_log order by creation_date desc;
                      delete from hls_journal_sap_log;
                      
                            select u.description  from sys_user u where u.user_id = 1;
                      
                      
select nvl('供应商代码','')||chr(9)||nvl('供应商简称','')||chr(9)||nvl('助记码','')||chr(9)||nvl('供应商分类编码','')||chr(9)||nvl('币种','')||chr(9)||nvl('供应商名称','')||chr(9)||nvl('供应商总公司编码','')||chr(9)||nvl('地区编码','')||chr(9)||nvl('行业编码','')||chr(9)||nvl('对应客户编码','')||chr(9)||nvl('员工人数','')||chr(9)||nvl('是否采购(1-是，0-否)','')||chr(9)||nvl('是否委外(1-是，0-否)','')||chr(9)||nvl('是否服务(1-是，0-否)','')||chr(9)||nvl('是否国外(1-是，0-否)','')||chr(9)||nvl('纳税人登记号','')||chr(9)||nvl('注册资金','')||chr(9)||nvl('法人','')||chr(9)||nvl('开户银行','')||chr(9)||nvl('银行账号','')||chr(9)||nvl('税率','')||chr(9)||nvl('是否通过GMP认证(1-是，0-否)','')||chr(9)||nvl('GMP-GSP认证(1-是，0-否)','')||chr(9)||nvl('GMP-GSP证书号','')||chr(9)||nvl('营业执照是否期限管理(1-是，0-否)','')||chr(9)||nvl('营业执照注册号','')||chr(9)||nvl('营业执照生效日期','')||chr(9)||nvl('营业执照到期日期','')||chr(9)||nvl('营业执照预警天数','')||chr(9)||nvl('经营许可证是否期限管理(1-是，0-否)','')||chr(9)||nvl('生产-经营许可证号','')||chr(9)||nvl('经营许可证生效日期','')||chr(9)||nvl('经营许可证到期日期','')||chr(9)||nvl('经营许可证预警天数','')||chr(9)||nvl('法人委托书是否期限管理(1-是，0-否)','')||chr(9)||nvl('法人委托书生效日期','')||chr(9)||nvl('法人委托书到期日期','')||chr(9)||nvl('法人委托书预警天数','')||chr(9)||nvl('供应商自定义项1','')||chr(9)||nvl('供应商自定义项2','')||chr(9)||nvl('供应商自定义项3','')||chr(9)||nvl('供应商自定义项4','')||chr(9)||nvl('供应商自定义项5','')||chr(9)||nvl('供应商自定义项6','')||chr(9)||nvl('供应商自定义项7','')||chr(9)||nvl('供应商自定义项8','')||chr(9)||nvl('供应商自定义项9','')||chr(9)||nvl('供应商自定义项10','')||chr(9)||nvl('供应商自定义11','')||chr(9)||nvl('供应商自定义项12','')||chr(9)||nvl('供应商自定义项13','')||chr(9)||nvl('供应商自定义项14','')||chr(9)||nvl('供应商自定义项15','')||chr(9)||nvl('供应商自定义项16','')||chr(9)||nvl('分管部门编码','')||chr(9)||nvl('专管业务员编码','')||chr(9)||nvl('电话','')||chr(9)||nvl('传真','')||chr(9)||nvl('qq','')||chr(9)||nvl('手机号','')||chr(9)||nvl('邮编','')||chr(9)||nvl('联系人','')||chr(9)||nvl('地址','')||chr(9)||nvl('邮箱','')||chr(9)||nvl('结算方式','')||chr(9)||nvl('到货地址','')||chr(9)||nvl('发运方式编码','')||chr(9)||nvl('到货仓库编码','')||chr(9)||nvl('应付余额','')||chr(9)||nvl('扣率','')||chr(9)||nvl('信用等级','')||chr(9)||nvl('信用额度','')||chr(9)||nvl('信用期限','')||chr(9)||nvl('付款条件编码','')||chr(9)||nvl('ABC等级','')||chr(9)||nvl('单价是否含税(1-是，0-否)','')||chr(9)||nvl('最后交易日期','')||chr(9)||nvl('最后交易金额','')||chr(9)||nvl('最后付款日期','')||chr(9)||nvl('最后付款金额','')||chr(9)||nvl('账期管理(1-是，0-否)','')||chr(9)||nvl('采购委外收付款协议','')||chr(9)||nvl('合同默认收付款协议','')||chr(9)||nvl('其他应付单收付款协议','')||chr(9)||nvl('进口收付款协议','')||chr(9)||nvl('发展日期','')||chr(9)||nvl('停用日期','')||chr(9)||nvl('使用频度','')||chr(9)||nvl('对应条形码编码','')||chr(9)||nvl('所属银行','')||chr(9)||nvl('默认委外仓','')||chr(9)||nvl('备注','')||chr(9)||nvl('建档人','')||chr(9)||nvl('建档日期','')||chr(9)||nvl('变更日期','')||chr(9)||nvl('国家','')||chr(9)||nvl('英文名称','')||chr(9)||nvl('英文地址1','')||chr(9)||nvl('英文地址2','')||chr(9)||nvl('英文地址3','')||chr(9)||nvl('英文地址4','')||chr(9)||nvl('起运港','')||chr(9)||nvl('主要承运商','')||chr(9)||nvl('佣金比率','')||chr(9)||nvl('国内分支机构(0-没有，1-有)','')||chr(9)||nvl('分支机构地址','')||chr(9)||nvl('分支机构电话','')||chr(9)||nvl('分支机构联系人','')||chr(9)||nvl('录入日期','')||chr(9)||nvl('录入员','') from dual                      
                      select '部门编码','部门名称','成立日期','英文名称','部门类型','分管领导','部门属性','负责人编码','批准文号','批准单位','电话','地址','传真','邮政编码','电子邮件','信用额度','信用等级','信用天数','备注','是否启用UTU','适用零售','录入日期','录入员' from dual;
                      
                      select nvl(BP_VENDER_CODE,'')||chr(9)||nvl(BP_SHORT_NAME,'')||chr(9)||nvl(MNEMONICS,'')||chr(9)||nvl(BP_TYPE_CODE,'')||chr(9)||nvl(CURRENCY,'')||chr(9)||nvl(BP_FULL_NAME,'')||chr(9)||nvl(HEAD_OFFICE_CODE,'')||chr(9)||nvl(ADDRESS_CODE,'')||chr(9)||nvl(INDUSTRY_CODE,'')||chr(9)||nvl(CUS_CODE,'')||chr(9)||nvl(to_char(EMPLOYEE_NUM),'')||chr(9)||nvl(to_char(PURCHASE_FLAG),'')||chr(9)||nvl(to_char(OUTSOURCING_FLAG),'')||chr(9)||nvl(to_char(SERVER_FLAG),'')||chr(9)||nvl(to_char(ABROAD_FLAG),'')||chr(9)||nvl(TAXPAYER_CODE,'')||chr(9)||nvl(to_char(REGISTERED_CAPITAL),'')||chr(9)||nvl(CORPORATION,'')||chr(9)||nvl(BANK_OF_DEPOSIT,'')||chr(9)||nvl(BANK_NUM,'')||chr(9)||nvl(to_char(TAX_RATES),'')||chr(9)||nvl(to_char(GMP_FLAG),'')||chr(9)||nvl(ENTERPRISES_TYPE,'')||chr(9)||nvl(to_char(GMP_GSP_FLAG),'')||chr(9)||nvl(GMP_GSP_NUM,'')||chr(9)||nvl(to_char(TERM_BUSINESS),'')||chr(9)||nvl(BUSINESS_LICENSE_NUM,'')||chr(9)||nvl(to_char(BUSINESS_LICENSE_DATE_FROM,'yyyymmdd'),'')||chr(9)||nvl(to_char(BUSINESS_LICENSE_DATE_TO,'yyyymmdd'),'')||chr(9)||nvl(to_char(EARLY_WARNING_DAY),'')||chr(9)||nvl(to_char(CERTIFICATE),'')||chr(9)||nvl(CERTIFICATE_CODE,'')||chr(9)||nvl(to_char(CERTIFICATE_DATE_FROM,'yyyymmdd'),'')||chr(9)||nvl(to_char(CERTIFICATE_DATE_TO,'yyyymmdd'),'')||chr(9)||nvl(to_char(CERTIFICATE_WARNING_DAY),'')||chr(9)||nvl(to_char(ATTORNEY),'')||chr(9)||nvl(to_char(ATTORNEY_DATE_FROM,'yyyymmdd'),'')||chr(9)||nvl(to_char(ATTORNEY_DATE_TO,'yyyymmdd'),'')||chr(9)||nvl(to_char(ATTORNEY_WARNING_DAY),'')||chr(9)||nvl(REF_01,'')||chr(9)||nvl(REF_02,'')||chr(9)||nvl(REF_03,'')||chr(9)||nvl(REF_04,'')||chr(9)||nvl(REF_05,'')||chr(9)||nvl(REF_06,'')||chr(9)||nvl(REF_07,'')||chr(9)||nvl(REF_08,'')||chr(9)||nvl(REF_09,'')||chr(9)||nvl(REF_10,'')||chr(9)||nvl(REF_11,'')||chr(9)||nvl(REF_12,'')||chr(9)||nvl(REF_13,'')||chr(9)||nvl(REF_14,'')||chr(9)||nvl(REF_15,'')||chr(9)||nvl(REF_16,'')||chr(9)||nvl(BRANCH_UNIT_CODE,'')||chr(9)||nvl(EMPLOYEE_CODE,'')||chr(9)||nvl(PHONE,'')||chr(9)||nvl(FAX,'')||chr(9)||nvl(QQ_NUM,'')||chr(9)||nvl(MOBILE_PHONE,'')||chr(9)||nvl(ZIP_CODE,'')||chr(9)||nvl(CONTACT_PERSON,'')||chr(9)||nvl(ADDRESS,'')||chr(9)||nvl(EMAIL,'')||chr(9)||nvl(BALANCE_TYPE,'')||chr(9)||nvl(ARRIVED_ADDRESS,'')||chr(9)||nvl(FORWARDING_TYPE_CODE,'')||chr(9)||nvl(WAREHOUSE_CODE,'')||chr(9)||nvl(to_char(PAY_BALANCE),'')||chr(9)||nvl(to_char(FEE),'')||chr(9)||nvl(CREDIT_LEVEL,'')||chr(9)||nvl(to_char(CREDIT_LIMIT),'')||chr(9)||nvl(to_char(CREDIT_TERM),'')||chr(9)||nvl(TERM_PAY_CODE,'')||chr(9)||nvl(ABC_LEVEL,'')||chr(9)||nvl(to_char(TAX_INCLUSIVE_PRICE),'')||chr(9)||nvl(to_char(LAST_TRANSACTION_DATE,'yyyymmdd'),'')||chr(9)||nvl(to_char(LAST_TRANSACTION_AMOUNT),'')||chr(9)||nvl(to_char(LAST_PAYMENT_DATE,'yyyymmdd'),'')||chr(9)||nvl(to_char(LAST_PAYMENT_AMOUNT),'')||chr(9)||nvl(to_char(ACCOUNT_PERIOD),'')||chr(9)||nvl(PROCUREMENT_OUTSOURCING,'')||chr(9)||nvl(CONTRACT_DEFAULT,'')||chr(9)||nvl(OTHER_PAY,'')||chr(9)||nvl(IMPORT,'')||chr(9)||nvl(to_char(DEVELOP_DATE_FROM,'yyyymmdd'),'')||chr(9)||nvl(to_char(TIME_OUT_DATE,'yyyymmdd'),'')||chr(9)||nvl(to_char(USE_FREQUENTNES),'')||chr(9)||nvl(BAR_CODE,'')||chr(9)||nvl(BELONG_BANK,'')||chr(9)||nvl(DEFAULT_OUTSOURCE_WAREHOUSE,'')||chr(9)||nvl(NOTE,'')||chr(9)||nvl(CREATED_ARCHIVE_PERSON,'')||chr(9)||nvl(to_char(CREATED_ARCHIVE_DATE,'yyyymmdd'),'')||chr(9)||nvl(to_char(CHANGE_DATE,'yyyymmdd'),'')||chr(9)||nvl(COUNTRY_CODE,'')||chr(9)||nvl(ENGLISH_NAME,'')||chr(9)||nvl(ENGLISH_ADD1,'')||chr(9)||nvl(ENGLISH_ADD2,'')||chr(9)||nvl(ENGLISH_ADD3,'')||chr(9)||nvl(ENGLISH_ADD4,'')||chr(9)||nvl(FOB,'')||chr(9)||nvl(MAIN_CARRIER,'')||chr(9)||nvl(to_char(COMMISSION_RATE),'')||chr(9)||nvl(to_char(PREMIUM_RATE),'')||chr(9)||nvl(to_char(DOMESTIC_BRANCH_OFFICES),'')||chr(9)||nvl(BRANCH_OFFICE_ADDR,'')||chr(9)||nvl(BRANCH_OFFICE_PHONE,'')||chr(9)||nvl(BRANCH_OFFICE_CONTACT,'')||chr(9)||nvl(to_char(INPUT_DATE,'yyyymmdd'),'')||chr(9)||nvl(INPUT_NAME,'') from hls_vender_interface t where t.record_id =825
                      
                      select t.COLUMN_NAME,c.comments from user_tab_columns t,user_col_comments c where t.Table_Name='HLS_VENDER_INTERFACE' and t.TABLE_NAME = c.table_name and  t.COLUMN_NAME = c.column_name and c.comments is not null and t.COLUMN_NAME not in ('BP_ID','EXPORT_FLAG','SENDFILENAME','SAPSENDFLAG') order by column_id;
 
                      select * from all_tab_columns where Table_Name='HLS_VENDER_INTERFACE';
                      
                      
                      SELECT t.batch_number
                        FROM hls_vender_interface t
                       WHERE nvl(t.sapsendflag,'N') = 'N'
                         AND t.batch_number = '2016-03-09 09:26:16'
                      --AND t.bukrs = c_company.comp
                       GROUP BY t.batch_number
 
                      select * from dba_tab_columns where Table_Name='HLS_VENDER_INTERFACE';
                      
                      --查询记录描述值

                      select t.* from user_col_comments t where t.table_name = 'HLS_VENDER_INTERFACE' and t.comments is not null;
                      
                      con_visit_report_pkg.hds_report_submit_approve
                      
                      select * from con_visit_report_hds;
                      
                      select * from ast_collection_record;
                      
                      select * from AST_COLLECTION_RECORD_LV t where t.bp_id_tenant=78 ;
                      
                      
                       select cc.contract_id as value_code ,cc.contract_number as value_name,cc.contract_name from con_contract cc where cc.bp_id_tenant = 78
 and cc.data_class = 'NORMAL'
                      select * from con_contract cc
                      
                      select * from zj_wfl_workflow_instance i where i.instance_id = 299;
                      select * from zj_wfl_workflow w where w.workflow_id = 1066;
                      select * from zj_wfl_workflow_node n where n.node_id = 2187
                      
                              
                      select nvl(UNIT_CODE,'')||chr(9)||nvl(UNIT_NAME,'')||chr(9)||nvl(to_char(SET_UP_DATE,'yyyymmdd'),'')||chr(9)||nvl(ENGLISH_NAME,'')||chr(9)||nvl(UNIT_TYPE,'')||chr(9)||nvl(BRANCH_LEADER,'')||chr(9)||nvl(UNIT_PROPERTY,'')||chr(9)||nvl(RESPONSIBILITY_CODE,'')||chr(9)||nvl(APPROVE_CODE,'')||chr(9)||nvl(APPROVE_UNIT,'')||chr(9)||nvl(PHONE,'')||chr(9)||nvl(ADDRESS,'')||chr(9)||nvl(FAX,'')||chr(9)||nvl(ZIP_CODE,'')||chr(9)||nvl(EMAIL,'')||chr(9)||nvl(to_char(LINE_OF_CREDIT),'')||chr(9)||nvl(LEVEL_OF_CREDIT,'')||chr(9)||nvl(to_char(DAY_OF_CREDIT),'')||chr(9)||nvl(REMARK,'')||chr(9)||nvl(to_char(START_UP_UTU),'')||chr(9)||nvl(to_char(FOR_RETAIL),'')||chr(9)||nvl(to_char(INPUT_DATE,'yyyymmdd'),'')||chr(9)||nvl(INPUT_NAME,'')||chr(9)||nvl(EXPORT_FLAG,'') from hls_org_unit_interface t where t.record_id =366
                      
                      
                      select hcl_journal_sap_pkg.C2B('tttttt') from dual;
                      
                      
                      HLS_WS_REQUEST_PKG.nc_journal_import
                      select to_char(sysdate,'yyyymmddhhmiss')  from dual;
                      
                      hcl_journal_sap_pkg;
                      
                      --day 2016-03-10  用友xml接口
                      --部门
                      create table hls_xml_unit_interface(
                             record_id number,
                             unit_id   number,
                             code      nvarchar2(12),
                             endflag   varchar2(1),
                             name      nvarchar2(255),
                             rank      integer,
                             manager   nvarchar2(20),
                             prop      nvarchar2(10),
                             phone     nvarchar2(100),
                             address   nvarchar2(255),
                             remark    nvarchar2(20),
                             creditline float,
                             creditgrade                        nvarchar2(20),
                             creditdate                         int,
                             ddepbegindate                      date,
                             ddependdate                        date,
                             vauthorizedoc                      nvarchar2(50),
                             vauthorizeunit                     nvarchar2(100),
                             cdepfax                            nvarchar2(20),
                             cdeppostcode                       nvarchar2(6),
                             cdepemail                          nvarchar2(100),
                             cdeptype                           nvarchar2(20),
                             created_by                         number,
                             creation_date                      date,
                             last_updated_by                    number,
                             last_update_date                   date     
                      )
                      create sequence  hls_xml_unit_interface_s INCREMENT   BY   1
                      --供应商
                      create table hls_xml_vender_interface(
                             record_id                          number,
                             
                      )
                      create sequence  hls_xml_vender_interface_s INCREMENT   BY   1
                      CREATE TABLE HLS_XML_VENDER_INTERFACE 
                      (     record_id NUMBER NOT NULL ENABLE, 
                            bp_id NUMBER, 
                            code NVARCHAR2(20), 
                            name NVARCHAR2(98), 
                            abbrname NVARCHAR2(60), 
                            sort_code NVARCHAR2(12), 
                            domain_code NVARCHAR2(12), 
                            industry NVARCHAR2(50), 
                            address NVARCHAR2(255), 
                            postcode NVARCHAR2(6), 
                            tax_reg_code NVARCHAR2(50), 
                            bank_open NVARCHAR2(100), 
                            bank_acc_number NVARCHAR2(50), 
                            seed_date DATE, 
                            legal_man NVARCHAR2(100), 
                            phone NVARCHAR2(100), 
                            fax NVARCHAR2(100), 
                            email NVARCHAR2(100), 
                            contact nvarchar2(50), 
                            bp nvarchar2(50), 
                            mobile nvarchar2(20), 
                            spec_operator nvarchar2(20), 
                            discount_rate FLOAT, 
                            credit_rank nvarchar2(6), 
                            credit_amount FLOAT, 
                            credit_deadline NUMBER, 
                            pay_condition nvarchar2(20), 
                            receive_site nvarchar2(255), 
                            receive_mode nvarchar2(10), 
                            head_corp_code nvarchar2(20), 
                            rec_warehouse nvarchar2(10), 
                            super_dept nvarchar2(12), 
                            ap_rest float, 
                            last_tr_date DATE, 
                            last_tr_money NUMBER, 
                            last_pay_date DATE, 
                            last_pay_amount NUMBER, 
                            end_date DATE, 
                            tr_frequency NUMBER, 
                            tax_in_price_flag VARCHAR2(1), 
                            CreatePerson nvarchar2(20), 
                            ModifyPerson nvarchar2(20), 
                            ModifyDate DATE, 
                            auth_class NUMBER, 
                            barcode nvarchar2(30), 
                            self_define1 nvarchar2(20), 
                            self_define2 nvarchar2(20), 
                            self_define3 nvarchar2(20), 
                            self_define4 nvarchar2(60),
                            self_define5 nvarchar2(60),
                            self_define6 nvarchar2(60),
                            self_define7 nvarchar2(120),
                            self_define8 nvarchar2(120),
                            self_define9 nvarchar2(120),
                            self_define10 nvarchar2(120),
                            self_define11 int,
                            self_define12 int,
                            self_define13 float,
                            self_define14 float,
                            self_define15 date,
                            self_define16 date,
                            RegistFund float, 
                            EmployeeNum int, 
                            GradeABC number, 
                            Memo nvarchar2(240), 
                            LicenceSDate date,
                            LicenceEDate date,
                            LicenceADays int,
                            BusinessSDate date,
                            BusinessEDate date,
                            BusinessADays int,
                            ProxySDate date,
                            ProxyEDate date,
                            ProxyADays int,
                            bvencargo varchar2(1),
                            bproxyforeign varchar2(1),
                            bvenservice   varchar2(1),
                            cVenTradeCCode nvarchar2(12),
                            cvenbankcode   nvarchar2(5),
                            cRelCustomer   nvarchar2(20),
                            cvenexch_name   nvarchar2(50),
                            ivengsptype     number,
                            ivengspauth     number,
                            cvengspauthno   nvarchar2(40),
                            cvenbusinessno  nvarchar2(20),
                            cvenlicenceno   nvarchar2(20),
                            bvenoverseas number,
                            bvenaccperiodmng  number,
                            cvenpuomprotocol nvarchar2(20),
                            cvenotherprotocol nvarchar2(20),
                            cvencountrycode nvarchar2(10),
                            cvenenname      nvarchar2(100),
                            cvenenaddr1     nvarchar2(60),
                            cvenenaddr2     nvarchar2(60),
                            cvenenaddr3     nvarchar2(60),
                            cvenenaddr4     nvarchar2(60),
                            cvenportcode    nvarchar2(10),
                            cvenprimaryven  nvarchar2(20),
                            fvencommisionrate float,
                            fveninsuerate     float,
                            bvenhomebranch number,
                            cvenbranchaddr nvarchar2(200),
                            cvenbranchphone nvarchar2(100),
                            cvenbranchperson nvarchar2(50),
                            CREATED_BY NUMBER, 
                            CREATION_DATE DATE, 
                            LAST_UPDATED_BY NUMBER, 
                            LAST_UPDATE_DATE DATE)
                         
                      --客户
                      create table hls_xml_cus_interface(
                             record_id NUMBER NOT NULL ENABLE,
                             bp_id     number,
                             code                                               nvarchar2(20),
                             name    	                                          nvarchar2(98),
                             abbrname                                           nvarchar2(60),		
                             sort_code                                          nvarchar2(12),
                             domain_code                                        nvarchar2(12),
                             industry                                           nvarchar2(50),
                             address                                            nvarchar2(255),
                             postcode                                           nvarchar2(6),
                             tax_reg_code                                       nvarchar2(50),
                             bank_open                                                    nvarchar2(100),
                             bank_acc_number                                               nvarchar2(50),
                             seed_date                                                   date,
                             legal_man                                                         nvarchar2(100),
                             email                                                               nvarchar2(100),
                             contact                                                                nvarchar2(50),
                             phone                                                                nvarchar2(100),
                             fax                                                                   nvarchar2(100),
                             bp                                                                    nvarchar2(20),
                             mobile                                                               nvarchar2(20),
                             spec_operator                                                nvarchar2(20),
                             discount_rate                                                           float,
                             credit_rank                                                          nvarchar2(6),
                             credit_amount                                                         float,
                             credit_deadline                                                        int,
                             pay_condition                                                     nvarchar2(20),
                             devliver_site                                                       nvarchar2(255),
                             deliver_mode                                                     nvarchar2(10),
                             head_corp_code                                                  nvarchar2(20),
                             deli_warehouse                                                   nvarchar2(10),
                             super_dept                                                         nvarchar2(12),
                             ar_rest                                                             float,
                             last_tr_date                                                      date,
                             last_tr_amount                                                      float,
                             last_rec_date                                                      date,
                             last_rec_amount                                                     float,
                             end_date                                                                date,
                             tr_frequency                                                          int,
                             self_define1                                                       nvarchar2(20),
                             self_define2                                                       nvarchar2(20),
                             self_define3                                                       nvarchar2(20),
                             pricegrade                                                              smallint,
                             CreatePerson                                                             nvarchar2(20),
                             ModifyPerson                                                              nvarchar2(20),
                             ModifyDate                                                              date,
                             auth_class                                                           int,
                             self_define4                                                       nvarchar2(60),
                             self_define5                                                      nvarchar2(60),
                             self_define6                                                  nvarchar2(60),
                             self_define7                                                   nvarchar2(120),
                             self_define8                                                 nvarchar2(120),
                             self_define9                                                 nvarchar2(120),
                             self_define10                                             nvarchar2(120),
                             self_define11                                        int,
                             self_define12                                           int,
                             self_define13                                                float,
                             self_define14                                                float,
                             self_define15                                               date,
                             self_define16                                                  date,
                             InvoiceCompany                                                    nvarchar2(60),
                             Credit                                                      number,
                             CreditDate                                               number,
                             LicenceSDate                                                  date,
                             LicenceEDate                                                  date,
                             LicenceADays                                                    int,
                             BusinessSDate                                            date,
                             BusinessEDate                                            date,
                             BusinessADays                                            int,
                             ProxySDate                                                    date,
                             ProxyEDate                                                   date,
                             ProxyADays                                                   int,
                             Memo                                                                     nvarchar2(240),
                             bLimitSale                                                     number,
                             cCusCountryCode                                                     nvarchar2(10),
                             cCusEnName                                                          nvarchar2(100),
                             cCusEnAddr1                                                      nvarchar2(60),
                             cCusEnAddr2                                                        nvarchar2(60),
                             cCusEnAddr3                                                      nvarchar2(60),
                             cCusEnAddr4                                                         nvarchar2(60),
                             cCusPortCode                                                        nvarchar2(10),
                             cPrimaryVen                                                       nvarchar2(20),
                             fCommisionRate                                                     float,
                             fInsueRate                                                     float,
                             bHomeBranch                                             number,
                             cBranchAddr                                                     nvarchar2(255),
                             cBranchPhone                                                    nvarchar2(100),
                             cBranchPerson                                                   nvarchar2(50),
                             cCusTradeCCode                                                     nvarchar2(12),
                             CustomerKCode                                                     nvarchar2(4),
                             bCusState                                                            number,
                             ccusbankcode                                                      nvarchar2(50),
                             cRelVendor                                                       nvarchar2(20),
                             ccusexch_name                                         nvarchar2(50),

                             bshop                                                         number,
/*枚举值：0 非零售     1门店    2赊销客户 
“门店”选项，名称改为“零售”，类型修改为枚举值，可以选“非零售”、“门店”、“赊销客户”，默认非零售		*/

bcusdomestic                                                             number,
bcusoverseas                                                           number,
ccuscreditcompany                                                     nvarchar2(20),
ccussaprotocol                                           nvarchar2(20),
ccusexprotocol                                            nvarchar2(20),
ccusotherprotocol                                      nvarchar2(20),
fcusdiscountrate                                                float,
	
cCusMnemCode		     		nvarchar2(98),	

fAdvancePaymentRatio	      	float,
/*控制要求：0-100	 手工录入，可以修改；用于销售订单，录入客户时，带入当前最新的定金比例。
*/
bServiceAttribute             number,
/*控制要求：0,1	售后服务中只可以参照出服务属性的客户记录。手工输入，默认为空，与客户档案项目无互斥关系。
*/
bOnGPinStore 		     number,
/*控制要求：0,1	默认为0。*/

/*cusinvoicecorp 	      开票单位
子节点：
1.ccuscode 用户编码（必输项）
2.cinvoicecompany 开票单位编码（必输项）
3.bdefault 是否默认（必输项）*/

bRequestSign  number,
/*值：1需要签回，0不需要，默认值为0*/
CREATED_BY NUMBER, 
                            CREATION_DATE DATE, 
                            LAST_UPDATED_BY NUMBER, 
                            LAST_UPDATE_DATE DATE
                      )


                      --人员
                      create table hls_xml_emp_interface(
                      record_id NUMBER NOT NULL ENABLE,
                      employee_id     number,
                      
                      code                                                         nvarchar2(20),		
                      name                                                    nvarchar2(40),		
                      cPsn_NameEN                                                  nvarchar2(50),
                      JobNumber                                                    nvarchar2(50),		
                      cpsnproperty                                               nvarchar2(20),
                      rsex                                                           nvarchar2(30),
                      rEmployState                                            nvarchar2(30),
                      rpersontype                                                   nvarchar2(30),
                      EmploymentForm                                                 nvarchar2(40),
                      cdutyclass                                                      nvarchar2(2),
                      cJobCode                                                      nvarchar2(20),
                      cJobGradeCode                                                   nvarchar2(30),
                      cJobRankCode                                                    nvarchar2(30),  
                      bpsnperson                                                   number,
                      cdept_num                                                    nvarchar2(30),
                      cpsnbankcode                                                       nvarchar2(5),
                      cpsnaccount                                                     nvarchar2(50),
                      dbirthdate                                                       date,
                      vidno                                                        nvarchar2(18),
                      cpsnmobilephone                                                    nvarchar2(100),
                      cpsnfphone                                                  nvarchar2(100),
                      cpsnophone                                                  nvarchar2(100),
                      cpsninphone                                               nvarchar2(100),
                      cpsnemail                                                     nvarchar2(100),
                      cpsnfaddr                                                     nvarchar2(255),
                      cpsnpostcode                                                  nvarchar2(6),
                      cpsnpostaddr                                                  nvarchar2(255),
                      cpsnqqcode                                                       nvarchar2(20),
                      cpsnurl                                                nvarchar2(50),
                      cpsnoseat                                               nvarchar2(20),
                      
                      
                      
                      
                      CREATED_BY NUMBER, 
                      CREATION_DATE DATE, 
                      LAST_UPDATED_BY NUMBER, 
                      LAST_UPDATE_DATE DATE
                      
                      )
                      
                      
                      -- 项目接口 头
                      create table hls_xml_prj_interface(
                             record_id NUMBER NOT NULL ENABLE,
                             project_id     number,
                             citem_class    nvarchar2(20),
                             citem_name     nvarchar2(50),
                             citem_text     nvarchar2(120),
                             crule          nvarchar2(20),
                             CREATED_BY NUMBER, 
                             CREATION_DATE DATE, 
                             LAST_UPDATED_BY NUMBER, 
                             LAST_UPDATE_DATE DATE
                      )
                      -- 行  1
                      create table hls_xml_prj_filed_interface(
                             record_id number NOT NULL ENABLE,
                             project_id       number,
                             citem_sqr        number,
                             cfield_name      nvarchar2(20),
                             ctext            nvarchar2(40),
                             imode            number,
                             itype            number,
                             ilength          number,
                             iscale           number,
                             blist            varchar2(10),
                             bsum             varchar2(10),
                             bref             varchar2(10),
                             isubitem         number,
                             idefine          varchar2(20),
                             bprimarykey      varchar2(10),
                             isource          number,
                             ctablename       varchar2(40),
                             cfieldname       varchar2(20),
                             CREATED_BY NUMBER, 
                             CREATION_DATE DATE, 
                             LAST_UPDATED_BY NUMBER, 
                             LAST_UPDATE_DATE DATE
                      )
                      --行  2
                      drop table hls_xml_prj_itemc_interface
                      create table hls_xml_prj_itemc_interface_h(
                             record_id number NOT NULL ENABLE,
                             project_id       number,
                             citemccode       varchar2(20),
                             citemcname       varchar2(40),
                             iitemcgrade      number,
                             bitemcend        varchar(10),
                             CREATED_BY NUMBER, 
                             CREATION_DATE DATE, 
                             LAST_UPDATED_BY NUMBER, 
                             LAST_UPDATE_DATE DATE
                      )
                      --行2的子行
                      create table hls_xml_prj_itemc_interface_l(
                             record_id number NOT NULL ENABLE,
                             project_id       number,
                             citemccode       varchar2(20),
                             citemcname       varchar2(40),
                             iitemcgrade      number,
                             bitemcend        varchar(10),
                             CREATED_BY NUMBER, 
                             CREATION_DATE DATE, 
                             LAST_UPDATED_BY NUMBER, 
                             LAST_UPDATE_DATE DATE
                      )

                      

                      select * from hls_journal_sap_intf_log t order by t.creation_date desc;                    
                                                
                                                hls_dayend_pkg.dayend
                                                
                                                select * from con_contract c where c.contract_number = 'CON201603002';   --331
                                                
                                                
                                                
                      select lower(t.COLUMN_NAME) COLUMN_NAME, t.DATA_TYPE
                        from user_tab_columns t
                       where t.TABLE_NAME =
                             upper('hls_xml_prj_filed_interface')
                         and t.COLUMN_NAME not in
                             ('RECORD_ID',
                              'PROJECT_ID',
                              'CREATED_BY',
                              'CREATION_DATE',
                              'LAST_UPDATED_BY',
                              'LAST_UPDATE_DATE')
                       order by t.COLUMN_ID;
                      
                      select * from HLS_XML_UNIT_INTERFACE;
                      
                      
                      select lower(t.COLUMN_NAME) COLUMN_NAME, t.DATA_TYPE
                       from user_tab_columns t
                      where t.TABLE_NAME =
                            upper('hls_xml_prj_filed_interface')
                        and t.COLUMN_NAME not in
                            ('RECORD_ID',
                             'PROJECT_ID',
                             'CREATED_BY',
                             'CREATION_DATE',
                             'LAST_UPDATED_BY',
                             'LAST_UPDATE_DATE')
                      order by t.COLUMN_ID
                      
                      select * from hls_xml_prj_filed_interface;
                      
                      select t.record_id, t.project_id,t.citem_class,t.citem_name,t.citem_text,t.crule
                     from hls_xml_prj_interface t
                     
                     
                     select * from hls_xml_prj_filed_interface;
                     
                     select * from hls_journal_sap_intf_log t order by t.creation_date desc;  
                     select * from hls_journal_sap_log;       
                     
                     hls_yonyou_interface
                     
                     select * from hls_bp_master_v;
                     
                    select * from  hls_xml_cus_interface
                                                
                     select * from HLS_XML_UNIT_INTERFACE;
                     delete from HLS_XML_UNIT_INTERFACE;
                     
                     select * from Hls_Xml_Unit_Interface_History;
                     delete from Hls_Xml_Unit_Interface_History;
                     
                     select t.bp_id,t.bp_code,t.bp_name from hls_bp_master_v t where t.bp_category='VENDER';
                     
                     hls_xml_vender_interface;
                     
                     create table hls_xml_vend_interface_history as select * from hls_xml_vender_interface where 1=0;
                     
                     
                     create sequence  hls_xml_cus_interface_s INCREMENT   BY   1
                     
                     hls_xml_emp_interface_s
                     
                     create sequence  hls_xml_emp_interface_s INCREMENT   BY   1
                     
                     create table hls_xml_cus_interface_history as select * from hls_xml_cus_interface where 1=0;
                     
                     select * from hls_xml_cus_interface;
                     delete from hls_xml_cus_interface;
                     
                     select e.employee_id,e.employee_code,e.name from exp_employees e;
                     create table hls_xml_emp_interface_history as select * from hls_xml_emp_interface where 1=0;
                     
                     select * from hls_xml_emp_interface;
                     select * from hls_xml_emp_interface_history;
                     
                     
                     select t.* from hls_bp_master_v t where t.bp_category='TENANT';
                     --日志
                     select * from zj_wfl_instance_log;
                     select * from hls_vender_interface;
                     select * from hcl_journal_sap_pkg;
                     
                     select * from HLS_ORG_UNIT_INTERFACE;
                     hls_org_unit_interface;
                     hls_org_unit_interface_history
                     HLS_ORG_UNIT_INTERFACE_HISTORY
                     select * from hls_customer_interface;
                     hls_customer_interface_history
                     select * from hls_vender_interface;
                     hls_vender_interface_history
                     select * from hls_employee_interface;
                     hls_employee_interface_history;
                     
                     
                     select * from prj_project;
                     select * from prj_chance;
                     
                     prj_chance_lv;
                     
                     SELECT BP_ID VALUE_CODE, BP_CODE, BP_NAME value_NAME,organization_code
  FROM HLS_BP_MASTER
 WHERE BP_ID IN (SELECT BP_ID
                   FROM HLS_BP_MASTER_ROLE
                  WHERE BP_TYPE IN ('BANK','NOT_BANK'));
                  
                  select * from HLS_BP_MASTER;
