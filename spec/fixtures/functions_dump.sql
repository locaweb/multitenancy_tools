CREATE OR REPLACE FUNCTION schema1.increment(i integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
          BEGIN
              RETURN i + 1;
          END;
      $function$;
CREATE OR REPLACE FUNCTION schema1.decrement(i integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
          BEGIN
              RETURN i - 1;
          END;
      $function$;
