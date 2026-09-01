const request = require("supertest");
const app = require("../src/app");


describe("Database API", () => {


    test("GET /api/database returns database records", async () => {


        const response = await request(app)
            .get("/api/database");


        expect(response.statusCode)
            .toBe(200);


        expect(response.body.success)
            .toBe(true);


    });


});
