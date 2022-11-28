
create or replace function date_to_unix_ts( PDate in date ) return number is

   l_unix_ts number;

begin

   l_unix_ts := ( PDate - date '1970-01-01' ) * 60 * 60 * 24;
   return l_unix_ts;

end;


