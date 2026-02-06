CREATE TABLE payment_statuses (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(50) NOT NULL UNIQUE
);

Insert Into payment_statuses(title)values
('in_basket'),
('registered'),
('in_waiting'),
('cancellend');