select enrollments.*,
courses.id ,
courses.title ,
users.id,
users.full_name ,
courses.description ,
courses.contact_phone,
courses.delivery_type 
from enrollments
join courses on courses.id = enrollments.course_id
join users on users.id = enrollments.user_id;