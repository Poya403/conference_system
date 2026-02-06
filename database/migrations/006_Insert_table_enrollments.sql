CREATE TABLE enrollments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    payment_status INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);
