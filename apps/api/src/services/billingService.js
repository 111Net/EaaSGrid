class BillingService {
  calculateUsage(kwh, rate) {
    return kwh * rate;
  }

  generateInvoice(data) {
    return {
      userId: data.userId,
      amount: this.calculateUsage(data.kwh, data.rate),
      timestamp: new Date()
    };
  }
}

module.exports = new BillingService();
