const request = require("supertest");
const app = require("../src/app");


describe("API Error Handling", () => {


  test("Unknown route returns 404", async () => {

    const response = await request(app)
      .get("/api/v1/not-existing-route");


    expect(response.statusCode)
      .toBe(404);


    expect(response.body.success)
      .toBe(false);


    expect(response.body.message)
      .toBe("Route not found");

  });


});
