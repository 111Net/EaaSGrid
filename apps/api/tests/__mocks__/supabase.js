module.exports = {

    from: () => ({

        select: () => ({

            single: async () => ({
                data: {
                    id: "test-id",
                    company_name: "EAASGrid Platform Ltd",
                    country: "Nigeria"
                },
                error: null
            }),

            then: async (resolve) => {
                resolve({
                    data: [],
                    error: null
                });
            }

        })

    })

};
