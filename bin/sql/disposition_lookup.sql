CREATE TABLE public.lk_dispositioncodes
(
  code character(6) NOT NULL,
  definition text NOT NULL,
  CONSTRAINT lk_dispositioncodes_pkey PRIMARY KEY (code)
)