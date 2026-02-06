CREATE TABLE Reservation (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    cid BIGINT NOT NULL,
    hid BIGINT NOT NULL,
    holding_date DATETIME NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status_type NVARCHAR(20) NOT NULL,
    CONSTRAINT CHK_Reservation_Status CHECK (status_type IN ('scheduled', 'done', 'canceled')),
    CONSTRAINT FK_Reservation_Course FOREIGN KEY (cid) REFERENCES Courses(id),
    CONSTRAINT FK_Reservation_Hall FOREIGN KEY (hid) REFERENCES Halls(id)
);
