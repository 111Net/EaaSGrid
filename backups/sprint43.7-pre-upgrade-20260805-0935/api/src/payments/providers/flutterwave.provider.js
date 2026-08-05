
class FlutterwaveProvider {


async initializePayment(data){

return {

provider:"flutterwave",

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


module.exports=new FlutterwaveProvider();

