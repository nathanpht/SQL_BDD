DROP SCHEMA IF EXISTS parcoursup CASCADE;
CREATE SCHEMA parcoursup;
SET search_path TO parcoursup;

CREATE TABLE _region (
    region_nom VARCHAR(100),
    CONSTRAINT pk_region PRIMARY KEY (region_nom)
);

CREATE TABLE _departement (
    departement_code VARCHAR(3),
    departement_nom VARCHAR(100),
    region_nom VARCHAR(100),
    CONSTRAINT pk_departement PRIMARY KEY (departement_code),
    CONSTRAINT fk_region FOREIGN KEY (region_nom) REFERENCES _region(region_nom)
);

CREATE TABLE _commune (
    commune_nom VARCHAR(100),
    departement_code VARCHAR(3),
    CONSTRAINT pk_commune PRIMARY KEY (commune_nom, departement_code),
    CONSTRAINT fk_departement FOREIGN KEY (departement_code) REFERENCES _departement(departement_code)
);

CREATE TABLE _etablissement (
    etablissement_code_uai VARCHAR(8),
    etablissement_nom VARCHAR(150),
    etablissement_statut VARCHAR(100),
    CONSTRAINT pk_etablissement PRIMARY KEY (etablissement_code_uai)
);

CREATE TABLE _academie (
    academie_nom VARCHAR(100),
    CONSTRAINT pk_academie PRIMARY KEY (academie_nom)
);

CREATE TABLE _filliere (
    filliere_id INTEGER,
    filliere_libelle VARCHAR(255),
    filliere_libelle_tres_abrege VARCHAR(100),
    filliere_libelle_abrege VARCHAR(100),
    filliere_libelle_detaille_bis VARCHAR(255),
    CONSTRAINT pk_filliere PRIMARY KEY (filliere_id)
);

CREATE TABLE _type_bac (
    type_bac VARCHAR(100),
    CONSTRAINT pk_type_bac PRIMARY KEY (type_bac)
);

CREATE TABLE _mentions_bac (
    libelle_mention VARCHAR(100),
    CONSTRAINT pk_mention PRIMARY KEY (libelle_mention)
);

CREATE TABLE _session (
    session_annee INTEGER,
    CONSTRAINT pk_session PRIMARY KEY (session_annee)
);

CREATE TABLE _regroupement (
    libelle_regroupement VARCHAR(200),
    CONSTRAINT pk_regroupement PRIMARY KEY (libelle_regroupement)
);

CREATE TABLE _formation (
    cod_aff_form VARCHAR(10),
    capacite_formation INTEGER,
    filliere_id INTEGER,
    etablissement_code_uai VARCHAR(8),
    commune_nom VARCHAR(100),
    departement_code VARCHAR(3),
    session_annee INTEGER,
    academie_nom VARCHAR(100),
    CONSTRAINT pk_formation PRIMARY KEY (cod_aff_form),
    CONSTRAINT fk_filliere FOREIGN KEY (filliere_id) REFERENCES _filliere(filliere_id),
    CONSTRAINT fk_etablissement FOREIGN KEY (etablissement_code_uai) REFERENCES _etablissement(etablissement_code_uai),
    CONSTRAINT fk_commune FOREIGN KEY (commune_nom, departement_code) REFERENCES _commune(commune_nom, departement_code),
    CONSTRAINT fk_session FOREIGN KEY (session_annee) REFERENCES _session(session_annee),
    CONSTRAINT fk_academie FOREIGN KEY (academie_nom) REFERENCES _academie(academie_nom)
);

CREATE TABLE _admission_generalites (
    cod_aff_form VARCHAR(10),
    session_annee INTEGER,
    effectif_total_candidats INTEGER,
    effectif_total_candidates INTEGER,
    effectif_total_admis INTEGER,
    effectif_total_admises INTEGER,
    CONSTRAINT pk_admission_gen PRIMARY KEY (cod_aff_form, session_annee),
    CONSTRAINT fk_formation_gen FOREIGN KEY (cod_aff_form) REFERENCES _formation(cod_aff_form),
    CONSTRAINT fk_session_gen FOREIGN KEY (session_annee) REFERENCES _session(session_annee)
);

CREATE TABLE _admission_selon_type_neo_bac (
    cod_aff_form VARCHAR(10),
    type_bac VARCHAR(100),
    session_annee INTEGER,
    effectif_admis_neo_bac INTEGER,
    CONSTRAINT pk_admission_bac PRIMARY KEY (cod_aff_form, type_bac, session_annee),
    CONSTRAINT fk_formation_bac FOREIGN KEY (cod_aff_form) REFERENCES _formation(cod_aff_form),
    CONSTRAINT fk_type_bac FOREIGN KEY (type_bac) REFERENCES _type_bac(type_bac),
    CONSTRAINT fk_session_bac FOREIGN KEY (session_annee) REFERENCES _session(session_annee)
);

CREATE TABLE _effectif_selon_mention (
    cod_aff_form VARCHAR(10),
    libelle_mention VARCHAR(100),
    session_annee INTEGER,
    effectif_admis_mention INTEGER,
    CONSTRAINT pk_eff_mention PRIMARY KEY (cod_aff_form, libelle_mention, session_annee),
    CONSTRAINT fk_formation_ment FOREIGN KEY (cod_aff_form) REFERENCES _formation(cod_aff_form),
    CONSTRAINT fk_mention FOREIGN KEY (libelle_mention) REFERENCES _mentions_bac(libelle_mention),
    CONSTRAINT fk_session_ment FOREIGN KEY (session_annee) REFERENCES _session(session_annee)
);

CREATE TABLE _rang_dernier_appel_selon_regrouppement (
    cod_aff_form VARCHAR(10),
    libelle_regroupement VARCHAR(200),
    session_annee INTEGER,
    rang_dernier_appele INTEGER,
    CONSTRAINT pk_rang_reg PRIMARY KEY (cod_aff_form, libelle_regroupement, session_annee),
    CONSTRAINT fk_formation_reg FOREIGN KEY (cod_aff_form) REFERENCES _formation(cod_aff_form),
    CONSTRAINT fk_regroupement FOREIGN KEY (libelle_regroupement) REFERENCES _regroupement(libelle_regroupement),
    CONSTRAINT fk_session_reg FOREIGN KEY (session_annee) REFERENCES _session(session_annee)
);