--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: headers; Type: TABLE; Schema: public; Owner: ofim; Tablespace: 
--

CREATE TABLE headers (
    id integer NOT NULL,
    name character varying(255),
    value text,
    report_id integer
);


ALTER TABLE public.headers OWNER TO ofim;

--
-- Name: headers_id_seq; Type: SEQUENCE; Schema: public; Owner: ofim
--

CREATE SEQUENCE headers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.headers_id_seq OWNER TO ofim;

--
-- Name: headers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ofim
--

ALTER SEQUENCE headers_id_seq OWNED BY headers.id;


--
-- Name: links; Type: TABLE; Schema: public; Owner: ofim; Tablespace: 
--

CREATE TABLE links (
    id integer NOT NULL,
    name character varying(255),
    href character varying(255),
    rel character varying(45),
    target character varying(45),
    report_id integer
);


ALTER TABLE public.links OWNER TO ofim;

--
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: ofim
--

CREATE SEQUENCE links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.links_id_seq OWNER TO ofim;

--
-- Name: links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ofim
--

ALTER SEQUENCE links_id_seq OWNED BY links.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: ofim; Tablespace: 
--

CREATE TABLE reports (
    id integer NOT NULL,
    url character varying(255),
    domain character varying(100),
    ip character varying(45),
    title character varying(255),
    date timestamp without time zone
);


ALTER TABLE public.reports OWNER TO ofim;

--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: ofim
--

CREATE SEQUENCE reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reports_id_seq OWNER TO ofim;

--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ofim
--

ALTER SEQUENCE reports_id_seq OWNED BY reports.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ofim
--

ALTER TABLE ONLY headers ALTER COLUMN id SET DEFAULT nextval('headers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ofim
--

ALTER TABLE ONLY links ALTER COLUMN id SET DEFAULT nextval('links_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ofim
--

ALTER TABLE ONLY reports ALTER COLUMN id SET DEFAULT nextval('reports_id_seq'::regclass);


--
-- Name: pk_id_headers; Type: CONSTRAINT; Schema: public; Owner: ofim; Tablespace: 
--

ALTER TABLE ONLY headers
    ADD CONSTRAINT pk_id_headers PRIMARY KEY (id);


--
-- Name: pk_id_links; Type: CONSTRAINT; Schema: public; Owner: ofim; Tablespace: 
--

ALTER TABLE ONLY links
    ADD CONSTRAINT pk_id_links PRIMARY KEY (id);


--
-- Name: pk_id_reports; Type: CONSTRAINT; Schema: public; Owner: ofim; Tablespace: 
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT pk_id_reports PRIMARY KEY (id);


--
-- Name: fki_id_report; Type: INDEX; Schema: public; Owner: ofim; Tablespace: 
--

CREATE INDEX fki_id_report ON links USING btree (report_id);


--
-- Name: fkii_id_report; Type: INDEX; Schema: public; Owner: ofim; Tablespace: 
--

CREATE INDEX fkii_id_report ON headers USING btree (report_id);


--
-- Name: fk_id_report; Type: FK CONSTRAINT; Schema: public; Owner: ofim
--

ALTER TABLE ONLY links
    ADD CONSTRAINT fk_id_report FOREIGN KEY (report_id) REFERENCES reports(id) ON DELETE RESTRICT;


--
-- Name: fk_id_report; Type: FK CONSTRAINT; Schema: public; Owner: ofim
--

ALTER TABLE ONLY headers
    ADD CONSTRAINT fk_id_report FOREIGN KEY (report_id) REFERENCES reports(id) ON DELETE RESTRICT;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

