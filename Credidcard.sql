/*Project title:Credit card loan eligibility*/
set serveroutput on;

--creating the credit card loan details
create table Credit_Card_Loan(phone number(20),
                              credit_card_number number(20),
                              loan_eligibility char(1),
                              loan_amount number(20));
                              
                              
--inserting data in the table

insert into Credit_Card_Loan values(9392327586,1234123412346666,'Y',100000);

insert into Credit_Card_Loan values(9392327586,1234123412347777,'N',100000);

insert into Credit_Card_Loan values(7981275926,1234123412345555,'Y',100000);

insert into Credit_Card_Loan values(7981275926,1234123412343333,'N',100000);

commit;

select * from Credit_Card_Loan;



--Loan eligibility check procedure

create or replace procedure loan_eligibility(p_phone number,
                                                  p_cc_last_4 number,
                                                  p_msg out varchar2)
as
l_loan_amt number;
l_count number;
l_loan_eligibility char(1);
no_record_exception exception;
begin
select count(*) into l_count from credit_card_loan 
where phone=p_phone
and substr(credit_card_number,-4)=p_cc_last_4;
if l_count=0 then
raise no_record_exception;
end if;
select loan_amount into l_loan_amt
from credit_card_loan
where phone=p_phone
and substr(credit_card_number,-4)=p_cc_last_4
and loan_eligibility='Y';
p_msg:='Approved Loan amount is:'||to_char(l_loan_amt,'9,99,999');
exception
when no_record_exception then
p_msg:='Entered details are incorrect.please check';
when no_data_found then
p_msg:='sorry,no offers available.please try after sometime';
end loan_eligibility;
/

--executing the procedure
--It shows the approved loan amount
declare
res varchar2(100);
begin
loan_eligibility(p_phone=>9392327587,
                 p_cc_last_4=>6666,
                 p_msg=>res);
dbms_output.put_line(res);
end;
/



--It shows the loan unavailable meassage
declare
res varchar2(100);
begin
loan_eligibility(p_phone=>9392327587,
                 p_cc_last_4=>7777,
                 p_msg=>res);
dbms_output.put_line(res);
end;
/


--It shows the entered details incorrect
declare
res varchar2(100);
begin
loan_eligibility(p_phone=>9392327587,
                 p_cc_last_4=>1111,
                 p_msg=>res);
dbms_output.put_line(res);
end;