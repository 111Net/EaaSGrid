
class MobileMoneyProvider {


async initializePayment(data){

return {

provider:"mobile-money",

status:"PENDING"

};

}


async verifyPayment(reference){

return {

reference,

status:"PENDING"

};

}


}


module.exports=new MobileMoneyProvider();

