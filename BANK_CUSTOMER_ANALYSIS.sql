use bankdb;

-- 1. total customers
select count(*) as total_customers
from customers;

-- 2. total accounts
select count(*) as total_accounts
from accounts;

-- 3. total customers by gender
select gender,count(*) as customer_count
from customers
group by gender;

-- 4. customers by segment
select customer_segment,count(*) as customer_count
from customers
group by customer_segment
order by customer_count desc;

-- 5. average credit score by segment
select customer_segment,avg(credit_score) as average_credit_score
from customers
group by customer_segment
order by average_credit_score desc;

-- 6. account count by account type
select account_type,count(*) as account_count
from accounts
group by account_type
order by account_count desc;

-- 7. average balance by account type
select account_type,avg(balance_usd) as average_balance
from accounts
group by account_type
order by average_balance desc;

-- 8. total balance by account type
select account_type,sum(balance_usd) as total_balance
from accounts
group by account_type
order by total_balance desc;

-- 9. account type having average balance above 5000
select account_type,avg(balance_usd) as average_balance
from accounts
group by account_type
having avg(balance_usd)>5000;

-- 10. customer and account details using join
select c.customer_id,c.first_name,c.last_name,a.account_id,a.account_type,a.balance_usd
from customers c
inner join accounts a on c.customer_id=a.customer_id;

-- 11. customer total balance
select c.customer_id,c.first_name,c.last_name,sum(a.balance_usd) as total_balance
from customers c
inner join accounts a on c.customer_id=a.customer_id
group by c.customer_id,c.first_name,c.last_name
order by total_balance desc;

-- 12. customers having more than one account
select customer_id,count(*) as account_count
from accounts
group by customer_id
having count(*)>1
order by account_count desc;

-- 13. customer product holding
select c.customer_id,c.first_name,c.last_name,count(a.account_id) as product_count
from customers c
inner join accounts a on c.customer_id=a.customer_id
group by c.customer_id,c.first_name,c.last_name
order by product_count desc;

-- 14. total transactions
select count(*) as total_transactions
from transactions;

-- 15. total transaction amount
select sum(amount_usd) as total_transaction_amount
from transactions;

-- 16. average transaction amount
select avg(amount_usd) as average_transaction_amount
from transactions;

-- 17. transaction count by merchant
select m.merchant_name,count(t.transaction_id) as transaction_count
from merchants m
inner join transactions t on m.merchant_id=t.merchant_id
group by m.merchant_name
order by transaction_count desc;

-- 18. transaction amount by merchant
select m.merchant_name,sum(t.amount_usd) as total_amount
from merchants m
inner join transactions t on m.merchant_id=t.merchant_id
group by m.merchant_name
order by total_amount desc;

-- 19. customer transaction analysis
select c.customer_id,c.first_name,c.last_name,sum(t.amount_usd) as total_spent
from customers c
inner join accounts a on c.customer_id=a.customer_id
inner join transactions t on a.account_id=t.account_id
group by c.customer_id,c.first_name,c.last_name
order by total_spent desc;

-- 20. customers spending more than 10000
select c.customer_id,c.first_name,c.last_name,sum(t.amount_usd) as total_spent
from customers c
inner join accounts a on c.customer_id=a.customer_id
inner join transactions t on a.account_id=t.account_id
group by c.customer_id,c.first_name,c.last_name
having sum(t.amount_usd)>10000
order by total_spent desc;

-- 21. loan count and total loan amount by customer
select c.customer_id,c.first_name,c.last_name,count(l.loan_id) as loan_count,sum(l.loan_amount) as total_loan
from customers c
inner join loans l on c.customer_id=l.customer_id
group by c.customer_id,c.first_name,c.last_name
order by total_loan desc;

-- 22. average loan amount by customer
select c.customer_id,c.first_name,c.last_name,avg(l.loan_amount) as average_loan
from customers c
inner join loans l on c.customer_id=l.customer_id
group by c.customer_id,c.first_name,c.last_name
having avg(l.loan_amount)>5000
order by average_loan desc;

-- 23. rank customers by total balance
select c.customer_id,c.first_name,c.last_name,sum(a.balance_usd) as total_balance,
rank() over(order by sum(a.balance_usd) desc) as balance_rank
from customers c
inner join accounts a on c.customer_id=a.customer_id
group by c.customer_id,c.first_name,c.last_name;

-- 24. running transaction total by date
select transaction_date,amount_usd,
sum(amount_usd) over(order by transaction_date) as running_total
from transactions
order by transaction_date;

-- 25. top 10 customers by transaction amount
select top 10 c.customer_id,c.first_name,c.last_name,sum(t.amount_usd) as total_spent
from customers c
inner join accounts a on c.customer_id=a.customer_id
inner join transactions t on a.account_id=t.account_id
group by c.customer_id,c.first_name,c.last_name
order by total_spent desc;

-- 26. customers with both account and loan
select distinct c.customer_id,c.first_name,c.last_name
from customers c
inner join accounts a on c.customer_id=a.customer_id
inner join loans l on c.customer_id=l.customer_id;

-- 27. card count by card type
select card_type,count(*) as card_count
from cards
group by card_type
order by card_count desc;