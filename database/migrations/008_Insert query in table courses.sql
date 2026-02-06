INSERT INTO courses
(
    title,
    crs_type_id,
    registrants,
    delivery_type,
    cost,
    [description],
    start_time,
    end_time,
    contact_phone,
    [uid],
    hid
)
VALUES

(N'دوره شماره 1', 3, 0, N'حضوری', 0,
 N'توضیحات دوره شماره 1',
 DATEADD(DAY, 7, GETDATE()),
 DATEADD(DAY, 14, GETDATE()),
 N'09911134869', 1, 3),

(N'دوره شماره 2', 7, 0, N'مجازی', 0,
 N'توضیحات دوره شماره 2',
 DATEADD(DAY, 9, GETDATE()),
 DATEADD(DAY, 16, GETDATE()),
 N'09911134869', 1, NULL),

(N'دوره شماره 3', 1, 0, N'حضوری', 0,
 N'توضیحات دوره شماره 3',
 DATEADD(DAY, 11, GETDATE()),
 DATEADD(DAY, 18, GETDATE()),
 N'09911134869', 1, 11),

(N'دوره شماره 4', 10, 0, N'مجازی', 0,
 N'توضیحات دوره شماره 4',
 DATEADD(DAY, 13, GETDATE()),
 DATEADD(DAY, 20, GETDATE()),
 N'09911134869', 1, NULL),

(N'دوره شماره 5', 5, 0, N'حضوری', 0,
 N'توضیحات دوره شماره 5',
 DATEADD(DAY, 15, GETDATE()),
 DATEADD(DAY, 22, GETDATE()),
 N'09911134869', 1, 7),

(N'دوره شماره 6', 2, 0, N'مجازی', 0,
 N'توضیحات دوره شماره 6',
 DATEADD(DAY, 17, GETDATE()),
 DATEADD(DAY, 24, GETDATE()),
 N'09911134869', 1, NULL),

(N'دوره شماره 7', 8, 0, N'حضوری', 0,
 N'توضیحات دوره شماره 7',
 DATEADD(DAY, 19, GETDATE()),
 DATEADD(DAY, 26, GETDATE()),
 N'09911134869', 1, 4),

(N'دوره شماره 8', 6, 0, N'مجازی', 0,
 N'توضیحات دوره شماره 8',
 DATEADD(DAY, 21, GETDATE()),
 DATEADD(DAY, 28, GETDATE()),
 N'09911134869', 1, NULL);


