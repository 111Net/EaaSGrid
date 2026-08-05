
class StripeProvider {


async initializePayment(data){

return {

provider:"stripe",

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


module.exports=new StripeProvider();

