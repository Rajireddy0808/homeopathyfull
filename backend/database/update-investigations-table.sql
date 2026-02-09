-- Drop the unit column and add unit_id foreign key
ALTER TABLE public.investigations DROP COLUMN IF EXISTS unit;
ALTER TABLE public.investigations ADD COLUMN unit_id INTEGER;

-- Add foreign key constraint to units table
ALTER TABLE public.investigations 
ADD CONSTRAINT fk_investigations_unit 
FOREIGN KEY (unit_id) REFERENCES public.units(id);

-- Update sample data with unit_id references (assuming units exist)
UPDATE public.investigations SET unit_id = (SELECT id FROM public.units WHERE code = '21' LIMIT 1) WHERE code = 'BIO001';
UPDATE public.investigations SET unit_id = (SELECT id FROM public.units WHERE code = '074' LIMIT 1) WHERE code = 'BIO002';
UPDATE public.investigations SET unit_id = (SELECT id FROM public.units WHERE code = '21' LIMIT 1) WHERE code = 'BIO003';
UPDATE public.investigations SET unit_id = (SELECT id FROM public.units WHERE code = '074' LIMIT 1) WHERE code = 'BIO005';
UPDATE public.investigations SET unit_id = (SELECT id FROM public.units WHERE code = '074' LIMIT 1) WHERE code = 'BIO011';