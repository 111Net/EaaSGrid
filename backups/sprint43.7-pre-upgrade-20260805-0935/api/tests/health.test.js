const request = require("supertest");
const app = require("../src/app");


describe("Health API", () => {

    test("GET /api/v1/health returns status ok", async () => {

        const response = await request(app)
            .get("/api/v1/health");


        expect(response.statusCode)
            .toBe(200);


        expect(response.body.status)
            .toBe("ok");

    });

});
