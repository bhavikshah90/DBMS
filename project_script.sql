use finalproject;
SET SQL_SAFE_UPDATES = 0;
select * from products;
select * from factory;
select * from retailer;
select * from factorystockinventory;


select * from purchaseorder;
select * from purchaseorderandfactory;
select * from trader;
select * from salesorder;
select * from shipping_trader;
select * from factorystockinventory;
select * from stockinventory;

select * from purchaseorder;
select * from trader;
select * from salesorder;

######### purchase order insert also triggering insert to sales order########################
call sp_purchaseOrderInsert(3,3);

###############################################################################################
###############Sales order confirm function####################################################

select fn_salesOrderconfirm('y',3);
select * from trader;

###############################################################################################

################ Stock Inventory Check #######################

select p.ProductsName,s.Quantity, 
pu.QuantityRequired from products p, stockinventory s,purchaseorder pu where 
p.productsId = s.productsId
and pu.purchaseorderid =(select purchaseorderid from salesorder where salesorderid = 3)
and p.ProductsName in (select productsName from purchaseorderandfactory ps
where ps.purchaseorderid = 
(select purchaseorderid from trader where salesorderID = 3));

##################Retailer call######################################################
#(in salesorder int, in retailerid int, in retailersalesorder int)

call sp_retailerUpdateInventory(3,1,2);
select * from trader;

#############Shipping procedure if stock present in stockinventory ######

call sp_shipping(3,1);
select * from shipping_trader;

#########################################################################

#################### Factory update ####################################

call sp_factoryStockUpdate(3);
select * from factorystockinventory;

#########################################################################

select * from bill;
update bill set GeneratedDate = '2017-08-28' where billId = 3; 
select * from payment;
select * from factory_bill;

####################### Payment Confirmation ####################
update payment set paymentReceived = 'Y',ReceivedDate = curdate(),
PaymentMethod = 'Cheque Transaction'
where billid = 3;
select * from payment;

###################################################################

### Total sales

select sum(CostWithoutTax) from salesorder;

##############

select * from purchaseorder;

####number of products sold

SELECT PRODUCTSNAME, COUNT(PRODUCTSnAME) FROM purchaseorderandfactory GROUP BY PRODUCTSNAME;

####


###Draft dues

select p.billid from payment p,bill b where paymentReceived = 'N' 
and  datediff(curdate(),cast(b.GeneratedDate as char)) > 90;

##########################

## view for payment alert
SELECT `v_payment_alert`.`billid`
FROM `finalproject`.`v_payment_alert`;
select * from v_payment_alert;


## view for payment alert
CREATE 
    VIEW `finalproject`.`v_payment_alert` AS
    SELECT 
        `p`.`billId` AS `billid`
    FROM
        (`finalproject`.`payment` `p`
        JOIN `finalproject`.`bill` `b`)
    WHERE
        ((`p`.`paymentReceived` = 'N')
            AND ((TO_DAYS(CURDATE()) - TO_DAYS(CAST(`b`.`GeneratedDate` AS CHAR CHARSET UTF8))) > 75));
            
call sp_alert();
select * from alert;

### Procedure to create purchaseorder based on factory inventory #########
delimiter //
create procedure sp_purchaseOrderInsert( in quant int ,in fid int)
Begin

if exists(select fs.quantity from products, factorystockinventory fs,factory fi
where productsId = factoryProductId
and fs.factoryId = fi.factoryId
and fi.factoryId = fid and fs.quantity < 5)

then
set autocommit =0;
start transaction;
set @factoryid = fid;
set @quantity = quant;
insert into purchaseorder (QuantityRequired) 
values(quant);
insert into trader (purchaseorderid) values ((select purchaseOrderid from purchaseOrder 
order by purchaseorderid desc limit 1));
commit;
set autocommit = 1;
end if;
end; //

## Trigger to enter purcahse order into salesorder  table ################

delimiter $$
create trigger afterPOtoSO after
Insert on purchaseorder
for each row
begin
declare quant int;

insert into purchaseorderandfactory(purchaseorderid,factoryid,productsName)
(select (select purchaseorderid from purchaseorder order by 1 desc limit 1 ),
@factoryid,
products.Productsname 
from products, 
factorystockinventory fs,factory fi
where productsId = factoryProductId
and fs.factoryId = fi.factoryId
and fi.factoryId = @factoryid and fs.quantity < 5);

set quant = @quantity;
set @sumforsales = (select (sum((price*1.20)) * quant) from products where 
productsName in (select productsName from purchaseorderandfactory where 
purchaseorderid = (select purchaseorderid from purchaseorder order by 1 desc limit 1)));

insert into salesorder(purchaseOrderID,costwithoutTax) values(new.purchaseOrderID,(@sumforsales));
end $$

############################################################################

############################################################################
##Function to send sales order and waiting for approval which also  and
####calls procedure to insert updated sales order into trader table###

delimiter $$
create function fn_salesOrderconfirm(c char(1), i int)
returns char(1)
begin
declare s char(1);
if (c = 'y')
then
set s = 'Y';

update salesorder
set Approved = 'Y'
where salesorderid = i;
call sp_insertTotrader(i);
else
set s = 'N';

#return s;
end if;
return s;
end $$

####################################################################


### Procedure to update trader with confirmed sales order ######################################

delimiter $$
create procedure sp_insertTotrader(in i int)
begin
update Trader
set salesorderid = i where 
purchaseorderid = (select purchaseorderid from salesorder where salesorderid = i);
end $$

#################################################################################################


# Procedure to send shipping from stockinventory and updating inventory quantity and trader for Lorryreceipt

delimiter $$
create procedure sp_Shipping(in salesOrder int,in shippingid int)
begin
set autocommit = 0;
Start transaction;
select @d := QuantityRequired from purchaseorder where purchaseorderid = 
(select purchaseorderid from trader where salesorderID = salesorder); 
select @d;

update Stockinventory s
set s.quantity = quantity - @d
where s.productsid = (select p.productsid from products p, purchaseorder pu where 
p.productsId = s.productsid 
and pu.purchaseorderid =(select purchaseorderid from salesorder where salesorderid = salesorder)
and p.ProductsName in (select productsName from purchaseorderandfactory ps
where ps.purchaseorderid = 
(select purchaseorderid from trader where salesorderID = salesorder)));

insert into shipping_trader(shippingid,QuantityDespatched)values(shippingid,@d);

update trader set Lorryreceipt = (select Receipt from shipping_trader order by Receipt desc limit 1),
stockInventoryId = 'Y'
where salesorderid = salesorder;
commit;
set autocommit = 1;
end $$


##############procedure to update factory stock and shipping and trader ##############
delimiter $$

create procedure sp_factoryStockUpdate(in salesorder int) 
begin 
set autocommit = 0;
Start Transaction;

update factorystockinventory fs set fs.quantity = fs.quantity + 
(select quantityDespatched from shipping_TRADER where receipt = 
(select Lorryreceipt from trader where salesorderid = salesorder))
where factoryid = (select factoryid from purchaseorderandfactory
where purchaseOrderId = (select purchaseorderid from trader where salesorderid = salesorder)
group by factoryId)
and factoryProductId in (select productsid from products 
where productsName in (select productsName from purchaseorderandfactory
where purchaseorderid = (select purchaseorderid from trader where salesorderid = salesorder)));

update trader set despatched = 'Y' where salesorderid = salesorder;
update shipping_trader set orderDelivered = 'Y'
where Receipt = (select LorryReceipt from trader where salesorderid = salesorder); 

update salesorder
set IsServiced = 'Y' where salesorderid = salesorder;

commit;
set autocommit = 1;
end $$

######################################################################################

######################## Procedure for reatiler update ###############################
 
delimiter $$

create procedure sp_retailerUpdateInventory
(in salesorder int, in retailerid int, in retailersalesorder int)
begin
#update trader
update trader 
set retailerid = retailerid,retailerSalesOrder = retailerSalesOrder where salesorderid = salesorder;

#update stockinventory
update stockinventory set quantity = 
quantity + (select quantityrequired from purchaseorder where purchaseOrderId
= (select purchaseorderid from salesorder where salesorderid = salesorder))
where productsid in (select Productsid from products where ProductsName in 
(select Productsname from purchaseorderandfactory where purchaseorderid in
(select purchaseorderid from salesorder where salesorderid = salesorder)));
end $$

#######################################################################################

################### Trigger for bill update ###########################################

delimiter $$

create trigger billGeneration
after update on salesorder
for each row
begin
if New.isServiced = 'Y'
then
insert into bill(salesOrderid,pricewithTax,generatedDate)
values(new.salesorderid,
(select (CostWithoutTax*1.12) from salesorder 
where salesorderid = new.salesorderid),curdate());
end if;
end $$

#############################################################################################

################## insertion in payment table################################################

delimiter $$
create Trigger PaymentInsert
after insert on Bill
for each row
begin
insert into payment(billid) values(new.billid);
call sp_billinsertfactory(new.billid);
end $$

##############################################################################################

###### bill and factory insert in foriegn key #############################

delimiter $$

CREATE procedure sp_billinsertfactory(in bill int)
begin
insert into factory_bill values(
(select factoryid from purchaseorderandfactory where purchaseorderid = 
(select purchaseorderid from salesorder where salesorderid 
= (select salesorderid from bill b where b.billId = bill)) group by factoryid),
bill);
end $$

#############################################################################


################ Alert for sending email ####################################
delimiter $$
CREATE DEFINER=`bhavik`@`%` PROCEDURE `sp_alert`()
begin
declare done int default false;
declare count int ;

declare cur1 cursor for select p.billid from payment p,bill b where paymentReceived = 'N' 
and  datediff(curdate(),cast(b.GeneratedDate as char)) > 75;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
open cur1;
#select @count := count(*) from payment;
l1: loop
fetch cur1 into count;
if done then
select 'Email list aded to Alert list' as '';
leave l1;
else
insert into alert (billid,factoryName,email,body) values((count),
(select factoryName from factory where factoryid = 
(select factoryId from factory_bill where billid = count)),
(select emailid from factory where factoryid = 
(select factoryId from factory_bill where billid = count)),(
'Payment due by 15 days from now'));
end if;
end loop;
close cur1;
end $$
#####################################################################################



