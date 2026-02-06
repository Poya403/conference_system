Create Table courses_types(
	[type_id] bigint identity(1,1) primary key,
	[type_name] nvarchar(255) not null, 
);
CREATE TABLE courses (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,

    title NVARCHAR(80) NOT NULL,

    crs_type_id BIGINT NOT NULL,

    registrants INT NOT NULL 
        CHECK (registrants >= 0),

    delivery_type NVARCHAR(50) NOT NULL,

    cost DECIMAL(10,2) NOT NULL,

    [description] NVARCHAR(MAX),

    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,

    created_at DATETIME NOT NULL 
        DEFAULT GETDATE(),

    contact_phone NVARCHAR(20) NOT NULL,

    [uid] BIGINT NOT NULL,
    hid BIGINT NOT NULL,

    CONSTRAINT FK_courses_users
        FOREIGN KEY ([uid]) 
        REFERENCES users(id),

    CONSTRAINT FK_courses_halls
        FOREIGN KEY (hid) 
        REFERENCES halls(id),

    CONSTRAINT FK_courses_course_types
        FOREIGN KEY (crs_type_id) 
        REFERENCES courses_types(type_id),

    CONSTRAINT CK_courses_time
        CHECK (end_time > start_time)
);


created for checking course times conflicts
CREATE INDEX IX_courses_hall_time
ON courses (hid, start_time, end_time);
