
class PaystackProvider {


async initializePayment(data){

return {

provider:"paystack",

status:"PENDING",

message:
"Paystack integration ready"

};

}


async verifyPayment(reference){

return {

reference,

status:"PENDING"

};

}


}


module.exports=new PaystackProvider();

