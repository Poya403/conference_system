create table comments (
    id bigint identity(1,1) primary key,
    user_id bigint not null,

    target_type nvarchar(20) not null, -- 'course' | 'hall'
    target_id bigint not null,

    [text] nvarchar(max) not null,

    score int null check (score between 1 and 5),

    created_at datetime2 default getdate(),
    updated_at datetime2 null
);
