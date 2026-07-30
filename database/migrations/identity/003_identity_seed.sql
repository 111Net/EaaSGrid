
INSERT INTO roles(name, description)
VALUES
('ADMIN','Full platform administration'),
('OPERATIONS','Daily platform operations'),
('PARTNER','Partner ecosystem access'),
('CUSTOMER','Customer portal access'),
('INVESTOR','Investor access'),
('COLLABORATOR','Collaboration access')
ON CONFLICT(name) DO NOTHING;


INSERT INTO permissions(name)
VALUES
('platform.admin'),
('platform.operations'),
('partner.manage'),
('customer.manage'),
('billing.manage'),
('investor.view'),
('system.settings')
ON CONFLICT(name) DO NOTHING;

