-- Add location_id column to units table
ALTER TABLE public.units 
ADD COLUMN location_id INTEGER;

-- Add foreign key constraint (optional)
ALTER TABLE public.units 
ADD CONSTRAINT fk_units_location 
FOREIGN KEY (location_id) REFERENCES public.locations(id);

-- Update existing records with default location_id (adjust as needed)
UPDATE public.units SET location_id = 1 WHERE location_id IS NULL;