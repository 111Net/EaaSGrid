const request = require("supertest");
const app = require("../src/app");


describe("Database API", () => {


    test("GET /api/v1/database returns database records", async () => {


        const response = await request(app)
            .get("/api/v1/database");


        expect(response.statusCode)
            .toBe(200);


        expect(response.body.success)
            .toBe(true);


    });


});
