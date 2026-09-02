const prisma = require("../src/database/prisma");

const SHOWCASE_METRICS = [
  "revenue",
  "services",
  "apiRequests",
  "uptime",
];

const SOURCE_TYPE = "SHOWCASE_BASELINE";
const SOURCE = "seed:44.2.12.37";

async function main() {
  console.log("Starting Sprint 44.2.13 Intelligence provenance seed");

  for (const metricName of SHOWCASE_METRICS) {
    const existing = await prisma.platformMetric.findFirst({
      where: {
        metricName,
      },
      orderBy: {
        id: "asc",
      },
    });

    if (!existing) {
      console.log(`SKIP: ${metricName} does not exist`);
      continue;
    }

    await prisma.platformMetric.update({
      where: {
        id: existing.id,
      },
      data: {
        sourceType: SOURCE_TYPE,
        source: SOURCE,
      },
    });

    console.log(
      `OK: ${metricName} -> ${SOURCE_TYPE} / ${SOURCE}`
    );
  }

  console.log("Customers metric intentionally left unchanged:");
  console.log("  DATABASE_DERIVED / customer_accounts.count");

  const metrics = await prisma.platformMetric.findMany({
    where: {
      metricName: {
        in: [
          "revenue",
          "customers",
          "services",
          "apiRequests",
          "uptime",
        ],
      },
    },
    orderBy: {
      id: "asc",
    },
  });

  console.log("\nFinal Intelligence metric provenance:");
  console.table(
    metrics.map((metric) => ({
      id: metric.id,
      metric: metric.metricName,
      value: metric.metricValue?.toString(),
      sourceType: metric.sourceType,
      source: metric.source,
    }))
  );
}

main()
  .catch((error) => {
    console.error("Intelligence provenance seed failed:");
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
