-- Clean up:
UPDATE `ringer_kooikers` SET minlv = NULL WHERE 1;

-- In totaal zijn er nu 182 rids geelimineerd, dus nog 81 kandidaten. 

-- Deze 81 kandidaten heb ik vergeleken met de "Registratie Eendenkooien"
-- 1984-1989 van het Ministerie van Landbouw en Visserij.
-- Ik heb gezocht naar overeenkomsten van:
-- - naam en gemeente, OF
-- - adres en gemeente

--Dit levert nog eens 13 bevestigingen:
UPDATE `ringer_kooikers` SET 
minlv = true
WHERE 
rid = "735" OR
rid = "790" OR
rid = "754" OR
rid = "789" OR
rid = "404" OR
rid = "124" OR
rid = "365" OR
rid = "456" OR
rid = "791" OR
rid = "399" OR
rid = "712" OR
rid = "288" OR
rid = "372";

-- Desire Karelse en Fons Mandigers hebben zich over 67 overgebleven 
-- gebogen en er tevens nog een paar aan toegevoegd.
-- Ze maakten onderscheid tussen:
-- * zeker een ringer
-- * contacten met ringers
-- * misschien een ringer
-- Mijn hypothese is dat in de praktijk niet goed is bijgehouden
-- wie precies welke ring heeft uitgegeven en dat ringen nog
-- al eens via-via bij de kooikers terecht kwamen. Ik heb dus
-- al deze mogelijkheden bij elkaar geveegd en onder "True" 
-- geboekt. De orginele mails heb ik uiteraard bewaard.

UPDATE `ringer_kooikers` SET
expert = true,
kooiker_vermoed = true
WHERE
rid = "997" OR
rid = "058" OR
rid = "034" OR
rid = "044" OR
rid = "047" OR
rid = "081" OR
rid = "082" OR
rid = "092" OR
rid = "T52" OR
rid = "117" OR
rid = "113" OR
rid = "T36" OR
rid = "411" OR
rid = "151" OR
rid = "712" OR
rid = "166" OR
rid = "195" OR
rid = "203" OR
rid = "C59" OR
rid = "227" OR
rid = "365" OR
rid = "724" OR
rid = "257" OR
rid = "851" OR
rid = "745" OR
rid = "792" OR
rid = "C03" OR
rid = "817" OR
rid = "292" OR
rid = "367" OR
rid = "320" OR
rid = "380" OR
rid = "E03" OR
rid = "391" OR
rid = "882";


