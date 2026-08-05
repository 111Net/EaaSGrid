const request = require("supertest");
const app = require("../src/app");


describe("Company API", () => {

    test("GET /api/v1/company returns company data", async () => {

        const response = await request(app)
            .get("/api/v1/company");


        console.log("COMPANY RESPONSE:", response.body);


        expect(response.statusCode)
            .toBe(200);


        expect(response.body.success)
            .toBe(true);


        expect(response.body.data.company_name)
            .toBeDefined();

    }, 15000);

});
