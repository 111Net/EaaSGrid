const request = require("supertest");
const app = require("../src/app");


describe("Dashboard API", () => {

  test("GET /api/v1/dashboard returns dashboard data", async () => {

    const response = await request(app)
      .get("/api/v1/dashboard");


    console.log(
      "DASHBOARD RESPONSE:",
      response.body
    );


    expect(response.statusCode)
      .toBe(200);


    expect(response.body.platform.name)
      .toBe("EaaSGrid");


    expect(response.body.infrastructure.pilot_sites)
      .toBe(6);


    expect(response.body.infrastructure.planned_sites_per_year)
      .toBe(60);


    expect(response.body.investment.required_capital_ngn)
      .toBe(298000000);


  });

});
