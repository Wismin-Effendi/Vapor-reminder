--
-- Inspired by: http://www.divillo.com 


Wismins-MacBook-Pro:listen wismin-effendi$ psql reminders
psql (10.0)
Type "help" for help.



reminders-# \d
                      List of relations
 Schema |           Name           |   Type   |     Owner     
--------+--------------------------+----------+---------------
 public | categories               | table    | reminder_user
 public | categories_id_seq        | sequence | reminder_user
 public | category_reminder        | table    | reminder_user
 public | category_reminder_id_seq | sequence | reminder_user
 public | fluent                   | table    | reminder_user
 public | fluent_id_seq            | sequence | reminder_user
 public | reminders                | table    | reminder_user
 public | reminders_id_seq         | sequence | reminder_user
 public | users                    | table    | reminder_user
 public | users_id_seq             | sequence | reminder_user
(10 rows)


-----

create function notify_trigger() returns trigger AS $$
DECLARE 
BEGIN
execute CONCAT('NOTIFY test_channel',E',\'', TG_TABLE_NAME, '_', TG_OP, E'\''); 
return new;
END;

$$ LANGUAGE plpgsql;


create trigger categories_trigger before insert or update or delete on categories execute procedure notify_trigger(); 

create trigger reminders_trigger before insert or update or delete on reminders execute procedure notify_trigger();

create trigger users_trigger before insert or update or delete on users execute procedure notify_trigger(); 


