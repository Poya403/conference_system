create table amenities (
  id bigint generated always as identity primary key,
  name text not null
);

create table hall_amenities (
  hall_id bigint references halls(id) on delete cascade,
  amenity_id bigint references amenities(id) on delete cascade,
  primary key (hall_id, amenity_id)
);