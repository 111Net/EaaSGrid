
CREATE TABLE IF NOT EXISTS customers (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID,

    company_name VARCHAR(255),

    status VARCHAR(50)
    DEFAULT 'ACTIVE',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE IF NOT EXISTS plans (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(100),

    description TEXT,

    monthly_price NUMERIC DEFAULT 0,

    status VARCHAR(50)
    DEFAULT 'ACTIVE',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE IF NOT EXISTS subscriptions (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    customer_id UUID,

    plan_id UUID,

    status VARCHAR(50)
    DEFAULT 'ACTIVE',

    start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE IF NOT EXISTS invoices (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    customer_id UUID,

    amount NUMERIC DEFAULT 0,

    status VARCHAR(50)
    DEFAULT 'PENDING',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE IF NOT EXISTS payments (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    invoice_id UUID,

    amount NUMERIC DEFAULT 0,

    payment_status VARCHAR(50)
    DEFAULT 'PENDING',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);



CREATE TABLE IF NOT EXISTS monitoring_events (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    service VARCHAR(100),

    status VARCHAR(50),

    message TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

