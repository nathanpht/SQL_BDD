--- jdbc:postgresql://servbdd:5432/pg_tp1a
--- TP 6 - LMD - Client - Commande - Stock
---



-- Q1 tous les articles
SELECT * FROM stock;

-- Q2 tous les clients
SELECT * FROM client;

-- Q3 toutes les commandes
SELECT * FROM commande;

-- Q4 le nom de chaque article
SELECT nom_art FROM stock;

-- Q5 le nom et l'adresse de chaque client
SELECT nom_cli, adresse_cli FROM client;

-- Q6 le nom et le numero des clients dont l'adresse n'est pas connue
SELECT num_cli, nom_cli 
FROM client
WHERE adresse_cli is NULL ;

-- Q7 les articles de type Philosophie
SELECT nom_art
FROM stock
WHERE type_art = 'Philosophie';

-- Q8 nom et type des article de type  Philosophie ou Litterature
SELECT nom_art
FROM stock
WHERE type_art = 'Philosophie' OR type_art = 'Litterature';

-- Q9 nom et type des articles dont la quantite en stock est >=100
SELECT nom_art, type_art
FROM stock
WHERE quantite_art >= 100;

-- Q10 articles de type Sciences dont la quantite en stock
-- est inferieure a 100
SELECT *
FROM stock
WHERE type_art = 'Sciences' AND quantite_art < 100;

-- Q11 nom des articles de type Sciences dont la quantite en stock
-- est inferieure a 100
SELECT nom_art
FROM stock
WHERE type_art = 'Sciences' AND quantite_art < 100;

-- Q12 nom des articles dont la valeur du stock est > 1000
SELECT nom_art
FROM stock
WHERE (quantite_art*prix_art) > 1000;


-- Q13 nom et type des articles qui sont en rupture de stock
SELECT nom_art
FROM stock
WHERE quantite_art = 0;


-- Q14 nom et type des articles qui sont approvisionnés
SELECT nom_art,type_art
FROM stock
WHERE quantite_art > 0;

-- Q15  nom des articles commandés
SELECT stock.nom_art
FROM stock 
INNER JOIN commande 
  ON stock.num_art = commande.num_art_c;

-- Q16 nom des clients ayant commandé
SELECT client.nom_cli
FROM client 
INNER JOIN commande 
  ON client.num_cli = commande.num_cli_c;

-- Q17 numéro des clients n'ayant jamais commandé
SELECT client.nom_cli
FROM client 
LEFT JOIN commande 
  ON client.num_cli = commande.num_cli_c
WHERE commande.num_cli_c IS NULL;

-- Q18 commandes qui concernent des articles qui ne sont pas de type
-- 'Philosophie'
SELECT stock.num_art
FROM stock 
INNER JOIN commande 
  ON stock.num_art = commande.num_art_c
WHERE stock.type_art != 'Philosophie';

-- Q19 nom des articles de type Sciences dont au moins une commande 
-- a un montant >800
SELECT stock.num_art
FROM stock 
INNER JOIN commande 
  ON stock.num_art = commande.num_art_c
WHERE (stock.prix_art*commande.quantite_art_c) > 800 AND stock.type_art = 'Sciences';

-- Q20 Valeur du stock
SELECT SUM(prix_art*quantite_art) as valeur_stock
FROM stock;

-- Q21 Somme des montants des commandes
SELECT SUM(stock.prix_art*commande.quantite_art_c) as valeur_total
FROM commande
INNER JOIN stock
  ON stock.num_art = commande.num_art_c;

-- Q22 nom des clients ayant commande(au moins un) article de type Philosophie
SELECT DISTINCT client.nom_cli
FROM client
INNER JOIN commande
    ON client.num_cli = commande.num_cli_c
INNER JOIN stock
    ON stock.num_art = commande.num_art_c
WHERE stock.type_art = 'Philosophie';

-- Q23 numéro des articles sujets a au moins deux commandes
-- (qu'est ce qui identifie une commande) ?
SELECT num_art_c
FROM commande
GROUP BY num_art_c
HAVING COUNT(*) >= 2;

-- Q24 Couples de  numero de clients (n1,n2) tels que les clients soient differents
-- et aient meme adresse
SELECT c1.num_cli AS client1, c2.num_cli AS client2
FROM client c1
JOIN client c2 
    ON c1.adresse_cli = c2.adresse_cli
WHERE c1.num_cli <> c2.num_cli; 

-- Q25 nombre de clients

SELECT COUNT(*) AS nb_clients
FROM clientv  

-- Q26 quantité minimale en stock
SELECT MIN(quantite_art) AS quantite_min
FROM stock;

-- Q27 Quantite maximale en stock des articles de type Philosophie
SELECT MAX(quantite_art) AS quantite_max_philo
FROM stock
WHERE type_art = 'Philosophie';

-- Q28 moyenne des quantites en stock
SELECT AVG(quantite_art) AS moyenne_stock
FROM stock;



-- Q30 nom des articles commandes par les clients no 4 ou  no 2 
SELECT stock.nom_art
FROM stock
INNER JOIN commande 
    ON stock.num_art = commande.num_art_c
INNER JOIN client
    ON commande.num_cli_c = client.num_cli
WHERE client.num_cli = 2 OR client.num_cli = 4;

-- Q31 nom des articles non commandes par les clients no 4 ou no 2
SELECT stock.nom_art, client.nom_cli
FROM stock
INNER JOIN commande 
    ON stock.num_art = commande.num_art_c
INNER JOIN client
    ON commande.num_cli_c = client.num_cli
WHERE client.num_cli != 2 OR client.num_cli != 4
ORDER BY client.nom_cli;

-- Q32 nom des articles tels qu'il existe au moins une commande de quantite
-- supérieure à celle en stock
SELECT DISTINCT stock.nom_art
FROM stock
JOIN commande
    ON stock.num_art = commande.num_art_c
WHERE commande.quantite_art_c > stock.quantite_art;

-- Q33 numéro des articles qui ne sont commandés qu'une seule fois
SELECT num_art_c
FROM commande
GROUP BY num_art_c
HAVING COUNT(*) = 1;

-- Q34 la moyenne des quantites commandees des articles
-- de type Litterature
SELECT AVG(commande.quantite_art_c) AS moyenne_quantite
FROM commande
JOIN stock
    ON commande.num_art_c = stock.num_art
WHERE stock.type_art = 'Litterature';

-- 36. Par numéro article : somme et maximum des quantités commandées
SELECT num_art_c,
       SUM(quantite_art_c) AS somme_qte,
       MAX(quantite_art_c) AS max_qte
FROM commande
GROUP BY num_art_c;

-- 37. Pour chaque article : nom, min, max et moyenne des quantités commandées
SELECT stock.nom_art,
       MIN(commande.quantite_art_c) AS min_quantite,
       MAX(commande.quantite_art_c) AS max_quantite,
       AVG(commande.quantite_art_c) AS moy_quantite
FROM commande
JOIN stock ON commande.num_art_c = stock.num_art
GROUP BY stock.nom_art;

-- 38. Numéro des articles sujets à au moins 2 commandes
SELECT num_art_c
FROM commande
GROUP BY num_art_c
HAVING COUNT(*) >= 2;
  
-- Q39 nombre de commandes du client numero 1
SELECT num_art_c
FROM commande
GROUP BY num_art_c
HAVING COUNT(*) <= 3;

/-- 40. Numéro des articles sujets à exactement 2 commandes
SELECT num_art_c
FROM commande
GROUP BY num_art_c
HAVING COUNT(*) = 2;

-- 41. Nom des articles dont la somme des quantités commandées excède 100
SELECT stock.nom_art
FROM commande
JOIN stock 
    ON commande.num_art_c = stock.num_art
GROUP BY stock.nom_art
HAVING SUM(commande.quantite_art_c) > 100;

-- 42. Nom et numéro des clients ayant passé au moins 2 commandes du même produit
SELECT client.num_cli, client.nom_cli
FROM commande
JOIN client 
    ON commande.num_cli_c = client.num_cli
GROUP BY client.num_cli, client.nom_cli, commande.num_art_c
HAVING COUNT(*) >= 2;

-- 43. Nom et numéro des clients ayant passé au moins 2 commandes de produits différents
SELECT client.num_cli, client.nom_cli
FROM commande
JOIN client 
    ON commande.num_cli_c = client.num_cli
GROUP BY client.num_cli, client.nom_cli
HAVING COUNT(DISTINCT commande.num_art_c) >= 2;

-- 44. Moyenne des quantités commandées de chaque article de type 'Litterature'
SELECT stock.nom_art,
       AVG(commande.quantite_art_c) AS moy_quantite
FROM commande
JOIN stock
    ON commande.num_art_c = stock.num_art
WHERE stock.type_art = 'Litterature'
GROUP BY stock.nom_art;

-- 45. Moyenne des quantités commandées pour les articles sujets à au moins 3 commandes
SELECT num_art_c,
       AVG(quantite_art_c) AS moy_quantite
FROM commande
GROUP BY num_art_c
HAVING COUNT(*) >= 3;

-- 46. Numéro des articles dont la moyenne des quantités commandées est supérieure à 15
SELECT num_art_c
FROM commande
GROUP BY num_art_c
HAVING AVG(quantite_art_c) > 15;

-- 47. Nom des clients ayant effectué au moins 3 commandes
SELECT client.nom_cli
FROM commande
JOIN client 
    ON commande.num_cli_c = client.num_cli
GROUP BY client.nom_cli
HAVING COUNT(*) >= 3;

-- 48. Nombre de jours entre la première et la dernière commande de chaque client
SELECT num_cli_c,
       MAX(date_com) - MIN(date_com) AS nbr_jours
FROM commande
GROUP BY num_cli_c;

-- 49. Date de la dernière commande de chaque client
SELECT num_cli_c,
       MAX(date_com) AS derniere_commande
FROM commande
GROUP BY num_cli_c;

/*
*
*        REQUETES COMPLEXES
*
*/

/* -50- le nom des articles dont la quantité en stock est maximale.*/
SELECT *
FROM stock
INNER JOIN commande
    ON stock.num_art = commande.num_art_c
WHERE quantite_art_c = (SELECT MAX(quantite_art_c)FROM commande);

/* -51- le nom des articles dont au moins une commande est de quantité commandée supérieure à la quantité en stock.*/
SELECT *
FROM stock 
INNER JOIN commande
    ON stock.num_art = commande.num_art_c
WHERE quantite_art_c >= quantite_art;

/* -Q52- nom des articles dont la somme des quantités commandées est supérieure à la quantité en stock */
SELECT stock.nom_art
FROM stock
JOIN commande
    ON stock.num_art = commande.num_art_c
GROUP BY stock.nom_art, stock.quantite_art
HAVING SUM(commande.quantite_art_c) > stock.quantite_art;


/* -Q53- nom des articles tels que toutes les commandes sont de quantité supérieure à celle en stock */
SELECT stock.nom_art
FROM stock
JOIN commande
    ON stock.num_art = commande.num_art_c
GROUP BY stock.nom_art, stock.quantite_art
HAVING MIN(commande.quantite_art_c) > stock.quantite_art;


-- Q54 numéro des articles qui ne sont commandés qu'une seule fois
SELECT num_art_c
FROM commande
GROUP BY num_art_c
HAVING COUNT(*) = 1;


-- Q55 numéro des clients qui ont commandé tous les livres de Philosophie
SELECT num_cli
FROM client
WHERE NOT EXISTS (
    SELECT num_art
    FROM stock
    WHERE type_art = 'Philosophie'
    AND num_art NOT IN (
        SELECT num_art_c
        FROM commande
        WHERE commande.num_cli_c = client.num_cli )
);

-- Q56 le plus ancien client (numéro et nom)
SELECT num_cli, nom_cli
FROM client
WHERE num_cli = (SELECT MIN(num_cli) FROM client);


-- Q57 le premier client à avoir acheté un exemplaire de '1984'
SELECT client.nom_cli
FROM client
JOIN commande
    ON client.num_cli = commande.num_cli_c
JOIN stock
    ON stock.num_art = commande.num_art_c
WHERE stock.nom_art = '1984'
ORDER BY commande.date_com
LIMIT 1;

-- Q58 la dernière commande en date de chaque client
SELECT num_cli_c, MAX(date_com) AS derniere_commande
FROM commande
GROUP BY num_cli_c;


/*
*
*        REQUETES SUR LES DATES
*
*/

-- 59 - La date d'aujourd'hui selon le format: \og lundi 16 décembre 2013\fg{}.
-- 60 - L'heure courante sous la forme: \og 13:24:52\fg{}.
-- 61 - Quelles sont les commandes passées en octobre 2013?
-- 62 - Quelles sont les commandes passées il y a au plus trente jours?
-- 63 - Nom des clients ayant passé des commandes il y a au plus  trente jours?
-- 64 - Quelles sont les commandes passes entre le 16/08/2013 et le 16/11/2013 ?
-- 65 - Nom des clients ayant passé une commande un vendredi?
-- 66 - Nom des clients ayant passé une commande un jeudi ou un vendredi?
-- 67 - Quels sont les clients (numéro et nom) qui ont passé des commandes au cours du premier trimestre de l'année courante?
-- 68 - Quels sont les clients (numéro et nom) qui n'ont pas passé de commande durant les deux derniers mois (60 jours)?
-- 69 - Quels sont les clients qui ont passé toutes leurs commandes durant le même mois?
