Select
reservations.id,
reservations.holding_date,
reservations.start_time,
reservations.end_time,
halls.title	as hall_title,
halls.description as hall_description,
courses.title as courses_title
from reservations
join halls on halls.id = reservations.cid
join courses on courses.id = reservations.cid
join payment_statuses on reservations.id = payment_statuses.id;