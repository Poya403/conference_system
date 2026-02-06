-- حذف اگر وجود دارند
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS payment_statuses;

-- ایجاد payment_statuses
CREATE TABLE payment_statuses (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO payment_statuses (title) VALUES
('in_basket'),
('registered'),
('in_waiting'),
('cancelled');

CREATE TABLE enrollments (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    payment_status_id INT NOT NULL DEFAULT 1,
    enroll_date DATETIME DEFAULT GETDATE(),
    amount DECIMAL(18,2) NOT NULL,
    
    -- Foreign Keys
    CONSTRAINT FK_enrollments_users FOREIGN KEY (user_id) 
        REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT FK_enrollments_courses FOREIGN KEY (course_id) 
        REFERENCES courses(id) ON DELETE CASCADE,
    CONSTRAINT FK_enrollments_payment_status FOREIGN KEY (payment_status_id) 
        REFERENCES payment_statuses(id),
        
    CONSTRAINT UQ_enrollment_user_course UNIQUE (user_id, course_id)
);