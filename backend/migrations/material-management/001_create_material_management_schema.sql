-- Material Management Service Database Schema
-- Database: hims_material_management

CREATE DATABASE hims_material_management;
\c hims_material_management;

-- Locations (replicated for reference)
CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    location_code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vendors table
CREATE TABLE vendors (
    id SERIAL PRIMARY KEY,
    vendor_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    gst_number VARCHAR(20),
    pan_number VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(vendor_code, location_id)
);

-- Items master table
CREATE TABLE items (
    id SERIAL PRIMARY KEY,
    item_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    stock_quantity INTEGER NOT NULL,
    min_stock_level INTEGER DEFAULT 10,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(item_code, location_id)
);

-- Purchase orders table
CREATE TABLE purchase_orders (
    id SERIAL PRIMARY KEY,
    po_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    vendor_id INTEGER NOT NULL REFERENCES vendors(id),
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'sent', 'approved', 'received', 'cancelled')),
    order_date DATE NOT NULL,
    expected_delivery_date DATE,
    created_by INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(po_number, location_id)
);

-- Purchase order items table
CREATE TABLE purchase_order_items (
    id SERIAL PRIMARY KEY,
    po_id INTEGER NOT NULL REFERENCES purchase_orders(id) ON DELETE CASCADE,
    item_id INTEGER NOT NULL REFERENCES items(id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL
);

-- GRN table
CREATE TABLE grn (
    id SERIAL PRIMARY KEY,
    grn_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    po_id INTEGER NOT NULL REFERENCES purchase_orders(id),
    vendor_id INTEGER NOT NULL REFERENCES vendors(id),
    invoice_number VARCHAR(50),
    invoice_date DATE,
    total_amount DECIMAL(10,2) NOT NULL,
    received_by INTEGER NOT NULL,
    received_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(grn_number, location_id)
);

-- GRN items table
CREATE TABLE grn_items (
    id SERIAL PRIMARY KEY,
    grn_id INTEGER NOT NULL REFERENCES grn(id) ON DELETE CASCADE,
    item_id INTEGER NOT NULL REFERENCES items(id),
    ordered_quantity INTEGER NOT NULL,
    received_quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL
);

-- Stock adjustments table
CREATE TABLE stock_adjustments (
    id SERIAL PRIMARY KEY,
    adjustment_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    item_id INTEGER NOT NULL REFERENCES items(id),
    adjustment_type VARCHAR(20) NOT NULL CHECK (adjustment_type IN ('increase', 'decrease')),
    quantity INTEGER NOT NULL,
    reason TEXT,
    adjusted_by INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(adjustment_number, location_id)
);

-- Stock transfers table
CREATE TABLE stock_transfers (
    id SERIAL PRIMARY KEY,
    transfer_number VARCHAR(20) NOT NULL,
    from_location_id INTEGER NOT NULL REFERENCES locations(id),
    to_location_id INTEGER NOT NULL REFERENCES locations(id),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'in_transit', 'received', 'cancelled')),
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    received_date TIMESTAMP,
    transferred_by INTEGER NOT NULL,
    received_by INTEGER,
    UNIQUE(transfer_number, from_location_id)
);

-- Stock transfer items table
CREATE TABLE stock_transfer_items (
    id SERIAL PRIMARY KEY,
    transfer_id INTEGER NOT NULL REFERENCES stock_transfers(id) ON DELETE CASCADE,
    item_id INTEGER NOT NULL REFERENCES items(id),
    quantity INTEGER NOT NULL,
    received_quantity INTEGER DEFAULT 0
);

-- RFQ tables
CREATE TABLE rfq (
    id SERIAL PRIMARY KEY,
    rfq_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    issue_date DATE NOT NULL,
    submission_deadline DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'issued' CHECK (status IN ('draft', 'issued', 'closed', 'cancelled')),
    created_by INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(rfq_number, location_id)
);

-- RFQ items
CREATE TABLE rfq_items (
    id SERIAL PRIMARY KEY,
    rfq_id INTEGER NOT NULL REFERENCES rfq(id) ON DELETE CASCADE,
    item_description TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    unit VARCHAR(20) NOT NULL,
    specifications TEXT
);

-- RFQ responses
CREATE TABLE rfq_responses (
    id SERIAL PRIMARY KEY,
    rfq_id INTEGER NOT NULL REFERENCES rfq(id),
    vendor_id INTEGER NOT NULL REFERENCES vendors(id),
    total_amount DECIMAL(10,2) NOT NULL,
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    validity_days INTEGER DEFAULT 30,
    terms_conditions TEXT,
    status VARCHAR(20) DEFAULT 'submitted' CHECK (status IN ('submitted', 'under_review', 'accepted', 'rejected'))
);

-- RFQ response items
CREATE TABLE rfq_response_items (
    id SERIAL PRIMARY KEY,
    response_id INTEGER NOT NULL REFERENCES rfq_responses(id) ON DELETE CASCADE,
    rfq_item_id INTEGER NOT NULL REFERENCES rfq_items(id),
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    delivery_days INTEGER,
    brand VARCHAR(100)
);

-- Contracts table
CREATE TABLE contracts (
    id SERIAL PRIMARY KEY,
    contract_number VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    vendor_id INTEGER NOT NULL REFERENCES vendors(id),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    contract_value DECIMAL(12,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('draft', 'active', 'expired', 'terminated')),
    terms_conditions TEXT,
    created_by INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(contract_number, location_id)
);

-- Material schemes table
CREATE TABLE material_schemes (
    id SERIAL PRIMARY KEY,
    scheme_code VARCHAR(20) NOT NULL,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    scheme_type VARCHAR(20) NOT NULL CHECK (scheme_type IN ('discount', 'free_goods', 'cashback')),
    value DECIMAL(10,2) NOT NULL,
    min_order_value DECIMAL(10,2),
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(scheme_code, location_id)
);

-- AI Insights table
CREATE TABLE ai_insights (
    id SERIAL PRIMARY KEY,
    location_id INTEGER NOT NULL REFERENCES locations(id),
    insight_type VARCHAR(50) NOT NULL CHECK (insight_type IN ('inventory_optimization', 'demand_forecast', 'cost_analysis', 'supplier_performance')),
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    recommendations JSONB,
    confidence_score DECIMAL(3,2) CHECK (confidence_score BETWEEN 0 AND 1),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_acknowledged BOOLEAN DEFAULT false,
    acknowledged_by INTEGER,
    acknowledged_at TIMESTAMP
);

-- Indexes
CREATE INDEX idx_vendors_location ON vendors(location_id);
CREATE INDEX idx_items_location ON items(location_id);
CREATE INDEX idx_purchase_orders_location ON purchase_orders(location_id);
CREATE INDEX idx_purchase_orders_vendor ON purchase_orders(vendor_id);
CREATE INDEX idx_grn_location ON grn(location_id);
CREATE INDEX idx_grn_po ON grn(po_id);
CREATE INDEX idx_stock_adjustments_location ON stock_adjustments(location_id);
CREATE INDEX idx_stock_transfers_from_location ON stock_transfers(from_location_id);
CREATE INDEX idx_stock_transfers_to_location ON stock_transfers(to_location_id);
CREATE INDEX idx_rfq_location ON rfq(location_id);
CREATE INDEX idx_rfq_responses_rfq ON rfq_responses(rfq_id);
CREATE INDEX idx_contracts_location ON contracts(location_id);
CREATE INDEX idx_contracts_vendor ON contracts(vendor_id);
CREATE INDEX idx_material_schemes_location ON material_schemes(location_id);
CREATE INDEX idx_ai_insights_location ON ai_insights(location_id);