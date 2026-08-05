
class PaymentService {


constructor(provider){

this.provider = provider;

}


initialize(data){

return this.provider.initializePayment(data);

}


verify(reference){

return this.provider.verifyPayment(reference);

}


}


module.exports = PaymentService;

