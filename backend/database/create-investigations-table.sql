-- Create lab_investigations table
CREATE TABLE public.lab_investigations (
    id SERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL,
    description VARCHAR(255) NOT NULL,
    method VARCHAR(255),
    unit_id INTEGER,
    result_type VARCHAR(50),
    default_value TEXT,
    location_id INTEGER,
    status VARCHAR(1) DEFAULT '1',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add foreign key constraints
ALTER TABLE public.lab_investigations 
ADD CONSTRAINT fk_lab_investigations_location 
FOREIGN KEY (location_id) REFERENCES public.locations(id);

ALTER TABLE public.lab_investigations 
ADD CONSTRAINT fk_lab_investigations_unit 
FOREIGN KEY (unit_id) REFERENCES public.units(id);

-- Insert sample data (assuming unit IDs exist)
INSERT INTO public.lab_investigations (code, description, method, unit_id, result_type, default_value, location_id) VALUES
('BIO001', 'SERUM AMYLASE', '', NULL, 'One Line Text', 'UP TO 110', 1),
('BIO002', 'SERUM CALCIUM', 'OCPC', NULL, 'Normal Value', '', 1),
('BIO003', 'SERUM LIPASE', '', NULL, 'One Line Text', 'up to 300', 1),
('BIO004', 'CRP(C-REACTIVE PROTEIN)', '', NULL, 'Normal Value', '', 1),
('BIO005', 'RANDOM BLOOD GLUCOSE', 'GOD-POD METHOD', NULL, 'Normal Value', '', 1),
('BIO011', 'TOTAL CHOLESTEROL', 'CHOD-PAP METHOD', NULL, 'One Line Text', 'Desirable:<200 Borderline high :200 - 239 High :>=240', 1);