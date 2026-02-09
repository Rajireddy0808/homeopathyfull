-- HIMS Laboratory Masters Database Tables
-- Database: hims_laboratory

-- Connect to hims_laboratory database

-- 1. Laboratory Units Master
CREATE TABLE lab_units (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    code VARCHAR(20) NOT NULL,
    description VARCHAR(255) NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER,
    updated_by INTEGER,
    CONSTRAINT unique_location_code_units UNIQUE (location_id, code)
);

-- 2. Laboratory Specimens Master
CREATE TABLE lab_specimens (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    code VARCHAR(20) NOT NULL,
    description VARCHAR(255) NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER,
    updated_by INTEGER,
    CONSTRAINT unique_location_code_specimens UNIQUE (location_id, code)
);

-- 3. Laboratory Containers Master
CREATE TABLE lab_containers (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    code VARCHAR(20) NOT NULL,
    description VARCHAR(255) NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER,
    updated_by INTEGER,
    CONSTRAINT unique_location_code_containers UNIQUE (location_id, code)
);

-- 4. Laboratory Methods Master
CREATE TABLE lab_methods (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    code VARCHAR(20) NOT NULL,
    description VARCHAR(255) NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER,
    updated_by INTEGER,
    CONSTRAINT unique_location_code_methods UNIQUE (location_id, code)
);

-- 5. Laboratory Test Master
CREATE TABLE lab_tests (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    department VARCHAR(100),
    sub_department VARCHAR(100),
    lab_type VARCHAR(100),
    specimen_id INTEGER,
    method_id INTEGER,
    container_id INTEGER,
    unit_id INTEGER,
    report_type VARCHAR(100),
    interpretation VARCHAR(3) DEFAULT 'No' CHECK (interpretation IN ('Yes', 'No')),
    test_type VARCHAR(10) DEFAULT 'Normal' CHECK (test_type IN ('Profile', 'Panel', 'Normal')),
    service_applicable_male BOOLEAN DEFAULT FALSE,
    service_applicable_female BOOLEAN DEFAULT FALSE,
    service_applicable_both BOOLEAN DEFAULT TRUE,
    signature_required BOOLEAN DEFAULT FALSE,
    result_restricted BOOLEAN DEFAULT FALSE,
    normal_range_min DECIMAL(10,3),
    normal_range_max DECIMAL(10,3),
    critical_low DECIMAL(10,3),
    critical_high DECIMAL(10,3),
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER,
    updated_by INTEGER,
    CONSTRAINT unique_location_code_tests UNIQUE (location_id, code),
    CONSTRAINT fk_tests_specimen FOREIGN KEY (specimen_id) REFERENCES lab_specimens(id),
    CONSTRAINT fk_tests_method FOREIGN KEY (method_id) REFERENCES lab_methods(id),
    CONSTRAINT fk_tests_container FOREIGN KEY (container_id) REFERENCES lab_containers(id),
    CONSTRAINT fk_tests_unit FOREIGN KEY (unit_id) REFERENCES lab_units(id)
);

-- 6. Laboratory Templates Master
CREATE TABLE lab_templates (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    template_content TEXT,
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER,
    updated_by INTEGER,
    CONSTRAINT unique_location_code_templates UNIQUE (location_id, code)
);

-- 7. Laboratory Investigation Master
CREATE TABLE lab_investigations (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER,
    updated_by INTEGER,
    CONSTRAINT unique_location_code_investigations UNIQUE (location_id, code)
);

-- 8. Laboratory Profile Test Link (Many-to-Many relationship)
CREATE TABLE lab_profile_test_links (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    profile_test_id INTEGER NOT NULL,
    linked_test_id INTEGER NOT NULL,
    sequence_order INTEGER DEFAULT 1,
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER,
    updated_by INTEGER,
    CONSTRAINT fk_profile_test FOREIGN KEY (profile_test_id) REFERENCES lab_tests(id) ON DELETE CASCADE,
    CONSTRAINT fk_linked_test FOREIGN KEY (linked_test_id) REFERENCES lab_tests(id) ON DELETE CASCADE,
    CONSTRAINT unique_profile_link UNIQUE (location_id, profile_test_id, linked_test_id)
);

-- 9. Laboratory Test Template Link (Many-to-Many relationship)
CREATE TABLE lab_test_template_links (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL,
    test_id INTEGER NOT NULL,
    template_id INTEGER NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER,
    updated_by INTEGER,
    CONSTRAINT fk_test_template_test FOREIGN KEY (test_id) REFERENCES lab_tests(id) ON DELETE CASCADE,
    CONSTRAINT fk_test_template_template FOREIGN KEY (template_id) REFERENCES lab_templates(id) ON DELETE CASCADE,
    CONSTRAINT unique_test_template UNIQUE (location_id, test_id, template_id)
);

-- Create triggers for updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_lab_units_updated_at BEFORE UPDATE ON lab_units FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_lab_specimens_updated_at BEFORE UPDATE ON lab_specimens FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_lab_containers_updated_at BEFORE UPDATE ON lab_containers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_lab_methods_updated_at BEFORE UPDATE ON lab_methods FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_lab_tests_updated_at BEFORE UPDATE ON lab_tests FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_lab_templates_updated_at BEFORE UPDATE ON lab_templates FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_lab_investigations_updated_at BEFORE UPDATE ON lab_investigations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_lab_profile_test_links_updated_at BEFORE UPDATE ON lab_profile_test_links FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_lab_test_template_links_updated_at BEFORE UPDATE ON lab_test_template_links FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data for Units (assuming location_id = 1)
INSERT INTO lab_units (location_id, code, description, status) VALUES
(1, '21', '(-ve)', TRUE),
(1, '39', 'micro g/ml', TRUE),
(1, '071', 'number/ul', TRUE),
(1, '072', 'GPL/ml', TRUE),
(1, '073', 'MPL/ml', TRUE),
(1, '074', 'U/g Hb', TRUE),
(1, '077', 'HIV', TRUE),
(1, '078', 'S/U UNITS', TRUE),
(1, '079', 'RFV', TRUE),
(1, '080', 'S/C UNITS', TRUE);

-- Insert sample data for Specimens (assuming location_id = 1)
INSERT INTO lab_specimens (location_id, code, description, status) VALUES
(1, '001', 'Serum (1ml)', TRUE),
(1, '002', 'Urine (25 ml) 24 hrs Urine Volume', TRUE),
(1, '003', 'Serum (1 ml)', TRUE),
(1, '004', 'Citrated Plasma (1ml)', TRUE),
(1, '005', 'CSF (1ml)', TRUE),
(1, '006', 'Pleural Fluid (1ml)', TRUE),
(1, '007', 'Ascitic Fluid (1ml)', TRUE),
(1, '008', 'Pericardial Fluid (1ml)', TRUE),
(1, '009', 'Pus (1ml)', TRUE),
(1, '010', 'Plasma-EDTA (2ml)', TRUE);

-- Insert sample data for Containers (assuming location_id = 1)
INSERT INTO lab_containers (location_id, code, description, status) VALUES
(1, '035', 'ABG', TRUE),
(1, '024', 'Affirm Collection K', FALSE),
(1, '010', 'Aptima Gen Probe Unisex Swab', FALSE),
(1, '011', 'Aptima Gen Probe Urine Collection', FALSE),
(1, '012', 'BBL Anaerobic Culture', FALSE),
(1, '013', 'BBL Culture Swab Collection and Tr', FALSE),
(1, '018', 'BD Vacutainer Urine Transfer Straw', FALSE),
(1, '017', 'BD Vacutainer Urine Transfer Straw', FALSE),
(1, '032', 'BLACK VACCUTAINER', TRUE),
(1, '014', 'Blood Culture Collection bottles', TRUE);

-- Insert sample data for Methods (assuming location_id = 1)
INSERT INTO lab_methods (location_id, code, description, status) VALUES
(1, '032', 'Agarose Gel Electrophoresis', TRUE),
(1, '025', 'Agglutination', TRUE),
(1, '017', 'Agglutination Method', TRUE),
(1, '040', 'Agglutinition', TRUE),
(1, '081', 'Air Dried/Fixed Slides', TRUE),
(1, '047', 'Anaerobic Culture', TRUE),
(1, '049', 'Bactec Method', TRUE),
(1, '045', 'BACTEC MGIT', TRUE),
(1, '093', 'BCG Dye METHOD', TRUE),
(1, '037', 'Biochemical', TRUE);

-- Insert sample data for Tests (assuming location_id = 1)
INSERT INTO lab_tests (location_id, code, name, description, status) VALUES
(1, 'SR0001', 'COMPLETE STOOL EXAMINATION', 'COMPLETE STOOL EXAMINATION', TRUE),
(1, 'SR0002', 'PUS CULTURE AND SENSITIVITY', 'PUS CULTURE AND SENSITIVITY', TRUE),
(1, 'SR0003', 'BLOOD CULTURE AND SENSITIVITY', 'BLOOD CULTURE AND SENSITIVITY', TRUE),
(1, 'SR0004', 'URINE CULTURE AND SENSITIVITY', 'URINE CULTURE AND SENSITIVITY', TRUE),
(1, 'SR0005', 'STOOL CULTURE AND SENSITIVITY', 'STOOL CULTURE AND SENSITIVITY', TRUE),
(1, 'SR0006', 'VAGINAL SWAB CULTURE AND SENSITIVITY', 'VAGINAL SWAB CULTURE AND SENSITIVITY', TRUE),
(1, 'SR0007', 'SPUTUM CULTURE AND SENSITIVITY', 'SPUTUM CULTURE AND SENSITIVITY', TRUE),
(1, 'SR0008', 'TISSUE CULTURE AND SENITIVITY', 'TISSUE CULTURE AND SENITIVITY', TRUE),
(1, 'SR0009', 'OTHERS CULTURE AND SENITIVITY', 'OTHERS CULTURE AND SENITIVITY', TRUE),
(1, 'SR0010', 'SWAB CULTURE', 'SWAB CULTURE', TRUE);

-- Create indexes for better performance
CREATE INDEX idx_lab_units_location ON lab_units(location_id);
CREATE INDEX idx_lab_specimens_location ON lab_specimens(location_id);
CREATE INDEX idx_lab_containers_location ON lab_containers(location_id);
CREATE INDEX idx_lab_methods_location ON lab_methods(location_id);
CREATE INDEX idx_lab_tests_location ON lab_tests(location_id);
CREATE INDEX idx_lab_tests_code ON lab_tests(code);
CREATE INDEX idx_lab_tests_status ON lab_tests(status);
CREATE INDEX idx_lab_templates_location ON lab_templates(location_id);
CREATE INDEX idx_lab_investigations_location ON lab_investigations(location_id);