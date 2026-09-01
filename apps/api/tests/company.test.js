const request = require("supertest");
const app = require("../src/app");


describe("Company API", () => {

    test("GET /api/company returns company data", async () => {

        const response = await request(app)
            .get("/api/company");


        console.log("COMPANY RESPONSE:", response.body);


        expect(response.statusCode)
            .toBe(200);


        expect(response.body.success)
            .toBe(true);


        expect(Array.isArray(response.body.data))
            .toBe(true);

    }, 15000);

});
