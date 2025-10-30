create table halls(
  id bigint generated always as identity primary key,
  title text not null,
  date timestamp not null,
  description text,
  city text,
  area text,
  phone_number text,
  address text
)
