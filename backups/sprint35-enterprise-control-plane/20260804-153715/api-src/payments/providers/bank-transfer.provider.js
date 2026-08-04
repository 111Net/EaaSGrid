
class BankTransferProvider {


async initializePayment(data){

return {

provider:"bank-transfer",

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


module.exports=new BankTransferProvider();

